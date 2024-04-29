VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`
SRC_LIBS += ../hardware/src

sim: sim.exe

%.exe: %.mk
	make -C ./obj_dir -f V$<

%.mk: %.sv
	verilator ${VFLAGS} -I${SRC_LIBS} \
	    -cc $< --exe $(basename $@)_sdl.cpp -o $(basename $@)_sdl \
		-CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS} -mconsole"

all: sim

clean:
	rm -rf ./obj_dir

.PHONY: all clean