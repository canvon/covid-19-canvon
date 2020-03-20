TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update"

timestamp:
	@echo "$(TIMESTAMP)"

# (Always try to download again if requested.)
.PHONY: update full_data.csv

update: full_data.csv

full_data.csv:
	@rm -f "$@.prev.sha256.tmp"
	@if [ -e "$@" ]; then sha256sum "$@" >"$@.prev.sha256.tmp"; fi
	wget --timestamping --no-if-modified-since -i "$@.url.txt"
	@if ! [ -e "$@.prev.sha256.tmp" ] || ! sha256sum -c "$@.prev.sha256.tmp"; then \
	  mkdir -pv "archive/source_data" && \
	  cp -avi "$@" "archive/source_data/$(basename $@)-$(TIMESTAMP).$(suffix $@)"; fi
	@rm -f "$@.prev.sha256.tmp"
