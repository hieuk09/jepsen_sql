defmodule Jepsen.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do

    create table(:accounts) do
      add :balance, :integer, null: false
    end
  end
end
