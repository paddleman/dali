defmodule DaliWeb.Router do
  use DaliWeb, :router

  import DaliWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DaliWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DaliWeb do
    pipe_through :browser

    live "/", SplashLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DaliWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dali, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DaliWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", DaliWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DaliWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
      live "/users/profile", UserLive.Profile, :index

      live "/dali", HomeLive

      live "/persons", PersonLive.Index, :index
      live "/persons/new", PersonLive.Form, :new
      live "/persons/:id", PersonLive.Show, :show
      live "/persons/:id/edit", PersonLive.Form, :edit

      # Lookup Tables
      live "/organization_types", OrganizationTypeLive.Index, :index
      live "/organization_types/new", OrganizationTypeLive.Form, :new
      live "/organization_types/:id", OrganizationTypeLive.Show, :show
      live "/organization_types/:id/edit", OrganizationTypeLive.Form, :edit

      live "/disciplines", DisciplineLive.Index, :index
      live "/disciplines/new", DisciplineLive.Form, :new
      live "/disciplines/:id", DisciplineLive.Show, :show
      live "/disciplines/:id/edit", DisciplineLive.Form, :edit

      live "/task_types", TaskTypeLive.Index, :index
      live "/task_types/new", TaskTypeLive.Form, :new
      live "/task_types/:id", TaskTypeLive.Show, :show
      live "/task_types/:id/edit", TaskTypeLive.Form, :edit

      # Organizations
      live "/organizations", OrganizationLive.Index, :index
      live "/organizations/new", OrganizationLive.Form, :new
      live "/organizations/:id", OrganizationLive.Show, :show
      live "/organizations/:id/edit", OrganizationLive.Form, :edit

    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", DaliWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{DaliWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
