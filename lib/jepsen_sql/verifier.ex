defmodule JepsenSql.Verifier do
  require Logger
  alias JepsenSql.Bank

  def verify(accounts_count, initial_balance) do
    expected_balance = accounts_count * initial_balance
    total_balance = Bank.total_balance

    if convert(total_balance) == expected_balance do
      Logger.info("Great!!! All money is here", ansi_color: :green)
    else
      raise "Missing money!!! Expect #{expected_balance}, got #{total_balance}"
    end

    negative_account_count = Bank.negative_account_count

    if negative_account_count == 0 do
      Logger.info("No account with negative balance", ansi_color: :green)
    else
      raise "There are #{negative_account_count} accounts with negative balance"
    end
  end

  def convert(%Decimal{sign: sign, coef: coef, exp: exp}) do
    Decimal.to_integer(%Decimal{sign: sign, coef: coef, exp: exp})
  end

  def convert(val), do: val
end
