#!/bin/sh

if [ -n "$TRAVIS" ]; then
  echo "Travis build: Skip checkout. Checkout is done by .travis.yml."
  exit
fi

check_symlink() {
  ls Carthage/Checkouts | while read line
  do
      read -a array <<< "$line"
      dependency=${array[0]}

      if [ -L "Carthage/Checkouts/$dependency" ]
      then
        echo "$dependency"
      fi
  done
}

if [ -d ./Carthage/Checkouts ]; then
  checkouts=`check_symlink`
fi

if [ ! -z "$checkouts" -a "$checkouts" != " " ]; then
  echo "Development sym link \"$checkouts\" found"
fi

frameworks=`ruby ./CarthageScripts/get_frameworks.rb $checkouts`

if [ "$?" == "1" ]; then
  exit
fi
if [ "$frameworks" == "" ]; then
  exit
fi
echo "download dependencies... $frameworks"

VERSION=`carthage version`
carthage build --use-binaries $frameworks
