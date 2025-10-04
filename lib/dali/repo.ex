defmodule Dali.Repo do
  use Ecto.Repo,
    otp_app: :dali,
    adapter: Ecto.Adapters.Postgres
end
