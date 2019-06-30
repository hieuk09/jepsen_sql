defmodule Mix.Tasks.Bank do
  @moduledoc """
  The task that is use to setup database for testing
  """

  use Mix.Task

  @shortdoc """
  populates the bank database
  """
  def run(_args) do
    Mix.Task.run("app.start")
    JepsenSql.Bank.populate(100, 100)
  end
end
