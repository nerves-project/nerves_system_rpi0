if Mix.env() == :test do
  hash =
    :os.cmd('git rev-parse HEAD')
    |> to_string
    |> String.trim()

  System.put_env("NERVES_FW_VCS_IDENTIFIER", hash)
end

defmodule Test.MixProject do
  use Mix.Project

  def project do
    [
      app: :test,
      version: "0.1.0",
      elixir: "~> 1.4",
      archives: [nerves_bootstrap: "~> 1.0"],
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Type `mix help compile.app` to learn about applications.
  def application, do: []

  defp bootstrap(args) do
    System.put_env("MIX_TARGET", "rpi0_ble")
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_system_rpi0_ble, path: "../", runtime: false},
      {:nerves_system_test, github: "nerves-project/nerves_system_test", branch: "poison"}
    ]
  end
end
