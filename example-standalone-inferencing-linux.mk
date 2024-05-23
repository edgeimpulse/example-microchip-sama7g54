# SPDX-License-Identifier: GPL-2.0-or-later

EXAMPLE_STANDALONE_INFERENCING_LINUX_VERSION = 1.0.0
EXAMPLE_STANDALONE_INFERENCING_LINUX_SITE = ./package/example-standalone-inferencing-linux
EXAMPLE_STANDALONE_INFERENCING_LINUX_SITE_METHOD = local
EXAMPLE_STANDALONE_INFERENCING_LINUX_LICENSE = Apache-2.0
EXAMPLE_STANDALONE_INFERENCING_LINUX_LICENSE_FILES = LICENSE
#EXAMPLE_STANDALONE_INFERENCING_LINUX_INSTALL_STAGING = YES

define EXAMPLE_STANDALONE_INFERENCING_LINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) APP_PROFILING=1 TARGET_LINUX_ARMV7=1 USE_FULL_TFLITE=1 $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define EXAMPLE_STANDALONE_INFERENCING_LINUX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home
	cp $(@D)/build/* $(TARGET_DIR)/home
endef

# Build rule
$(eval $(generic-package))