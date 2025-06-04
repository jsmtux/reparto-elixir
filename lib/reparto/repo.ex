defmodule Reparto.Repo do
  use Ecto.Repo,
    otp_app: :reparto,
    adapter: Ecto.Adapters.Postgres
end
