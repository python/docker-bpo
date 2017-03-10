
# Default username for docker registry
USERNAME ?= unknown

all:
	docker build -t $(USERNAME)/b.p.o image
.PHONY: all
