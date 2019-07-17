defmodule NervesRuntime.Test do
  use ExUnit.Case

  describe "application data partition" do
    test "can be written to" do
      file = "/root/tmp"
      content = "hello"
      assert :ok == File.write(file, content)
      assert {:ok, content} == File.read(file)
    end
  end

  describe "key value store" do
    test "can be read from" do
      tests = Application.get_env(:nerves_runtime, :kv)

      assert Enum.all?(tests, fn {k, v} ->
               v =
                 to_string(v)
                 |> String.trim()

               kv =
                 to_string(k)
                 |> Nerves.Runtime.KV.get_active()
                 |> String.trim()

               v == kv
             end)
    end
  end

  test "hostname has the form nerves-id" do
    {:ok, hostname} = :inet.gethostname()
    hostname = to_string(hostname)
    assert String.match?(hostname, ~r/nerves-[0-9]+/)
  end
end
