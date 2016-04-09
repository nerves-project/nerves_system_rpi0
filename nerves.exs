use Mix.Config

config :nerves_system_rpi, :nerves_env,
  type: :system,
  bakeware: [target: "rpi", recipe: "nerves/rpi"],
  build_platform: Nerves.System.Platforms.BR,
  build_config: [
    defconfig: "nerves_defconfig"
  ]
