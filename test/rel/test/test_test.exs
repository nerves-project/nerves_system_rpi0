defmodule TestTest do
  use ExUnit.Case

  test "i2c-1 interface exists" do
    assert File.exists?("/dev/i2c-1")
  end
end
