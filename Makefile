.PHONY all

all: raylib/.git

raylib/.git:
	git submodule init
	git submodule update
