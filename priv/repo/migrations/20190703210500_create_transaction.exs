defmodule Jepsen.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :account_id, :integer, null: false
      add :amount, :integer, null: false
      add :type, :string, null: false
    end
  end
end
