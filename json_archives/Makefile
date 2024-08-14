# Makefile to format JSON files
# Set 'format' as the default target

.PHONY: format

format:
	jq '.' state.json > state_formatted.json

default: format