# crbin - Clearly Random Binary
# Multi-architecture build system
# Version: 0.12.0

CRBIN_VERSION = 0.12.0
SRC = crbin.c
OUT = build

all: linux musl macos

linux: \
	$(OUT)/crbin-amd64 \
	$(OUT)/crbin-i386 \
	$(OUT)/crbin-arm64 \
	$(OUT)/crbin-armhf \
	$(OUT)/crbin-mips \
	$(OUT)/crbin-mipsel \
	$(OUT)/crbin-riscv64

$(OUT)/crbin-amd64: $(SRC)
	mkdir -p $(OUT)
	x86_64-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-i386: $(SRC)
	mkdir -p $(OUT)
	i686-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-arm64: $(SRC)
	mkdir -p $(OUT)
	aarch64-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-armhf: $(SRC)
	mkdir -p $(OUT)
	arm-linux-gnueabihf-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-mips: $(SRC)
	mkdir -p $(OUT)
	mips-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-mipsel: $(SRC)
	mkdir -p $(OUT)
	mipsel-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-riscv64: $(SRC)
	mkdir -p $(OUT)
	riscv64-linux-gnu-gcc $(SRC) -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

musl: \
	$(OUT)/crbin-musl-amd64 \
	$(OUT)/crbin-musl-i386 \
	$(OUT)/crbin-musl-arm64

$(OUT)/crbin-musl-amd64: $(SRC)
	mkdir -p $(OUT)
	x86_64-linux-musl-gcc $(SRC) -static -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-musl-i386: $(SRC)
	mkdir -p $(OUT)
	i386-linux-musl-gcc $(SRC) -static -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-musl-arm64: $(SRC)
	mkdir -p $(OUT)
	aarch64-linux-musl-gcc $(SRC) -static -O2 -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

macos: \
	$(OUT)/crbin-macos-amd64 \
	$(OUT)/crbin-macos-arm64

$(OUT)/crbin-macos-amd64: $(SRC)
	mkdir -p $(OUT)
	o64-clang $(SRC) -O2 -target x86_64-apple-darwin -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

$(OUT)/crbin-macos-arm64: $(SRC)
	mkdir -p $(OUT)
	o64-clang $(SRC) -O2 -target arm64-apple-darwin -DCRBIN_VERSION=\"$(CRBIN_VERSION)\" -o $@

clean:
	rm -rf $(OUT)

.PHONY: all linux musl macos clean
