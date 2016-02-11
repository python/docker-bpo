
ifeq ($(REPO),)
	REPO := unknown
endif

all build:
	docker build -t $(REPO)/b.p.o image
.PHONY: all build

