
# Default username for docker registry
USERNAME ?= python

all:
	docker build -t $(USERNAME)/docker-bpo image
.PHONY: all
