defmodule JepsenSql.Bank do
  alias Jepsen.Account
  alias Jepsen.Repo

  def populate(accounts_count, initial_balance) do
    Repo.truncate(Account)
    accounts = generate_accounts(accounts_count, initial_balance)
    Repo.insert_all(Account, accounts)
  end

  def move_money(accounts_count) do
    account_id_1 = :rand.uniform(accounts_count)
    account_id_2 = :rand.uniform(accounts_count)

    IO.puts("Move $10 from #{account_id_2} to #{account_id_1}")

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
