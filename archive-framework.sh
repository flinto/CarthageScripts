#!/bin/sh
sh ./CarthageScripts/bump-version.sh
carthage build --verbose --no-skip-current
xcrun strip -S -T Carthage/Build/Mac/ $FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
xcrun strip -S -T Carthage/Build/iOS/ $FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
carthage archive $FRAMEWORK_NAME
