# Raspberry Pi Zero Test Suite

Executes ExUnit tests on target hardware and reports results to the
[Nerves test server](https://nerves-test-server.herokuapp.com/nerves-project/nerves_system_rpi0)

For more information on how to configure your own test farm please refer to the
[Nerves test server source](https://github.com/mobileoverlord/nerves_test_server)

## Setup

### Signing firmware

Firmware for the test farm is signed so it can be validated before being applied
to the device. In order to sign trusted firmware, you will require the env variable
`NERVES_FW_PRIV_KEY` and `NERVES_FW_PUB_KEY` to be set. Use `fwup` to configure
your own test server keys

```
$ fwup -g
```

The get the base64 values and export the variables
```
$ export NERVES_FW_PRIV_KEY=$(cat fwup-key.priv | base64)
$ export NERVES_FW_PUB_KEY=$(cat fwup-key.pub | base64)
```

### Configure the environment

```
$ export MIX_ENV=test
$ export NERVES_TEST_SERVER=nerves-test-server.herokuapp.com
$ export WEBSOCKET_PROTOCOL=wss
```

### Building

Fetch the dependencies

```
$ mix deps.get
```

Create the firmware

```
$ mix firmware
```

Sign the firmware

```
$ fwup --sign --private-key $NERVES_FW_PRIV_KEY -i _build/test/nerves/images/test.fw -o _build/test/nerves/images/test.fw
```

Burn it to an SD card

```
$ mix firmware.burn
```

## Provisioning

The Raspberry Pi Zero W uses `wlan0` to connect to the report server. On first
boot, the interface ssid and password will need to be configured.

```
iex> Nerves.Network.setup("wlan0", [ssid: "my wifi name", psk: "12345", key_mgmt: :"WPA-PSK"])
```

The device should establish a connection to the network and join the test farm.
Provisioning the device is only required after applying the `fwup` complete task.
This is because the values are persisted on the application data partition
between reboots and applying new firmware using the `fwup` update task.
