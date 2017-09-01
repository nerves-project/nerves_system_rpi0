mount -t configfs none /sys/kernel/config
GADGET=/sys/kernel/config/usb_gadget/g1
mkdir $GADGET
mkdir -p $GADGET/strings/0x409
SN=$(boardid)
echo $SN > $GADGET/strings/0x409/serialnumber
echo "Nerves Project" > $GADGET/strings/0x409/manufacturer
echo "Nerves Gadget" > $GADGET/strings/0x409/product
mkdir -p $GADGET/functions/acm.GS0
mkdir -p $GADGET/functions/ecm.USB0
mkdir -p $GADGET/configs/c.1
mkdir -p $GADGET/configs/c.1/strings/0x409
echo "CDC 1xACM+ECM" > $GADGET/configs/c.1/strings/0x409/configuration
ln -s $GADGET/functions/acm.GS0 $GADGET/configs/c.1
ln -s $GADGET/functions/ecm.USB0 $GADGET/configs/c.1
UDC=$(ls /sys/class/udc/*.usb)
echo 20980000.usb > $GADGET/UDC
