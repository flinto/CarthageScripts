#!/bin/sh
sh ./CarthageScripts/bump-version.sh
carthage build --verbose --no-skip-current
if [ -f Carthage/Build/Mac/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME ]; then
  xcrun strip -S -T Carthage/Build/Mac/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
fi
if [ -f Carthage/Build/iOS/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME ]; then
  xcrun strip -S -T Carthage/Build/iOS/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
fi
carthage archive $FRAMEWORK_NAME
