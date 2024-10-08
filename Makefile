# SPDX-License-Identifier: MIT

SOURCES = src/tps65185.chip.c 
INCLUDES = -I . -I include
CHIP_JSON = tps65185.chip.json

TARBALL  = dist/chip.tar.gz
TARGET  = dist/chip.out

.PHONY: all
all: clean $(TARBALL)

.PHONY: clean
clean:
		rm -rf dist

dist:
		mkdir -p dist

$(TARBALL): $(TARGET) dist/chip.json
	ls -l dist
	tar czf $(TARBALL) $(TARGET) dist/chip.json

dist/chip.json:
	cp $(CHIP_JSON) dist/chip.json

$(TARGET): dist $(SOURCES)
	clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--import-memory -Wl,--export-table -Wl,--no-entry -Werror  $(INCLUDES) -o $(TARGET) $(SOURCES)
