TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update"

timestamp:
	@echo "$(TIMESTAMP)"

# (Always try to download again if requested.)
.PHONY: update full_data.csv

update: full_data.csv

full_data.csv:
	@rm -f "$@.new.sha256.tmp"
	@if [ -e "$@" ]; then sha256sum "$@" | sed -e 's#$$#.new.tmp#' >"$@.new.sha256.tmp"; fi
	wget -O "$@.new.tmp" -i "$@.url.txt"
	@if ! [ -e "$@.new.sha256.tmp" ] || ! sha256sum -c "$@.new.sha256.tmp"; then \
	  touch -c "$@.new.tmp" && \
	  mkdir -pv "archive/source_data" && \
	  cp -avi "$@.new.tmp" "archive/source_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)" && \
	  mv -v "$@.new.tmp" "$@"; \
	else rm -fv "$@.new.tmp"; fi
	@rm -f "$@.new.sha256.tmp"
