#!/bin/sh

set -e

# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

# Use files-to-cpio.sh from nerves_initramfs to prep config and revert.fw
$BINARIES_DIR/file-to-cpio.sh "$NERVES_DEFCONFIG_DIR/nerves_initramfs.conf" "$BINARIES_DIR/nerves_initramfs.conf.cpio"
$BINARIES_DIR/file-to-cpio.sh "$TARGET_DIR/usr/share/fwup/revert.fw" "$BINARIES_DIR/revert.fw.cpio"
