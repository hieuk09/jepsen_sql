defmodule JepsenSqlTest do
  use ExUnit.Case
  doctest JepsenSql

  test "greets the world" do
    assert JepsenSql.hello() == :world
  end
end
