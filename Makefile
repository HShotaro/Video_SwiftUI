.PHONY: setup
setup:
	sudo gem install bundler
	bundle install
	pod install

.PHONY: carthage_bootstrap
carthage_bootstrap:
	carthage bootstrap --use-xcframeworks --no-use-binaries --platform ios

.PHONY: carthage_update
carthage_update:
	carthage update --use-xcframeworks --no-use-binaries --platform ios

.PHONY: rm_carthage_cache
rm_carthage_cache:
	rm -rf ~/Library/Caches/org.carthage.CarthageKit
	rm -rf ~/Library/Caches/carthage

.PHONY: rm_derived_data
rm_derived_data:
	rm -rf ~/Library/Developer/Xcode/DerivedData/

.PHONY: open_xcode
open_xcode:
	open Video_SwiftUI.xcworkspace