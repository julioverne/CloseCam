include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CloseCam

CloseCam_FILES = /mnt/d/codes/closecam/Tweak.xm
CloseCam_FRAMEWORKS = CydiaSubstrate UIKit MobileCoreServices CoreGraphics CoreFoundation Foundation
CloseCam_PRIVATE_FRAMEWORKS = SpringBoardServices
CloseCam_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 arm64
CloseCam_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
	
all::
