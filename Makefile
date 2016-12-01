
# Default username for docker registry
USERNAME ?= unknown
# Default base distribution
BASE_DISTRO ?= ubuntu

ifeq ($(BASE_DISTRO), fedora)
  DOCKERFILE := image/Dockerfile.fedora
else
  DOCKERFILE := image/Dockerfile.ubuntu
endif

all:
	docker build -t $(USERNAME)/b.p.o -f $(DOCKERFILE) image
.PHONY: all
