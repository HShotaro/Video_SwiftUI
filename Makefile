.PHONY: carthage_bootstrap
carthage_bootstrap:
	carthage bootstrap --no-use-binaries --use-ssh --platform ios

.PHONY: carthage_update
carthage_update:
	carthage update --no-use-binaries --use-ssh --platform ios