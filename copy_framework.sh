#!/bin/sh

build_dir="$SRCROOT/Carthage/Build"

if [ $PLATFORM_NAME == 'macosx' ]; then
  TARGET="Mac"
else
  TARGET="iOS"
fi

# Only copy when the Carthage/Build directory is a symlink
if ! [ -L "$build_dir" ]; then exit 0; fi

echo "Copying $TARGET framework into main repos"

rsync --delete -av "$BUILT_PRODUCTS_DIR/$PRODUCT_NAME".framework "$build_dir/$TARGET"