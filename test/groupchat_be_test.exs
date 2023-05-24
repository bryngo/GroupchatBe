defmodule GroupchatBeTest do
  use ExUnit.Case
  doctest GroupchatBe

  test "greets the world" do
    assert GroupchatBe.hello() == :world
  end
end
