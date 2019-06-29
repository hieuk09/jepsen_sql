defmodule JepsenSql.Bank do
  use GenServer
  alias Jepsen.Account
  alias Jepsen.Repo

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def handle_call({:populate, accounts_count, initial_balance}, _, _) do
    Repo.truncate(Account)
    accounts = generate_accounts(accounts_count, initial_balance)
    result = Repo.insert_all(Account, accounts)
    { :reply, result, [accounts_count, initial_balance] }
  end

  @impl true
  def handle_call({:move_money, accounts_count}, _, _) do
    account_id_1 = :rand.uniform(accounts_count)
    account_id_2 = :rand.uniform(accounts_count)

    Repo.transaction(fn ->
      account_1 = Account |> Repo.get(account_id_1)
      account_2 = Account |> Repo.get(account_id_2)

      if account_2.balance >= 10 do
        changeset_1 = Account.changeset(account_1, %{balance: account_1.balance + 10})
        changeset_2 = Account.changeset(account_2, %{balance: account_1.balance - 10})
        Repo.update(changeset_1)
        Repo.update(changeset_2)
      end
    end)

    { :reply, true, nil }
  end

  def generate_accounts(1, initial_balance) do
    [%{balance: initial_balance, id: 1}]
  end

  def generate_accounts(0, _) do
    []
  end

  def generate_accounts(accounts_count, initial_balance) do
    [%{balance: initial_balance, id: accounts_count} | generate_accounts(accounts_count - 1, initial_balance)]
  end
end
