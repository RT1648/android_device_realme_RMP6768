#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

export DEVICE=RMP6768
export VENDOR=realme

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}"/../../..

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup {
    case "$1" in
        system/lib/libsink.so)
            "$PATCHELF" --add-needed "libshim_vtservice.so" "$2"
            ;;
        system/lib/libshowlogo.so)
            "${PATCHELF}" --add-needed "libshim_showlogo.so" "${2}"
            ;;
        vendor/lib/libMtkOmxVdecEx.so)
            "$PATCHELF" --replace-needed "libui.so" "libui-v32.so" "$2"
            ;;
        vendor/lib64/libwifi-hal-mtk.so)
            "$PATCHELF" --set-soname libwifi-hal-mtk.so "$2"
            ;;
        vendor/lib*/libmtkcam_stdutils.so)
            "$PATCHELF" --replace-needed "libutils.so" "libutils-v30.so" "$2"
            ;;
        vendor/lib*/hw/audio.primary.mt6768.so)
            "$PATCHELF" --add-needed "libshim_audio.so" "$2"
            "$PATCHELF" --replace-needed "libalsautils.so" "libalsautils_legacy.so" "$2"
            ;;
        vendor/lib*/hw/audio.usb.mt6768.so)
            "$PATCHELF" --replace-needed "libalsautils.so" "libalsautils_legacy.so" "$2"
            ;;
        vendor/lib*/hw/dfps.mt6768.so|\
        vendor/lib*/hw/android.hardware.thermal@2.0-impl.so|\
        vendor/lib*/hw/vendor.mediatek.hardware.pq@2.6-impl.so)
            "$PATCHELF" --replace-needed "libutils.so" "libutils-v32.so" "$2"
            ;;
        vendor/etc/init/android.hardware.bluetooth@1.0-service-mediatek.rc)
            sed -i '/vts/Q' "$2"
            ;;
    esac
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

SECTION=
KANG=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"