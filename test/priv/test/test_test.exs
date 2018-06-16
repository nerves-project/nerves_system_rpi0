defmodule TestTest do
  use ExUnit.Case
  doctest Test

  test "the I2C interface exists" do
    assert File.exists?("/dev/i2c-1")
  end

  test "the SPI interface exists" do
    assert File.exists?("/dev/spidev0.0")
  end

  test "the virtual serial port ttyGS0 exists" do
    assert File.exists?("/dev/ttyGS0")
  end

  test "the main serial port ttyAMA0 exists" do
    assert File.exists?("/dev/ttyAMA0")
  end

  test "/boot is mounted" do
    assert File.exists?("/boot/config.txt")
  end
end
