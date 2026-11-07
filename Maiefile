ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = CounterFlame

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CFMenu
CFMenu_FILES = Tweak.xm
CFMenu_CFLAGS = -fobjc-arc
CFMenu_FRAMEWORKS = UIKit Foundation
CFMenu_PRIVATE_FRAMEWORKS = 

include $(THEOS)/makefiles/tweak.mk
