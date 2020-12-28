defmodule MemoryBackend.Repo do
  use Ecto.Repo,
    otp_app: :memory_backend,
    adapter: Ecto.Adapters.Postgres,
    loggers: []
end
