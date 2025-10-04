#!/usr/bin/env elixir

defmodule DaliCloner do
  @moduledoc """
  Script to clone the Dali repository and rename it for use as a template.

  Usage:
    ./clone_and_rename.exs <new_app_name> [target_directory]

  Example:
    ./clone_and_rename.exs myapp /path/to/projects
    ./clone_and_rename.exs "My Cool App" ./my_apps
  """

  @repo_url "https://github.com/paddleman/dali.git"

  def main(args) do
    case args do
      [app_name | rest] ->
        target_dir =
          case rest do
            [dir] -> dir
            [] -> "."
          end

        run(app_name, target_dir)

      _ ->
        print_usage()
        System.halt(1)
    end
  end

  defp run(app_name, target_dir) do
    # Validate and process the app name
    {module_name, app_atom, dir_name} = process_app_name(app_name)

    IO.puts("🚀 Cloning Dali repository...")
    IO.puts("   New App Name: #{app_name}")
    IO.puts("   Module Name: #{module_name}")
    IO.puts("   App Atom: #{app_atom}")
    IO.puts("   Directory: #{dir_name}")
    IO.puts("")

    # Create full target path
    full_target_path = Path.join(target_dir, dir_name)

    # Clone the repository
    clone_repo(full_target_path)

    # Rename all occurrences
    IO.puts("🔄 Renaming modules and configurations...")
    rename_all_occurrences(full_target_path, module_name, app_atom)

    # Clean up git history
    IO.puts("🧹 Cleaning up git history...")
    clean_git_history(full_target_path)

    # Update README
    update_readme(full_target_path, app_name, module_name)

    IO.puts("✅ Successfully created #{app_name} from Dali template!")
    IO.puts("")
    IO.puts("📋 Next steps:")
    IO.puts("   1. cd #{full_target_path}")
    IO.puts("   2. mix deps.get")
    IO.puts("   3. mix ecto.setup")
    IO.puts("   4. mix phx.server")
    IO.puts("")
    IO.puts("🎉 Happy coding!")
  end

  defp process_app_name(app_name) do
    # Convert app name to module name (PascalCase)
    module_name =
      app_name
      |> String.replace(~r/[^a-zA-Z0-9\s]/, "")
      |> String.split()
      |> Enum.map(&String.capitalize/1)
      |> Enum.join("")

    # Convert app name to atom (snake_case)
    app_atom =
      app_name
      |> String.downcase()
      |> String.replace(~r/[^a-zA-Z0-9]/, "_")
      |> String.replace(~r/_+/, "_")
      |> String.trim("_")

    # Convert app name to directory name (kebab-case)
    dir_name =
      app_name
      |> String.downcase()
      |> String.replace(~r/[^a-zA-Z0-9]/, "-")
      |> String.replace(~r/-+/, "-")
      |> String.trim("-")

    {module_name, app_atom, dir_name}
  end

  defp clone_repo(target_path) do
    case System.cmd("git", ["clone", @repo_url, target_path], stderr_to_stdout: true) do
      {_output, 0} ->
        :ok

      {output, _} ->
        IO.puts("❌ Failed to clone repository:")
        IO.puts(output)
        System.halt(1)
    end
  end

  defp rename_all_occurrences(project_path, new_module_name, new_app_atom) do
    # Define the replacement mappings
    replacements = [
      # Module names
      {"Dali", new_module_name},
      {"DaliWeb", "#{new_module_name}Web"},

      # App atoms and names
      {":dali", ":#{new_app_atom}"},
      {"dali", new_app_atom},

      # Database names
      {"dali_dev", "#{new_app_atom}_dev"},
      {"dali_test", "#{new_app_atom}_test"},
      {"dali_prod", "#{new_app_atom}_prod"},

      # Session and cookie keys
      {"_dali_key", "_#{new_app_atom}_key"},
      {"_dali_web_user_remember_me", "_#{new_app_atom}_web_user_remember_me"},

      # File paths and references
      {"dali/", "#{new_app_atom}/"},
      {"\"dali\"", "\"#{new_app_atom}\""},
      {"'dali'", "'#{new_app_atom}'"}
    ]

    # Get all files to process
    files_to_process = get_files_to_process(project_path)

    # Apply replacements to each file
    Enum.each(files_to_process, fn file_path ->
      process_file(file_path, replacements)
    end)

    # Rename directories and files
    rename_directories_and_files(project_path, new_app_atom)
  end

  defp get_files_to_process(project_path) do
    # Extensions to process
    extensions = [".ex", ".exs", ".heex", ".md", ".json", ".js", ".css", ".html"]

    # Find all files with the specified extensions
    project_path
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(fn path ->
      File.regular?(path) and
        Enum.any?(extensions, &String.ends_with?(path, &1))
    end)
    |> Enum.reject(fn path ->
      # Skip certain directories
      String.contains?(path, "/.git/") or
        String.contains?(path, "/node_modules/") or
        String.contains?(path, "/_build/") or
        String.contains?(path, "/deps/") or
        String.contains?(path, "/priv/static/assets/")
    end)
  end

  defp process_file(file_path, replacements) do
    case File.read(file_path) do
      {:ok, content} ->
        # Apply all replacements
        updated_content =
          Enum.reduce(replacements, content, fn {old, new}, acc ->
            String.replace(acc, old, new)
          end)

        # Write back if content changed
        if updated_content != content do
          File.write!(file_path, updated_content)
          IO.puts("   📝 Updated: #{Path.relative_to_cwd(file_path)}")
        end

      {:error, reason} ->
        IO.puts("   ⚠️  Could not read #{file_path}: #{reason}")
    end
  end

  defp rename_directories_and_files(project_path, new_app_atom) do
    # Rename lib/dali.ex to lib/new_app_atom.ex
    old_dali_ex = Path.join(project_path, "lib/dali.ex")
    new_dali_ex = Path.join(project_path, "lib/#{new_app_atom}.ex")
    if File.exists?(old_dali_ex) do
      File.rename!(old_dali_ex, new_dali_ex)
      IO.puts("   📄 Renamed: lib/dali.ex -> lib/#{new_app_atom}.ex")
    end

    # Rename lib/dali_web.ex to lib/new_app_atom_web.ex
    old_dali_web_ex = Path.join(project_path, "lib/dali_web.ex")
    new_dali_web_ex = Path.join(project_path, "lib/#{new_app_atom}_web.ex")
    if File.exists?(old_dali_web_ex) do
      File.rename!(old_dali_web_ex, new_dali_web_ex)
      IO.puts("   📄 Renamed: lib/dali_web.ex -> lib/#{new_app_atom}_web.ex")
    end

    # Rename lib/dali to lib/new_app_name
    old_lib_dir = Path.join(project_path, "lib/dali")
    new_lib_dir = Path.join(project_path, "lib/#{new_app_atom}")

    if File.dir?(old_lib_dir) do
      File.rename!(old_lib_dir, new_lib_dir)
      IO.puts("   📁 Renamed: lib/dali -> lib/#{new_app_atom}")
    end

    # Rename lib/dali_web to lib/new_app_name_web
    old_web_dir = Path.join(project_path, "lib/dali_web")
    new_web_dir = Path.join(project_path, "lib/#{new_app_atom}_web")

    if File.dir?(old_web_dir) do
      File.rename!(old_web_dir, new_web_dir)
      IO.puts("   📁 Renamed: lib/dali_web -> lib/#{new_app_atom}_web")
    end

    # Rename test/dali_web to test/new_app_name_web
    old_test_web_dir = Path.join(project_path, "test/dali_web")
    new_test_web_dir = Path.join(project_path, "test/#{new_app_atom}_web")

    if File.dir?(old_test_web_dir) do
      File.rename!(old_test_web_dir, new_test_web_dir)
      IO.puts("   📁 Renamed: test/dali_web -> test/#{new_app_atom}_web")
    end

    # Rename test/dali to test/new_app_name
    old_test_dir = Path.join(project_path, "test/dali")
    new_test_dir = Path.join(project_path, "test/#{new_app_atom}")

    if File.dir?(old_test_dir) do
      File.rename!(old_test_dir, new_test_dir)
      IO.puts("   📁 Renamed: test/dali -> test/#{new_app_atom}")
    end
  end

  defp clean_git_history(project_path) do
    # Remove the existing git repository and initialize a new one
    git_dir = Path.join(project_path, ".git")

    if File.dir?(git_dir) do
      File.rm_rf!(git_dir)
    end

    # Initialize new git repository
    case System.cmd("git", ["init"], cd: project_path, stderr_to_stdout: true) do
      {_output, 0} ->
        # Add all files to git
        System.cmd("git", ["add", "."], cd: project_path)

        System.cmd("git", ["commit", "-m", "Initial commit from Dali template"],
          cd: project_path
        )

        IO.puts("   🔧 Initialized new git repository")

      {output, _} ->
        IO.puts("   ⚠️  Could not initialize git repository: #{output}")
    end
  end

  defp update_readme(project_path, app_name, module_name) do
    readme_path = Path.join(project_path, "README.md")

    new_readme_content = """
    # #{app_name}

    A Phoenix application created from the Dali template.

    ## Getting Started

    To start your Phoenix server:

    * Install dependencies with `mix deps.get`
    * Create and migrate your database with `mix ecto.setup`
    * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

    Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

    ## Configuration

    This application was generated from the Dali template. Key components include:

    * **Authentication**: User registration, login, and session management
    * **User Profiles**: Avatar uploads, profile editing with modal interface
    * **Theming**: Custom DaisyUI theme with OKLCH color support
    * **Database**: PostgreSQL with Ecto
    * **Styling**: Tailwind CSS with DaisyUI components

    ## Learn More

    * Official website: https://www.phoenixframework.org/
    * Guides: https://hexdocs.pm/phoenix/overview.html
    * Docs: https://hexdocs.pm/phoenix
    * Forum: https://elixirforum.com/c/phoenix-forum
    * Source: https://github.com/phoenixframework/phoenix

    ## Template Source

    This application was generated from the Dali template:
    https://github.com/paddleman/dali

    ---

    Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
    """

    File.write!(readme_path, new_readme_content)
    IO.puts("   📄 Updated README.md")
  end

  defp print_usage do
    IO.puts("""
    Dali Template Cloner

    Usage:
      ./clone_and_rename.exs <app_name> [target_directory]

    Arguments:
      app_name         Name of your new application (can contain spaces)
      target_directory Directory where to create the new app (default: current directory)

    Examples:
      ./clone_and_rename.exs "My App"
      ./clone_and_rename.exs myapp /path/to/projects
      ./clone_and_rename.exs "Cool Project" ./apps

    The script will:
      1. Clone the Dali repository
      2. Rename all modules, configurations, and database references
      3. Update directory structure
      4. Clean git history and create fresh repository
      5. Update README with your app information

    Requirements:
      - git must be installed and available in PATH
      - Elixir must be installed to run this script
    """)
  end
end

# Run the script
DaliCloner.main(System.argv())
