TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update"

timestamp:
	@echo "$(TIMESTAMP)"

# (Always try to download again if requested.)
.PHONY: update full_data.csv

update: full_data.csv

full_data.csv:
	@rm -f "$@.prev.stamp"
	@[ -e "$@" ] && touch --reference="$@" "$@.prev.stamp"
	wget --timestamping --no-if-modified-since -i "$@.url.txt"
	@if [ -e "$@.prev.stamp" ] && [ "$@" -nt "$@.prev.stamp" ]; then \
	  mkdir -pv "archive/source_data" && \
	  cp -avi "$@" "archive/source_data/$(basename $@)-$(TIMESTAMP).$(suffix $@)"; fi
