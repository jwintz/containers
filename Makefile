ENTRIES = base node

.PHONY: all $(ENTRIES)

all: $(ENTRIES)

$(ENTRIES):
	container build --tag $@ --file $@.dockerfile build
