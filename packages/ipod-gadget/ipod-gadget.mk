# Author: Jean Parpaillon
IPOD_GADGET_MODULE_VERSION = 1.0
IPOD_GADGET_SITE = /home/jean/BA_Projets/mercedes/ipod_gadget_rpi0/3rd_party/ipod-gadget/gadget
IPOD_GADGET_SITE_METHOD = local
IPOD_GADGET_LICENSE = MIT
IPOD_GADGET_LICENSE_FILES = LICENSE
IPOD_GADGET_MODULE_MAKE_OPTS = 
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' KERNEL_PATH='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' all
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))