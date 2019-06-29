defmodule JepsenSql.Test do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(_) do
    schedule_work()
    {:ok, 100}
  end

  @impl true
  def handle_info(:work, accounts_count) do
    JepsenSql.Bank.move_money(accounts_count)
    schedule_work()
    {:noreply, accounts_count}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10)
  end
end
