defmodule Dali.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DaliWeb.Telemetry,
      Dali.Repo,
      {DNSCluster, query: Application.get_env(:dali, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dali.PubSub},
      # Start a worker by calling: Dali.Worker.start_link(arg)
      # {Dali.Worker, arg},
      # Start to serve requests, typically the last entry
      DaliWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dali.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DaliWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
