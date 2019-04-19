#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {

  int adder = 32;

    for (int i = 0; i < SIZE; i += adder) {
        for (int j = 0; j < SIZE; j += adder) {

          int minX = min(i+adder,SIZE);
          int minY = min(j+adder,SIZE);

            for(int x=i; x< minX; x++){
              for(int y=j; y<minY; y++){

                  dest[x][y] = src[y][x];

              }
            }

        }
    }
}
