defmodule NervesSystemRpi.Mixfile do
  use Mix.Project

  def project do
    [app: :nerves_system_rpi,
     version: "0.4.0-rc2",
     elixir: "~> 1.2",
     compilers: Mix.compilers ++ [:nerves_system],
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    [{:nerves_system, path: "../nerves_system"},
     {:nerves_system_br, path: "../nerves-system-br"},
     {:nerves_toolchain_arm_unknown_linux_gnueabihf, github: "nerves-project/nerves_toolchain_arm_unknown_linux_gnueabi"}]
  end

  defp description do
    """
    Nerves System - Raspberry Pi A+ / B+ / B / Zero
    """
  end

  defp package do
    [maintainers: ["Frank Hunleth", "Justin Schneck"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/nerves-project/nerves_system_rpi"}]
  end

end
