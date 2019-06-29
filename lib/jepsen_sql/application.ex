defmodule JepsenSql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias JepsenSql.Test

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Jepsen.Repo,
      %{
        id: 'Test1',
        start: {Test, :start_link, [:work]}
      },
      %{
        id: 'Test2',
        start: {Test, :start_link, [:work]}
      },
      %{
        id: 'Test3',
        start: {Test, :start_link, [:work]}
      },
      %{
        id: 'Test4',
        start: {Test, :start_link, [:work]}
      },
      %{
        id: 'Test5',
        start: {Test, :start_link, [:work]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JepsenSql.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
