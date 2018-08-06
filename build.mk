build-static-framework:
	./CarthageScripts/build-static-framework.sh
	mkdir -p ../Nucleator/Carthage/Build/Mac
	mkdir -p ../Nucleator/Carthage/Build/iOS

FRAMEWORK=`basename "$(GITREPO)"`

build-framework:
	# bump up version number
	agvtool new-marketing-version `git describe --tags`
	agvtool new-version `date "+%H%M%S"`
	# build
	carthage build --no-skip-current
	GITREPO=`git rev-parse --show-toplevel`; carthage archive `basename $$GITREPO`

build-static-framework-locally:
	# bump up version number
	agvtool new-marketing-version `git describe --tags`
	agvtool new-version `date "+%H%M%S"`
	# build
	make build-static-framework
	GITREPO=`git rev-parse --show-toplevel`; carthage archive `basename $$GITREPO`


#
# Localize
#
xliff: generate_xliff update_xliff

import_xliff:
	for xliff in xliff/*; do \
		if [ $$xliff != 'xliff/en.xliff' ]; then \
			xcodebuild -importLocalizations -localizationPath $$xliff -project $(BASE_DIR).xcodeproj ;\
		fi; \
	done

generate_xliff:
	mkdir -p xliff_new
	xcodebuild -exportLocalizations -localizationPath xliff_new -project $(BASE_DIR).xcodeproj -exportLanguage en
	ruby ./CarthageScripts/update_xliff.rb xliff_new/en.xliff > processed.xliff
	mv processed.xliff xliff_new/en.xliff
	ruby ./CarthageScripts/xliff_diff.rb xliff/en.xliff xliff_new/en.xliff
	mv xliff_new/en.xliff xliff/en.xliff
	rmdir xliff_new


