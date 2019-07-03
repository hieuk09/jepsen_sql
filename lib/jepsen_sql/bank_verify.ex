defmodule JepsenSql.BankVerify do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(_) do
    schedule_work()
    {:ok, [100, 100]}
  end

  @impl true
  def handle_info(:work, [accounts_count, initial_balance]) do
    JepsenSql.Verifier.verify(accounts_count, initial_balance)
    schedule_work()
    {:noreply, [accounts_count, initial_balance]}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
