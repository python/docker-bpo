
ifeq ($(REPO),)
	REPO := unknown
endif

ifeq ($(OS),)
  DOCKERFILE := image/UbuntuDockerfile
else ifeq ($(OS), ubuntu)
  DOCKERFILE := image/UbuntuDockerfile
else ifeq ($(OS), fedora)
  DOCKERFILE := image/FedoraDockerfile
else
  $(error $(OS) is not supported. Please choose either Ubuntu or Fedora)
endif

all build:
	docker build -t $(REPO)/b.p.o -f $(DOCKERFILE) image
.PHONY: all build
