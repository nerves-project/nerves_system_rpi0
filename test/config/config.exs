use Mix.Config

# Repository specific configuration

platform = "rpi0"
arch = "arm"

app_part_devparth = "/dev/mmcblk0p3"

# Environment specific configuration
#  Nerves Project test farm configuration
#  NERVES_TEST_SERVER = nerves-test-server.herokuapp.com
#  WEBSOCKET_PROTOCOL = wss

test_server = System.get_env("NERVES_TEST_SERVER")
websocket_protocol = System.get_env("WEBSOCKET_PROTOCOL") || "ws"

# Common configuration

# Configure shoehorn boot order.
config :shoehorn,
  app: :nerves_system_test,
  init: [:nerves_runtime, :vintage_net]

config :nerves_hub,
  public_keys: [
    System.get_env("NERVES_HUB_FW_PUBLIC_KEY")
  ]

config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"eth0", %{type: VintageNet.Technology.Ethernet, ipv4: %{method: :dhcp}}},
    {"wlan0", %{type: VintageNet.Technology.WiFi}}
  ]

# Configure the url for the connection to the test server phoenix channel socket.
config :nerves_test_client, :socket,
  url: "#{websocket_protocol}://#{test_server}/socket/websocket"

# The configuration stored here is duplicated from the project so it can be
#  validated by nerves_test_client because the source is unavailable at runtime.
config :nerves_runtime, :kv,
  nerves_fw_application_part0_devpath: app_part_devparth,
  nerves_fw_application_part0_fstype: "ext4",
  nerves_fw_application_part0_target: "/root",
  nerves_fw_architecture: arch,
  nerves_fw_author: "The Nerves Team",
  nerves_fw_description: Mix.Project.config()[:description],
  nerves_fw_platform: platform,
  nerves_fw_product: Mix.Project.config()[:app],
  nerves_fw_vcs_identifier: System.get_env("NERVES_FW_VCS_IDENTIFIER"),
  nerves_fw_version: Mix.Project.config()[:version]
