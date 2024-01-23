#
# Copyright (C) 2022 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common ArrowOS stuff.
$(call inherit-product, vendor/arrow/config/common.mk)

# Viper
$(call inherit-product, packages/apps/ViPER4AndroidFX/config.mk)

# Inherit from RMP6768 device
$(call inherit-product, device/realme/RMP6768/device.mk)

PRODUCT_DEVICE := RMP6768
PRODUCT_NAME := arrow_RMP6768
PRODUCT_BRAND := Realme
PRODUCT_MANUFACTURER := Realme
PRODUCT_MODEL := Realme Pad

# Flags
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_BOOT_ANIMATION_RES := 1080
DEVICE_MAINTAINER := Rohit-Tiwari
ARROW_GAPPS := true

# Build info
BUILD_FINGERPRINT := "realme/RMP2102/RE54C1L1:11/RP1A.200720.011/1677153829078:user/release-keys"
PRODUCT_BUILD_PROP_OVERRIDES := PRIVATE_BUILD_DESC="full_oppo8786-user 11 RP1A.200720.011 816 release-keys"
PRODUCT_GMS_CLIENTID_BASE := android-realme
