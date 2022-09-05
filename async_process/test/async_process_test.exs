defmodule AsyncProcessTest do
  use ExUnit.Case
  doctest AsyncProcess

  test "greets the world" do
    assert AsyncProcess.hello() == :world
  end
end
