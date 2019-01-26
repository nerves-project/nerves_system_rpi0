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
      elixir: "~> 1.6",
      archives: [nerves_bootstrap: "~> 1.0"],
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Type `mix help compile.app` to learn about applications.
  def application, do: []

  defp bootstrap(args) do
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_system_rpi0, path: "../", runtime: false},
      {:nerves_system_test, github: "nerves-project/nerves_system_test"}
    ]
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "target")
    end
  end
end
