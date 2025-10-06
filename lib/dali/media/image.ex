defmodule Dali.Media.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "images" do
    field :filename, :string
    field :original_filename, :string
    field :content_type, :string
    field :file_size, :integer
    field :width, :integer
    field :height, :integer

    # File paths for different sizes
    field :original_path, :string
    field :large_path, :string
    field :thumbnail_path, :string

    # EXIF data as JSON
    field :exif_data, :map

    # Upload metadata
    field :upload_completed, :boolean, default: false
    field :processing_completed, :boolean, default: false
    field :alt_text, :string
    field :caption, :string

    # User scoping
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [
      :filename, :original_filename, :content_type, :file_size,
      :width, :height, :original_path, :alt_text, :caption,
      :upload_completed, :user_id
    ])
    |> validate_required([
      :filename, :original_filename, :content_type,
      :file_size, :original_path, :user_id
    ])
    |> validate_inclusion(:content_type, [
      "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    ])
    |> validate_number(:file_size, greater_than: 0)
    |> validate_length(:original_filename, max: 255)
    |> validate_length(:alt_text, max: 500)
  end

  @doc false
  def processing_changeset(image, attrs) do
    image
    |> cast(attrs, [
      :large_path, :thumbnail_path, :exif_data,
      :processing_completed, :width, :height
    ])
  end

  @doc """
  Returns the URL for the specified size of the image.
  """
  def url(image, size \\ :original) do
    case size do
      :original -> "/uploads/#{image.original_path}"
      :large -> if image.large_path, do: "/uploads/#{image.large_path}", else: url(image, :original)
      :thumbnail -> if image.thumbnail_path, do: "/uploads/#{image.thumbnail_path}", else: url(image, :original)
    end
  end

  @doc """
  Returns a human-readable file size.
  """
  def human_file_size(image) do
    human_file_size_from_bytes(image.file_size)
  end

  defp human_file_size_from_bytes(bytes) do
    cond do
      bytes >= 1_048_576 -> "#{Float.round(bytes / 1_048_576, 1)} MB"
      bytes >= 1_024 -> "#{Float.round(bytes / 1_024, 1)} KB"
      true -> "#{bytes} B"
    end
  end
end
