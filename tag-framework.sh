#!/bin/sh

git pull --tags

LATEST_VERSION=`git tag -l --sort=-version:refname`
NEXT_VERSION=`ruby ./CarthageScripts/get_semantic_ver.rb $LATEST_VERSION`

git tag $NEXT_VERSION
git push --tags

CURRENT_REPO=`basename $PWD`

perl -pi -e "s/(github \"flinto\/$CURRENT_REPO\")\s+\"[\d\.]+\"/\1 \"$NEXT_VERSION\"/" ../Nucleator/Cartfile.resolved
(cd ../Nucleator; git commit Cartfile.resolved -m "Update $CURRENT_REPO to $NEXT_VERSION")


