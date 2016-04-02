use Mix.Config

config :nerves_system_rpi, :nerves_env,
  type:  :system,
  build_platform: :nerves_system_br,
  bakeware: [target: "rpi", recipe: "nerves/rpi"],
  ext: [
    defconfig: "nerves_defconfig"
  ]
