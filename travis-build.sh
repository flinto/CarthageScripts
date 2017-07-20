#!/bin/sh
if [ -n "$TRAVIS_TAG" ]
then
  #tag is set. skip test
  echo "Skip test"
else
  sh travis-main-script.sh
fi
