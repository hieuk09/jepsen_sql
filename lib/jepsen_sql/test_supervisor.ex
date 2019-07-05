defmodule JepsenSql.TestSupervisor do
  use Supervisor
  alias JepsenSql.BankWorker
  alias JepsenSql.TransferWorker

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    workers = Enum.map(1..5, fn i ->
      %{
        id: "Test#{i}",
        #start: {BankWorker, :start_link, [:work]}
        start: {TransferWorker, :start_link, [:work]}
      }
    end)

    #children = workers ++ [JepsenSql.BankVerify]
    children = workers ++ [JepsenSql.TransferVerify]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
