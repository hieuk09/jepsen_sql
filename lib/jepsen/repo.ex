defmodule Jepsen.Repo do
  use Ecto.Repo,
    otp_app: :jepsen_sql,
    adapter: Ecto.Adapters.MySQL
  #use Ecto.Repo,
    #otp_app: :jepsen_sql,
    #adapter: Ecto.Adapters.Postgres

  def truncate(schema) do
    table_name = schema.__schema__(:source)
    query("TRUNCATE #{table_name}", [])
  end
end
