defmodule Jepsen.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :integer
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:balance])
  end
end
