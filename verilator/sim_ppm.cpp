#define NO_STDIO_REDIRECT

#include "Vsim.h"
#include <stdio.h>
#include <conio.h>
#include <iostream>
#include <queue>
#include <verilated.h>
#include <string>

// screen dimensions
const int HRES = 640;
const int VRES = 480;

typedef struct Pixel
{
  int x;
  int y;
  uint8_t a; // transparency
  uint8_t b; // blue
  uint8_t g; // green
  uint8_t r; // red

  Pixel(Vsim &sim)
  {
    x = sim.sx;
    y = sim.sy;
    a = 0xFF;
    r = static_cast<uint8_t>(sim.blue);
    g = static_cast<uint8_t>(sim.green);
    b = static_cast<uint8_t>(sim.red);
  }
  std::string to_string()
  {
    // return std::to_string(r) + " " + std::to_string(g) + " " + std::to_string(b) + " (" + std::to_string(x) + "," + std::to_string(y) + ")";
    return std::to_string(r) + " " + std::to_string(g) + " " + std::to_string(b);
  }
} Pixel;

bool poll_key(char *c)
{
  *c = getch();
  return c ? true : false;
}

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

int main(int argc, char *argv[])
{
  Verilated::commandArgs(argc, argv);

  int sample_frame = 0;
  if (argc > 1) {
    sample_frame = atoi(argv[1]);
  }

  //printf("Simulation running. 'Q' or escape key to exit.\n\n");

  // initialize Verilog modules
  Vsim sim = Vsim();

  uint64_t frame_count = 0;
  uint64_t start_ticks = 0;

  char key = ' ';

  std::queue<Pixel> pixels;

  int frame = 0;
  int cycles = 0;
  int max_x = 0;
  int max_y = 0;
  int vsync_cycles = 0;
  int hsync_cycles = 0;
  int num_pixels = 0;

  while (true)
  {
    // cycle the clock
    sim.video_clk_pix = 1;
    sim.eval();
    sim.video_clk_pix = 0;
    sim.eval();
    ++cycles;
    vsync_cycles += sim.vsync;
    hsync_cycles += sim.hsync;
    max_x = MAX(max_x, sim.sx);
    max_y = MAX(max_y, sim.sy);

    if (sim.video_enable)
    {
      pixels.push(Pixel(sim));
      ++num_pixels;
    }

    if (sim.frame_start)
    {
      if (frame == sample_frame)
      {
        std::cout << "P3\n"
                  << HRES << ' ' << VRES << "\n255\n";
        while (!pixels.empty())
        {
          auto p = pixels.front();
          std::cout << p.to_string() << '\n';
          pixels.pop();
        }
        break;
      }

      ++frame;
      max_x = 0;
      max_y = 0;
      std::queue<Pixel>().swap(pixels);
    }
  }

  sim.final(); // simulation done
  return 0;
}
