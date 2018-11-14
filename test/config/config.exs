use Mix.Config

# Repository specific configuration

system = :nerves_system_rpi0
platform = "rpi0"
arch = "arm"

app_part_devparth = "/dev/mmcblk0p3"
network_interface = System.get_env("NERVES_NETWORK_INTERFACE") || "wlan0"

# Environment specific configuration
#  NervesHub keys

config :nerves_hub,
  public_keys: [System.get_env("NERVES_HUB_FW_PUBLIC_KEY")]

#  Nerves Project test farm configuration
#  NERVES_TEST_SERVER = nerves-test-server.herokuapp.com
#  WEBSOCKET_PROTOCOL = wss

test_server = System.get_env("NERVES_TEST_SERVER")
websocket_protocol = System.get_env("WEBSOCKET_PROTOCOL") || "ws"

# Common configuration

# Configure shoehorn boot order.
config :shoehorn,
  app: :nerves_system_test,
  init: [:nerves_runtime, :system_registry_term_storage, :nerves_network]

# Only trust signed firmware
config :nerves_system_test, :firmware, public_key: System.get_env("NERVES_FW_PUB_KEY")

# Configure system_registry term storage to store the wifi credentials on the
#  app data partition. If the device is using eth0 as the primary connection
#  mechanism the wlan0 settings do not need to be configured.
config :system_registry, SystemRegistry.TermStorage,
  path: "/root/system_registry",
  scopes: [
    [:config, :network_interface, "wlan0", :ssid],
    [:config, :network_interface, "wlan0", :psk]
  ]

# Configure the default interface settings.
# wlan0 | eth0 - Used to establish a connection to the test server.
# usb0 - configured with linklocal to be validated as part of the test results.
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

# Configure the url for the connection to the test server phoenix channel socket.
config :nerves_system_test, NervesTestServer.Socket,
  url: "#{websocket_protocol}://#{test_server}/socket/websocket"

# Configure the test suite. nerves_system_test needs to know information such as
#  system - the name of the system repo the tests are being executed on
#  network_interface - the interface that should be used for reporting the
#   results on
#  tests - the locations for the tests to run.
#    Currently, it is only supported that tests are included in the priv_dir
#    of the app and dependencies. The default layout runs tests that are common
#    across devices (:nerves_system_test) and those that are specific to the
#    device (this app)
config :nerves_system_test,
  system: system,
  network_interface: network_interface,
  tests: [
    {:test, :priv_dir, "test"},
    {:nerves_system_test, :priv_dir, "test"}
  ]

# The configuration stored here is duplicated from the project so it can be
#  validated by nerves_system_test because the source is unavailable at runtime.
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
