# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :memory_backend,
  ecto_repos: [MemoryBackend.Repo]

# Configures the endpoint
config :memory_backend, MemoryBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zhH80043EKJDhnXi2rAaANic7pJogCZXOwMhX4aY3XQJUva1TEOcVmNiEM8+WPUQ",
  render_errors: [view: MemoryBackendWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MemoryBackend.PubSub,
  live_view: [signing_salt: "Zebs2YOR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
