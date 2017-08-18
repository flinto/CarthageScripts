#!/bin/sh
if [ -n "$TRAVIS_TAG" ]
then
  echo "skip testing"
else
  if [ -f "travis-main-script.sh" ]; then
    sh travis-main-script.sh
  else
    xcodebuild test -scheme "$BUILD_SCHEME"
  fi
fi
