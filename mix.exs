defmodule NervesSystemRpi0.Mixfile do
  use Mix.Project

  @version Path.join(__DIR__, "VERSION")
    |> File.read!
    |> String.strip

  def project do
    [app: :nerves_system_rpi0,
     version: @version,
     elixir: "~> 1.3",
     compilers: Mix.compilers ++ [:nerves_package],
     description: description(),
     package: package(),
     deps: deps(),
     aliases: ["deps.precompile": ["nerves.env", "deps.precompile"]]]
  end

  def application do
    []
  end

  defp deps do
    [{:nerves, "~> 0.5", runtime: false },
     {:nerves_system_br, "~> 0.12.0", runtime: false },
     {:nerves_toolchain_armv6_rpi_linux_gnueabi, "~> 0.10.0", runtime: false}]
  end

  defp description do
    """
    Nerves System - Raspberry Pi Zero and Zero W
    """
  end

  defp package do
    [maintainers: ["Timothy Mecklem", "Frank Hunleth"],
    files: ["LICENSE", "mix.exs", "nerves_defconfig", "nerves.exs", "README.md", "VERSION", "rootfs-additions", "fwup.conf", "cmdline.txt", "linux-4.4.defconfig", "config.txt", "post-createfs.sh"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/nerves-project/nerves_system_rpi0"}]
  end
end
