# Raspberry Pi Model Zero
[![CircleCI](https://circleci.com/gh/nerves-project/nerves_system_rpi0.svg?style=svg)](https://circleci.com/gh/nerves-project/nerves_system_rpi0)
[![Hex version](https://img.shields.io/hexpm/v/nerves_system_rpi0.svg "Hex version")](https://hex.pm/packages/nerves_system_rpi0)

This is the base Nerves System configuration for the Raspberry Pi Zero and
Raspberry Pi Zero W.

If you are *not* interested in [Gadget Mode](http://www.linux-usb.org/gadget/) it might be worth checking out [nerves_system_rpi](https://github.com/nerves-project/nerves_system_rpi).
That image configures the USB port in host mode by default and
is probably more appropriate for your setup.

![Fritzing Raspberry Pi Zero image](assets/images/raspberry-pi-model-zero.png)
<br><sup>[Image credit](#fritzing)</sup>

| Feature              | Description                     |
| -------------------- | ------------------------------- |
| CPU                  | 1 GHz ARM1176JZF-S              |
| Memory               | 512 MB                          |
| Storage              | MicroSD                         |
| Linux kernel         | 4.4 w/ Raspberry Pi patches     |
| IEx terminal         | OTG USB serial port (`ttyGS0`). Can be changed to HDMI or UART. |
| GPIO, I2C, SPI       | Yes - Elixir ALE                |
| ADC                  | No                              |
| PWM                  | Yes, but no Elixir support      |
| UART                 | 1 available - `ttyAMA0`         |
| Camera               | Yes - via rpi-userland          |
| Ethernet             | Yes - via OTG USB port          |
| WiFi                 | Supported on the Pi Zero W      |
| Bluetooth            | Not supported yet               |

## Console and kernel message configuration

The goal of this image is to use the OTG port for console access. If you're
debugging the boot process, you'll want to use the Raspberry Pi's UART pins on
the GPIO connector or the HDMI output. This is enabled by updating the
`cmdline.txt` file. This may be overrided with a custom `fwup.conf` file if
you don't want to rebuild this system. Add the following to your `cmdline.txt`:

```
console=ttyAMA0,115200 console=tty1 ...
```

If you'd like the IEx prompt to come out the UART pins (`ttyAMA0`) or HDMI
(`tty1`), then modify `rootfs_overlay/etc/erlinit.config` as well.

## Supported OTG USB modes

The base image activates the `dwc2` overlay, which allows the Pi Zero to appear as a
device (aka gadget mode). When plugged into a host computer via the OTG port, the Pi
Zero will appear as a composite Ethernet and serial device. The virtual serial
port provides access to the IEx prompt and the Ethernet device can be used for
firmware updates, Erlang distribution, and anything else running over IP.

## Supported WiFi devices

The base image includes drivers for the onboard Raspberry Pi Zero W wifi module
(`brcmfmac` driver). Due to the USB port being placed in gadget mode, this
system does not support USB WiFi adapters.

## Linux kernel and RPi firmware/userland

There's a subtle coupling between the `nerves_system_br` version and the Linux
kernel version used here. `nerves_system_br` provides the versions of
`rpi-userland` and `rpi-firmware` that get installed. I prefer to match them to
the Linux kernel to avoid any issues. Unfortunately, none of these are tagged
by the Raspberry Pi Foundation so I either attempt to match what's in Raspbian
or take versions of the repositories that have similar commit times.

## Installation

If you're new to Nerves, check out the
[nerves_init_gadget](https://github.com/fhunleth/nerves_init_gadget) project for
creating a starter project for the Raspberry Pi Zero or Zero W. It will get you
started with the basics like bringing up the virtual Ethernet interface,
initializing the application partition, and enabling ssh-based firmware updates.

[Image credit](#fritzing): This image is from the [Fritzing](http://fritzing.org/home/) parts library.
