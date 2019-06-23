defmodule Accounts.Repo do
  use Ecto.Repo,
    otp_app: :jepsen_sql,
    adapter: Ecto.Adapters.Postgres
end
