defmodule Sorteio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SorteioWeb.Telemetry,
      Sorteio.Repo,
      {DNSCluster, query: Application.get_env(:sorteio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sorteio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sorteio.Finch},
      # Start a worker by calling: Sorteio.Worker.start_link(arg)
      # {Sorteio.Worker, arg},
      # Start to serve requests, typically the last entry
      SorteioWeb.Endpoint,
      SorteioWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sorteio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SorteioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
