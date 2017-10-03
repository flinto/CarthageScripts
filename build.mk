build-static-framework:
	./CarthageScripts/build-static-framework.sh
	mkdir -p ../Nucleator/Carthage/Build/Mac
	rsync --delete -av Carthage/Build/Mac/* ../Nucleator/Carthage/Build/Mac
	mkdir -p ../Nucleator/Carthage/Build/iOS
	rsync --delete -av Carthage/Build/iOS/* ../Nucleator/Carthage/Build/iOS

#
# Localize
#
LANG=en.lproj ja.lproj zh-Hans.lproj zh-Hant.lproj de.lproj es.lproj ko.lproj ru.lproj fr.lproj

remove_placeholder:
	for xliff in xliff/*; do \
		echo "Processing $$xliff..."; \
		ruby etc/remove_placeholder.rb $$xliff > processed.xliff; \
		mv processed.xliff $$xliff; \
	done


update_xliff:
	for xliff in xliff/*; do \
		echo "Processing $$xliff..."; \
		ruby ./CarthageScripts/update_xliff.rb $$xliff > processed.xliff; \
		mv processed.xliff $$xliff; \
	done

localize:
	for base in $(BASE_DIR); do \
		find "$$base" -name "*.swift" ! -name "Localize.swift" | xargs genstrings -q -u -s $(ROUTINE); \
		iconv -f UTF-16LE -t utf8 Localizable.strings > Localizable-utf8.strings; \
		for lang in $(LANG); do \
			./CarthageScripts/genstringmerge.rb "$$base"/"Resources/$$lang"/Localizable.strings Localizable-utf8.strings; \
		done ; \
		rm Localizable.strings Localizable-utf8.strings; \
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

