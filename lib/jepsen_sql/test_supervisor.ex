defmodule JepsenSql.TestSupervisor do
  use Supervisor
  alias JepsenSql.BankWorker

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = Enum.map(1..5, fn i ->
      %{
        id: "Test#{i}",
        start: {BankWorker, :start_link, [:work]}
      }
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
