
#include "mandelbrot.h"
#include <xmmintrin.h>

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics
int *
cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];

   __m128 varA1, varB1, varA2, varB2;

    float temp[4];
    float final[4];

    for (int i = 0; i < SIZE; i += 4) {
        //varA1 = varB1 = 0.0;
        varA1 = _mm_loadu_ps(temp);
        varB1 = _mm_loadu_ps(temp);

        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate varA1^2 and varB1^2

            __m128 varA1_squared = _mm_mul_ps(varA1, varA1);
            __m128 varB1_squared = _mm_mul_ps(varB1, varB1);

            // Calculate the real piece of (varA1 + (varB1*i))^3 + (x + (y*i))

            varA2 = _mm_add_ps(_mm_mul_ps(varA1, _mm_sub_ps(varA1_squared, 3 * varB1_squared)), _mm_loadu_ps(&x[i]));

            // Calculate the imaginary portion of (varA1 + (varB1*i))^3 + (x + (y*i))
            varB2 = _mm_add_ps(_mm_mul_ps(varB1, _mm_sub_ps(3 * varA1_squared, varB1_squared)), _mm_loadu_ps(&y[i]));
            // Use the finaling complex number as the input for the next
            // iteration

            varA1 = varA2;
            varB1 = varB2;
        }

        // caculate the magnitude of the final;
        // we could take the square root, but we instead just
        // compare squares
        _mm_storeu_ps(final, _mm_add_ps(_mm_mul_ps(varA2, varA2), _mm_mul_ps(varB2, varB2)));

        ret[i+0] = final[0];
        ret[i+1] = final[1];
        ret[i+2] = final[2];
        ret[i+3] = final[3];
    }

    return ret;
}
