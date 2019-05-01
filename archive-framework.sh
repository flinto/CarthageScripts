#!/bin/sh
sh ./CarthageScripts/bump-version.sh
carthage build --verbose --no-skip-current --cache-builds --platform macOS,iOS
carthage archive $FRAMEWORK_NAME
