##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
AESD_ASSIGNMENTS_VERSION = f7f9ce80492ebe06d4d2c7c564f9e4d5606bfc19
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-vinod1257.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES
AESD_ASSIGNMENTS_DEPENDENCIES = linux

# Path to aesdchar driver source inside the assignments repo
AESDCHAR_DIR = $(@D)/aesd-char-driver

# Detect kernel build directory automatically (version-agnostic)
LINUX_SRC_DIR = $(LINUX_DIR)

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/finder-app all
	$(MAKE) -C $(LINUX_SRC_DIR) \
		M=$(AESDCHAR_DIR) ARCH=$(BR2_NORMALIZED_ARCH) \
		CROSS_COMPILE="$(TARGET_CROSS)" modules
endef

KERNEL_RELEASE = $(shell \
    $(MAKE) --no-print-directory -C $(LINUX_SRC_DIR) \
        ARCH=$(BR2_NORMALIZED_ARCH) CROSS_COMPILE="$(TARGET_CROSS)" \
        kernelrelease)

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(@D)/conf/ $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/assignment-autotest/test/assignment4/* $(TARGET_DIR)/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/writer $(TARGET_DIR)/bin
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop.sh $(TARGET_DIR)/etc/init.d/S99aesdsocket
	$(INSTALL) -d $(TARGET_DIR)/lib/modules/$(KERNEL_RELEASE)/extra
	$(INSTALL) -m 0644 $(AESDCHAR_DIR)/aesdchar.ko \
		$(TARGET_DIR)/lib/modules/$(KERNEL_RELEASE)/extra/aesdchar.ko
	$(INSTALL) -m 0755 $(AESDCHAR_DIR)/aesdchar-load.sh \
		$(TARGET_DIR)/etc/init.d/S99aesdchar
endef

$(eval $(generic-package))
