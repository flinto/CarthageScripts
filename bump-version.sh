#!/bin/sh
if [ -n "$TRAVIS_TAG" ]; then
  agvtool new-marketing-version $TRAVIS_TAG
  agvtool new-version $TRAVIS_BUILD_NUMBER
fi

