defmodule DaliWeb.ImageUploadComponent do
  @moduledoc """
  A reusable image upload component with thumbnail generation.

  Usage in a LiveView:
    <.live_component
      module={DaliWeb.ImageUploadComponent}
      id="image-upload"
      current_scope={@current_scope}
      uploaded_images={@uploaded_images}
      max_files={5}
      accept={~w(.jpg .jpeg .png .gif .webp)}
    />

  Then handle events in your LiveView:
    def handle_info({:image_uploaded, image}, socket) do
      # Add to your uploaded_images list
    end
  """

  use DaliWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="image-upload-component">
      <div class="mb-4">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          {assigns[:label] || "Upload Images"}
        </label>

        <!-- File Input -->
        <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:border-gray-400 transition-colors">
          <div class="space-y-1 text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
              <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
            <div class="flex text-sm text-gray-600">
              <label for={"#{@id}-file-input"} class="relative cursor-pointer bg-white rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500">
                <span>Upload files</span>
                <input
                  id={"#{@id}-file-input"}
                  type="file"
                  class="sr-only"
                  multiple={@max_files > 1}
                  accept={Enum.join(@accept, ",")}
                  phx-hook="ImageUpload"
                  phx-target={@myself}
                />
              </label>
              <p class="pl-1">or drag and drop</p>
            </div>
            <p class="text-xs text-gray-500">
              {Enum.join(@accept, ", ")} up to {@max_file_size_mb}MB each
            </p>
          </div>
        </div>
      </div>

      <!-- Upload Progress -->
      <%= if @uploading do %>
        <div class="mb-4">
          <div class="bg-blue-50 border border-blue-200 rounded-md p-4">
            <div class="flex">
              <div class="flex-shrink-0">
                <svg class="animate-spin h-5 w-5 text-blue-400" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-blue-800">Uploading images...</p>
                <p class="text-sm text-blue-600">Processing {@upload_count} file(s)</p>
              </div>
            </div>
          </div>
        </div>
      <% end %>

      <!-- Error Messages -->
      <%= if @error_message do %>
        <div class="mb-4">
          <div class="bg-red-50 border border-red-200 rounded-md p-4">
            <div class="flex">
              <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                </svg>
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-red-800">Upload Error</p>
                <p class="text-sm text-red-600">{@error_message}</p>
              </div>
            </div>
          </div>
        </div>
      <% end %>

      <!-- Uploaded Images Preview -->
      <%= if length(@uploaded_images) > 0 do %>
        <div class="mb-4">
          <h4 class="text-sm font-medium text-gray-700 mb-2">Uploaded Images</h4>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            <%= for image <- @uploaded_images do %>
              <div class="relative group">
                <img
                  src={Dali.Media.Image.url(image, :thumbnail)}
                  alt={image.alt_text || image.original_filename}
                  class="w-full h-24 object-cover rounded-lg border border-gray-200"
                />
                <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-opacity rounded-lg flex items-center justify-center">
                  <button
                    type="button"
                    class="opacity-0 group-hover:opacity-100 bg-red-600 text-white rounded-full p-1 hover:bg-red-700 transition-all"
                    phx-click="remove_image"
                    phx-value-id={image.id}
                    phx-target={@myself}
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
                <p class="text-xs text-gray-500 mt-1 truncate">{image.original_filename}</p>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:uploaded_images, [])
     |> assign(:uploading, false)
     |> assign(:upload_count, 0)
     |> assign(:error_message, nil)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_defaults()

    {:ok, socket}
  end

  @impl true
  def handle_event("upload_files", %{"files" => files}, socket) do
    if length(files) > socket.assigns.max_files do
      {:noreply, assign(socket, error_message: "Maximum #{socket.assigns.max_files} files allowed")}
    else
      socket =
        socket
        |> assign(:uploading, true)
        |> assign(:upload_count, length(files))
        |> assign(:error_message, nil)

      # Process files asynchronously
      Task.start(fn -> process_file_uploads(files, socket.assigns) end)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("remove_image", %{"id" => image_id}, socket) do
    # Get the actual image record first
    image = Enum.find(socket.assigns.uploaded_images, &(&1.id == image_id))

    case image && Dali.Media.delete_image(socket.assigns.current_scope, image) do
      {:ok, _} ->
        uploaded_images = Enum.reject(socket.assigns.uploaded_images, &(&1.id == image_id))
        notify_parent({:image_removed, image_id})
        {:noreply, assign(socket, uploaded_images: uploaded_images)}

      _ ->
        {:noreply, assign(socket, error_message: "Failed to remove image")}
    end
  end

  # Private functions

  defp assign_defaults(socket) do
    socket
    |> assign_new(:max_files, fn -> 5 end)
    |> assign_new(:max_file_size_mb, fn -> 10 end)
    |> assign_new(:accept, fn -> ~w(.jpg .jpeg .png .gif .webp) end)
  end

  defp process_file_uploads(files, assigns) do
    upload_dir = Application.fetch_env!(:dali, :uploads_directory)
    File.mkdir_p!(upload_dir)

    results =
      Enum.map(files, fn file ->
        process_single_file(file, assigns, upload_dir)
      end)

    case Enum.split_with(results, &match?({:ok, _}, &1)) do
      {successes, []} ->
        images = Enum.map(successes, fn {:ok, image} -> image end)
        send(self(), {:upload_complete, images})

      {_, errors} ->
        error_message =
          errors
          |> Enum.map(fn {:error, msg} -> msg end)
          |> Enum.join(", ")
        send(self(), {:upload_error, error_message})
    end
  end

  defp process_single_file(file, assigns, upload_dir) do
    # Generate unique filename
    timestamp = System.system_time(:millisecond)
    extension = Path.extname(file["name"])
    unique_filename = "#{timestamp}_#{:crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)}#{extension}"
    file_path = Path.join(upload_dir, unique_filename)

    with :ok <- File.write(file_path, file["content"]),
         {:ok, image_info} <- get_image_info(file_path),
         {:ok, image} <- create_image_record(file, unique_filename, image_info, assigns) do
      {:ok, image}
    else
      {:error, reason} ->
        File.rm(file_path)  # Cleanup on error
        {:error, "Failed to upload #{file["name"]}: #{inspect(reason)}"}
    end
  end

  defp get_image_info(file_path) do
    case Image.open(file_path) do
      {:ok, image} ->
        {:ok, %{
          width: Image.width(image),
          height: Image.height(image)
        }}
      error -> error
    end
  end

  defp create_image_record(file, unique_filename, image_info, assigns) do
    attrs = %{
      filename: unique_filename,
      original_filename: file["name"],
      content_type: file["type"],
      file_size: file["size"],
      width: image_info.width,
      height: image_info.height,
      original_path: unique_filename,
      upload_completed: true
    }

    Dali.Media.create_image(assigns.current_scope, attrs)
  end

  defp notify_parent(message) do
    send(self(), {:image_upload_event, message})
  end
end
