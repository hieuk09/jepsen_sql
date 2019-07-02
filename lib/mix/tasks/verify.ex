defmodule Mix.Tasks.Verify do
  @moduledoc """
  The task that is use to verify database state after running test
  """

  require Logger
  use Mix.Task

  @shortdoc """
  verify bank database
  """
  def run(_args) do
    Mix.Task.run("app.start")
    accounts_count = 100
    initial_balance = 100
    expected_balance = accounts_count * initial_balance
    total_balance = JepsenSql.Bank.total_balance

    if convert(total_balance) == expected_balance do
      Logger.info("Great!!! All money is here", ansi_color: :green)
    else
      Logger.error("Missing money!!! Expect #{expected_balance}, got #{total_balance}")
    end

    negative_account_count = JepsenSql.Bank.negative_account_count

    if negative_account_count == 0 do
      Logger.info("No account with negative balance", ansi_color: :green)
    else
      Logger.error("There are #{negative_account_count} accounts with negative balance")
    end
  end

  def convert(%Decimal{sign: sign, coef: coef, exp: exp}) do
    Decimal.to_integer(%Decimal{sign: sign, coef: coef, exp: exp})
  end

  def convert(val), do: val
end
