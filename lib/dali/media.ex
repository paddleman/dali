defmodule Dali.Media do
  @moduledoc """
  The Media context for handling image uploads and processing.
  """

  import Ecto.Query, warn: false
  alias Dali.Repo
  alias Dali.Media.Image, as: Pics

  @doc """
  Returns the list of images for a user.
  """
  def list_images(current_scope) do
    from(i in Pics, where: i.user_id == ^current_scope.user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single image.
  """
  def get_image(current_scope, id) do
    from(i in Pics, where: i.id == ^id and i.user_id == ^current_scope.user.id)
    |> Repo.one()
  end

  @doc """
  Gets a single image, raising an error if not found or not owned by user.
  """
  def get_image!(current_scope, id) do
    case get_image(current_scope, id) do
      nil -> raise Ecto.NoResultsError, queryable: Pics
      image -> image
    end
  end

  @doc """
  Creates an image record and processes the uploaded file.
  """
  def create_image(current_scope, attrs \\ %{}) do
    %Pics{user_id: current_scope.user.id}
    |> Pics.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, image} -> process_image_async(image)
      error -> error
    end
  end

  @doc """
  Updates an image.
  """
  def update_image(%Pics{} = image, attrs) do
    image
    |> Pics.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an image and its files.
  """
  def delete_image(current_scope, %Pics{} = image) do
    # Ensure user owns the image
    ^image = get_image!(current_scope, image.id)
    
    # Delete files
    delete_image_files(image)
    
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.
  """
  def change_image(current_scope, %Pics{} = image, attrs \\ %{}) do
    # Ensure user owns the image if it exists
    if image.id, do: get_image!(current_scope, image.id)
    
    Pics.changeset(image, attrs)
  end

  # Private functions

  defp process_image_async(image) do
    # Start async processing
    Task.start(fn -> process_image_files(image) end)
    {:ok, image}
  end

  defp process_image_files(image) do
    try do
      upload_dir = Application.fetch_env!(:dali, :uploads_directory)
      original_file = Path.join(upload_dir, image.original_path)
      
      # Extract EXIF data
      exif_data = extract_exif_data(original_file)
      
      # Create different sizes
      large_path = create_large_image(original_file, image.filename)
      thumbnail_path = create_thumbnail(original_file, image.filename)
      
      # Update image record
      image
      |> Pics.processing_changeset(%{
        large_path: large_path,
        thumbnail_path: thumbnail_path,
        exif_data: exif_data,
        processing_completed: true
      })
      |> Repo.update()
      
    rescue
      error ->
        # Log error and mark processing as failed
        require Logger
        Logger.error("Image processing failed for #{image.id}: #{inspect(error)}")
        
        image
        |> Pics.processing_changeset(%{processing_completed: false})
        |> Repo.update()
    end
  end

  defp extract_exif_data(file_path) do
    case Image.exif(file_path) do
      {:ok, exif} -> exif
      {:error, _} -> %{}
    end
  rescue
    _ -> %{}
  end

  defp create_large_image(original_file, filename) do
    large_filename = "large_" <> filename
    upload_dir = Application.fetch_env!(:dali, :uploads_directory)
    large_path = Path.join(upload_dir, large_filename)
    
    case Image.open(original_file) do
      {:ok, image} ->
        # Resize to max 1200px on longest side, maintaining aspect ratio
        case Image.resize(image, 1200, height: 1200) do
          {:ok, resized} ->
            case Image.write(resized, large_path) do
              :ok -> large_filename
              {:error, _} -> nil
            end
          {:error, _} -> nil
        end
      {:error, _} ->
        nil
    end
  end

  defp create_thumbnail(original_file, filename) do
    thumbnail_filename = "thumb_" <> filename
    upload_dir = Application.fetch_env!(:dali, :uploads_directory)
    thumbnail_path = Path.join(upload_dir, thumbnail_filename)
    
    case Image.open(original_file) do
      {:ok, image} ->
        # Create 300x300 thumbnail, cropped to center
        case Image.thumbnail(image, 300) do
          {:ok, thumbnail} ->
            case Image.write(thumbnail, thumbnail_path) do
              :ok -> thumbnail_filename
              {:error, _} -> nil
            end
          {:error, _} -> nil
        end
      {:error, _} ->
        nil
    end
  end

  defp delete_image_files(image) do
    upload_dir = Application.fetch_env!(:dali, :uploads_directory)
    
    [image.original_path, image.large_path, image.thumbnail_path]
    |> Enum.reject(&is_nil/1)
    |> Enum.each(fn path ->
      full_path = Path.join(upload_dir, path)
      File.rm(full_path)
    end)
  end
end