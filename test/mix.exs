if Mix.env() == :test do
  hash =
    :os.cmd('git rev-parse HEAD')
    |> to_string
    |> String.trim()

  System.put_env("NERVES_FW_VCS_IDENTIFIER", hash)
end

defmodule Test.MixProject do
  use Mix.Project

  @app :test

  def project do
    [
      app: @app,
      name: "system-test",
      version: "0.1.0",
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}]
    ]
  end

  # Type `mix help compile.app` to learn about applications.
  def application, do: []

  defp bootstrap(args) do
    Mix.target(:target)
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_system_rpi0, path: "../", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:nerves_test_client, github: "mobileoverlord/nerves_test_client"}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble, &ExUnitRelease.include/1]
    ]
  end
end
