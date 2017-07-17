# Changelog

## v0.16.0

  * nerves_system_br v0.13.2
    * OTP 20
    * erlinit 1.1.3
    * fwup 0.15.3

  * New features
    * Firmware updates verify that they're updating the right target. If the target
      doesn't say that it's an `rpi0` through the firmware metadata, the update
      will fail.
    * Added meta-misc and meta-vcs-identifier to the `fwup.conf` metadata for use
      by users and for the regression test framework

  * Bug fixes
    * The `erlinit` update fixes a hang issue that occurs on reboots if nothing
      is connected to the USB virtual serial console.

## v0.15.0

  * nerves_system_br v0.12.1
    * erlinit 1.1.1
    * fwup 0.15.0

  * New features
    * The application data partition is now `ext4`. This greatly improves its
      robustness to corruption. Nerves.Runtime contains code to initialize it on
      first boot.
    * Firmware images now contain metadata that can be queried at runtime (see
      Nerves.Runtime.KV
    * Increased GPU memory to support Pi Camera V2

## v0.14.0

  * nerves_system_br v0.12.0
    * Buildroot 2017.05
    * erlinit 1.1.0

  * New features
    * pigpio is now available by default (enables near real-time use of gpios)

  * Bug fixes
    * USB host/gadget mode selection doesn't seem to work on some non-Apple
      hardware. Host support has been disabled as a workaround. See
      https://github.com/nerves-project/nerves_system_rpi0/issues/10 for details.

  * Other changes
    * pi3-miniuart-bt overlay is enabled by default to give full speed UART access on GPIO pins

## v0.13.1

  * nerves_system_br v0.11.1
    * erlinit 1.0.1 - contains fix for Erlang VM exit detection issue

## v0.13.0

The brcmfmac wireless driver is now built as a module, so you will need to load it. See https://github.com/nerves-project/nerves-examples/tree/master/hello_wifi for an example of WiFi module loading on application startup.

  * nerves_system_br v0.11.0
    * erlinit 1.0
    * fwup 0.14.2
    * rpi-userland and rpi-firmware version bumps to correspond with Raspbian
Linux 4.4 updates

## v0.12.0

This is the first official Raspberry Pi Zero system release. It was forked
off `nerves_system_rpi` so previous versions are from that project. Those
also work on the Zero, but without USB gadget mode or RPi Zero W WiFi
support.

  * nerves_system_br v0.10.0
    * Buildroot 2017.02
    * Erlang/OTP 19.3

  * New features
    * Upgraded the Linux kernel from 4.4.43 -> 4.4.50. Due to the coupling
      between the Linux kernel and rpi-firmware and possibly rpi-userland, if
      you have a custom system based off this, you should update your Linux
      kernel as well. (see `nerves_defconfig` changes)

## v0.11.0

  * New features
    * Enabled USB_SERIAL and FTDI_SIO support. Needed for connecting with Arduino to the USB ports
    * Support for Nerves 0.5.0

## v0.10.0

  * New features
    * Upgraded the Linux kernel to 4.4.43. This also removes the
      call to mkknlimg which is no longer needed.
    * Bump toolchain to use gcc 5.3 (previously using gcc 4.9.3)

## v0.9.1

* Bug Fixes
  * Loosen mistaken nerves dep on `0.4.0` to `~> 0.4.0`

## v0.9.0

This version switches to using the `nerves_package` compiler. This will
consolidate overall deps and compilers.

  * Nerves.System.BR v0.8.1
    * Support for distillery
    * Support for nerves_package compiler

## v0.7.0

When upgrading to this version, be sure to review the updates to
nerves_defconfig if you have customized this system.

  * nerves_system_br v0.7.0
    * Package updates
      * Buildroot 2016.08
      * Linux 4.4

## v0.6.1

  * Package versions
    * Nerves.System.BR v0.6.1

  * New features
    * All Raspberry Pi-specific configuration is now in this repository
    * Enabled SMP Erlang - even though the RPi Zero and Model B+ are
      single core systems, some NIFs require SMP Erlang.

## v0.6.0
  * Nerves.System.BR v0.6.0
    * Package updates
      * Erlang OTP 19
      * Elixir 1.3.1
      * fwup 0.8.0
      * erlinit 0.7.3
      * bborg-overlays (pull in I2C typo fix from upstream)
    * Bug fixes
      * Synchronize file system kernel configs across all platforms

## v0.5.2
  * Enhancements
    * Enabled USB Printer kernel mod. Needs to be loaded with `modprobe` to use
  * Bug Fixes(raspberry pi)
    * Enabled multicast in linux config for rpi/rpi2/rpi3/ev3

## v0.5.1
  * Nerves.System.BR v0.5.1
    * Bug Fixes(nerves-env)
      * Added include paths to CFLAGS and CXXFLAGS
      * Pass sysroot to LDFLAGS

## v0.5.0
  * Nerves.System.BR v0.5.0
    * New features
      * WiFi drivers enabled by default on RPi2 and RPi3
      * Include wireless regulatory database in Linux kernel by default
        on WiFi-enabled platforms. Since kernel/rootfs are read-only and
        coupled together for firmware updates, the normal CRDA/udev approach
        isn't necessary.
      * Upgraded the default BeagleBone Black kernel from 3.8 to 4.4.9. The
        standard BBB device tree overlays are included by default even though the
        upstream kernel patches no longer include them.
      * Change all fwup configurations from two step upgrades to one step
        upgrades. If you used the base fwup.conf files to upgrade, you no
        longer need to finalize the upgrade. If not, there's no change.
