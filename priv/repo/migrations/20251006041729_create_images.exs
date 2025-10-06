defmodule Dali.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :filename, :string, null: false
      add :original_filename, :string, null: false
      add :content_type, :string, null: false
      add :file_size, :integer, null: false
      add :width, :integer
      add :height, :integer

      # File paths for different sizes
      add :original_path, :string, null: false
      add :large_path, :string
      add :thumbnail_path, :string

      # EXIF data as JSON
      add :exif_data, :map

      # Upload metadata
      add :upload_completed, :boolean, default: false
      add :processing_completed, :boolean, default: false
      add :alt_text, :string
      add :caption, :text

      # User scoping
      add :user_id, references(:users, on_delete: :delete_all, type: :integer), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:images, [:user_id])
    create index(:images, [:filename])
    create index(:images, [:content_type])
    create index(:images, [:upload_completed])
    create index(:images, [:processing_completed])
  end
end
