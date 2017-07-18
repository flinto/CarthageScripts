#!/bin/sh

build_dir="$SRCROOT/Carthage/Build"

if [ $PLATFORM_NAME == 'macosx' ]; then
  TARGET="Mac"
else
  TARGET="iOS"
fi

echo $TARGET

# Only copy when the Carthage/Build directory is a symlink
if ! [ -L "$build_dir" ]; then exit 0; fi

echo "Copying framework into main repos"

rsync --delete -av "$BUILT_PRODUCTS_DIR/$PRODUCT_NAME"* "$build_dir/Mac"