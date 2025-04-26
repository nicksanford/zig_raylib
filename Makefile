.PHONY: all

all: raylib/zig-out
	zig build

raylib/zig-out: raylib/.git raygui/.git
	cd raylib && zig build

raylib/.git:
	git submodule init
	git submodule update

raygui/.git:
	git submodule init
	git submodule update
