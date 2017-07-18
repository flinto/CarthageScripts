#!/bin/sh -e

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

echo "LD = $PWD/CarthageScripts/ld.py" >> $xcconfig
echo "DEBUG_INFORMATION_FORMAT = dwarf" >> $xcconfig

export XCODE_XCCONFIG_FILE="$xcconfig"

carthage build "$@" --no-skip-current
