defmodule Mix.Tasks.Verify do
  @moduledoc """
  The task that is use to verify database state after running test
  """

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

    if total_balance != expected_balance do
      IO.puts("Missing money!!! Expect #{expected_balance}, got #{total_balance}")
    else
      IO.puts("Great!!! All money is here")
    end
  end
end
