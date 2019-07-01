defmodule JepsenSql.Bank do
  alias Jepsen.Account
  alias Jepsen.Repo
  import Ecto.Query

  def populate(accounts_count, initial_balance) do
    Repo.truncate(Account)
    accounts = generate_accounts(accounts_count, initial_balance)
    Repo.insert_all(Account, accounts)
  end

  def move_money(accounts_count) do
    account_id_1 = :rand.uniform(accounts_count)
    account_id_2 = :rand.uniform(accounts_count)

    try do
      Repo.transaction(fn ->
        account_2 = Account |> Repo.get(account_id_2)
        transfer = random(account_2.balance)
        negative_transfer = -transfer

        IO.puts("Transfer $#{transfer} from #{account_id_2} to #{account_id_1}")
        update_1 = from(a in Account, where: [id: ^account_id_2], update: [inc: [balance: ^negative_transfer]])
        update_2 = from(a in Account, where: [id: ^account_id_1], update: [inc: [balance: ^transfer]])

        with {1, _} <- Repo.update_all(update_2, []),
             {1, _} <- Repo.update_all(update_1, []) do
          {:ok}
        else
          val ->
            Repo.rollback(val)
        end
      end)
    rescue
      e in Postgrex.Error -> IO.inspect(e)
      e in Mariaex.Error -> IO.inspect(e)
    end
  end

  def total_balance do
    Repo.one(from a in Account, select: sum(a.balance))
  end

  def negative_account_count do
    Repo.one(from a in Account, select: count(a.id), where: a.balance < 0)
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

  def random(0), do: 0
  def random(n), do: :rand.uniform(n)
end
