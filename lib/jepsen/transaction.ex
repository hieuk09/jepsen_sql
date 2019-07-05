defmodule Jepsen.Transaction do
  use Ecto.Schema

  schema "transactions" do
    field :account_id, :integer
    field :amount, :integer
    field :type, :string
  end
end
