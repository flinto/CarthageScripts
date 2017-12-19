#!/bin/sh
sh ./CarthageScripts/bump-version.sh
carthage build --verbose --no-skip-current
carthage archive $FRAMEWORK_NAME
