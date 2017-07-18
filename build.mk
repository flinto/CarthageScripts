build-static-framework:
	./CarthageScripts/build-static-framework.sh
	mkdir -p ../Nucleator/Carthage/Build/Mac
	rsync --delete -av Carthage/Build/Mac/* ../Nucleator/Carthage/Build/Mac
	mkdir -p ../Nucleator/Carthage/Build/iOS
	rsync --delete -av Carthage/Build/iOS/* ../Nucleator/Carthage/Build/iOS
