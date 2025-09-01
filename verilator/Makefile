VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`
SRC_LIBS += ../hardware/src

msys_version := $(if $(findstring Msys, $(shell uname -o)),$(word 1, $(subst ., ,$(shell uname -r))),0)

sim: sim.exe

%.exe: %.mk
	make -C ./obj_dir -f V$<

%.mk: %.sv
ifeq ($(msys_version),0)
	verilator ${VFLAGS} -I${SRC_LIBS} \
	    -cc $< --exe $(basename $@)_sdl.cpp -o $(basename $@)_sdl \
		-CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"
else
	verilator ${VFLAGS} -I${SRC_LIBS} \
	    -cc $< --exe $(basename $@)_sdl.cpp -o $(basename $@)_sdl \
		-CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS} -mconsole"
endif

all: sim

clean:
	rm -rf ./obj_dir

.PHONY: all clean

