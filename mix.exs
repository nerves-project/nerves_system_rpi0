defmodule NervesSystemRpi0.Mixfile do
  use Mix.Project

  @app :nerves_system_rpi0
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.4",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [
        "deps.loadpaths": ["nerves.env", "deps.loadpaths"],
        "deps.get": ["deps.get", "nerves.deps.get"],
        docs: ["docs", &copy_images/1]
      ],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  def nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "nerves-project/#{@app}"}
      ],
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 0.9", runtime: false },
      {:nerves_system_br, "0.17.0", runtime: false},
      {:nerves_toolchain_armv6_rpi_linux_gnueabi, "~> 0.13.0", runtime: false},
      {:nerves_system_linter, "~> 0.2.2", runtime: false},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  defp description do
    """
    Nerves System - Raspberry Pi Zero and Zero W
    """
  end

  defp package do
    [
      maintainers: ["Timothy Mecklem", "Frank Hunleth"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/nerves-project/#{@app}"}
    ]
  end

  defp package_files do
    [
      "LICENSE",
      "mix.exs",
      "nerves_defconfig",
      "README.md",
      "VERSION",
      "rootfs_overlay",
      "fwup.conf",
      "fwup-revert.conf",
      "post-createfs.sh",
      "post-build.sh",
      "cmdline.txt",
      "linux-4.4.defconfig",
      "config.txt"
    ]
  end

  # Copy the images referenced by docs, since ex_doc doesn't do this.
  defp copy_images(_) do
    File.cp_r("assets", "doc/assets")
  end
end
