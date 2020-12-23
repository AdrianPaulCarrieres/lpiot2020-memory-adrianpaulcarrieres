defmodule MemoryBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MemoryBackend.Repo,
      # Start the Telemetry supervisor
      MemoryBackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MemoryBackend.PubSub},
      # Start the Endpoint (http/https)
      MemoryBackendWeb.Endpoint
      # Start a worker by calling: MemoryBackend.Worker.start_link(arg)
      # {MemoryBackend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MemoryBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MemoryBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
