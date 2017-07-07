defmodule TestTest do
  use ExUnit.Case
  doctest Test

  test "execute tests on hardware" do
    assert 1 + 1 == 2
  end
end
