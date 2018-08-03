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
LANG=en ja zh-Hans zh-Hant de es ko ru fr

remove_placeholder:
	for xliff in xliff/*; do \
		echo "Processing $$xliff..."; \
		ruby etc/remove_placeholder.rb $$xliff > processed.xliff; \
		mv processed.xliff $$xliff; \
	done

xliff: generate_xliff update_xliff

import_xliff:
	for xliff in xliff/*; do \
		if [ $$xliff != 'xliff/en.xliff' ]; then \
			xcodebuild -importLocalizations -localizationPath $$xliff -project $(BASE_DIR).xcodeproj ;\
		fi; \
	done

generate_xliff:
	mkdir -p xliff_new
	for lang in $(LANG); do \
		xcodebuild -exportLocalizations -localizationPath xliff_new -project $(BASE_DIR).xcodeproj -exportLanguage $$lang; \
	done

update_xliff:
	for xliff in xliff_new/*; do \
		echo "Processing $$xliff..."; \
		ruby ./CarthageScripts/update_xliff.rb $$xliff > processed.xliff; \
		mv processed.xliff $$xliff; \
	done
	ruby ./CarthageScripts/xliff_diff.rb xliff/en.xliff xliff_new/en.xliff; \

move_xliff:
	for xliff in xliff_new/*; do \
		mv $$xliff xliff/`(basename $$xliff)`; \
	done

genstring:
	for base in $(BASE_DIR); do \
		find "$$base" -name "*.swift" ! -name "Localize.swift" | xargs genstrings -q -u; \
		iconv -f UTF-16LE -t utf8 Localizable.strings > Localizable-utf8.strings; \
		for lang in Base.lproj $(LANG); do \
			./CarthageScripts/genstringmerge.rb "$$base"/"$(RESOURCE_DIR)""$$lang"/Localizable.strings Localizable-utf8.strings; \
		done ; \
		rm Localizable.strings Localizable-utf8.strings; \
	done

update_xib:
	for file in "$(BASE_DIR)"/Base.lproj/*.xib "$(BASE_DIR)"/Base.lproj/*.storyboard; do \
		echo "file $$file"; \
		STRINGFILE=`basename "$$file" | sed  -E 's/\.(xib|storyboard)/.strings/'`; \
		echo "string file $$STRINGFILE"; \
		if [ -f "$(BASE_DIR)/ja.lproj/$$STRINGFILE" ]; then \
			echo "Processing $$file"; \
			ibtool --export-strings-file "$$file.strings" "$$file"; \
			for lang in $(LANG); do \
				./CarthageScripts/stringmerge.rb $$lang "$(BASE_DIR)/$$lang/$$STRINGFILE" "$$file.strings"; \
			done ; \
			rm "$$file.strings"; \
		fi \
	done

localize_xib:
	for base in $(BASE_DIR); do \
		for file in "$$base"/Base.lproj/*.xib "$$base"/Base.lproj/*.storyboard; do \
			STRINGFILE=`basename "$$file" | sed  -E 's/\.(xib|storyboard)/.strings/'`; \
			if [ -f "$$base/ja.lproj/$$STRINGFILE" ]; then \
				echo "Processing $$file"; \
				ibtool --export-strings-file "$$file.strings" "$$file"; \
				for lang in $(LANG); do \
					./CarthageScripts/stringmerge.rb $$lang "$$base/$$lang/$$STRINGFILE" "$$file.strings"; \
				done ; \
				rm "$$file.strings"; \
			fi \
		done; \
  done

