use Mix.Config

system = :nerves_system_rpi0
platform = "rpi0"
arch = "arm"

test_server = System.get_env("NERVES_TEST_SERVER")
network_interface = System.get_env("NERVES_NETWORK_INTERFACE") || "usb0"
websocket_protocol = System.get_env("WEBSOCKET_PROTOCOL") || "ws"

config :bootloader,
  app: :nerves_system_test,
  init: [:nerves_runtime, :nerves_network]

config :nerves_system_test, :firmware,
  public_key: System.get_env("NERVES_FW_PUB_KEY")

config :system_registry, SystemRegistry.TermStorage,
  path: "/root/system_registry",
  scopes: [
    [:config, :network_interface, "wlan0", :ssid],
    [:config, :network_interface, "wlan0", :psk]
  ]

config :nerves_network, :default,
  eth0: [
    ipv4_address_method: :dhcp
  ],
  wlan0: [
    ipv4_address_method: :dhcp
  ],
  usb0: [
    ipv4_address_method: :linklocal
  ]

config :nerves_system_test, NervesTestServer.Socket,
  url: "#{websocket_protocol}://#{test_server}/socket/websocket"

config :nerves_system_test,
  system: system,
  network_interface: network_interface,
  tests: [
    {:test, :priv_dir, "test"},
    {:nerves_system_test, :priv_dir, "test"}
  ]

config :nerves_runtime, :kv,
  nerves_fw_application_part0_devpath: "/dev/mmcblk0p3",
  nerves_fw_application_part0_fstype: "ext4",
  nerves_fw_application_part0_target: "/root",
  nerves_fw_architecture: arch,
  nerves_fw_author: "The Nerves Team",
  nerves_fw_description: Mix.Project.config[:description],
  nerves_fw_platform: platform,
  nerves_fw_product: Mix.Project.config[:app],
  nerves_fw_vcs_identifier: System.get_env("NERVES_FW_VCS_IDENTIFIER"),
  nerves_fw_version: Mix.Project.config[:version]
