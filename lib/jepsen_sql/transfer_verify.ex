defmodule JepsenSql.TransferVerify do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(_) do
    schedule_work()
    {:ok, 1}
  end

  @impl true
  def handle_info(:work, account_id) do
    JepsenSql.Verifier.verify_balance(account_id)
    schedule_work()
    {:noreply, account_id}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 100)
  end
end
