defmodule Mix.Tasks.Setup do
  @moduledoc """
  The task that is use to setup database for testing
  """

  use Mix.Task

  @shortdoc """
  populates the bank database
  """
  def run(_args) do
    Mix.Task.run("app.start")
    accounts_count = 100
    initial_balance = 100
    JepsenSql.Bank.populate(accounts_count, initial_balance)
    IO.puts("Generate #{accounts_count} accounts with initial balance at #{initial_balance}")
  end
end
