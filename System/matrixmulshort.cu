
#include <iostream>
#include <cuda_runtime.h>

#define row1 2 /* Number of rows of first matrix */
#define col1 3 /* Number of columns of first matrix */
#define row2 3 /* Number of rows of second matrix */
#define col2 2 /* Number of columns of second matrix */

__global__ void matproductsharedmemory(int *l, int *m, int *n)
{
    int x = blockIdx.x;
    int y = blockIdx.y;

    // Calculate the index of the element to be computed
    int idx = y * col2 + x;

    // Initialize the value to store the product of the corresponding row of 'l' and column of 'm'
    int sum = 0;

    // Iterate over each element of the row of 'l' and column of 'm' to compute the dot product
    for (int i = 0; i < col1; ++i)
    {
        sum += l[y * col1 + i] * m[i * col2 + x];
    }

    // Store the result in the output matrix
    n[idx] = sum;
}

int main()
{
    int a[row1][col1];
    int b[row2][col2];
    int c[row1][col2];
    int *d, *e, *f;
    int i, j;

    std::cout << "\nEnter elements of first matrix of size 2*3\n";
    for (i = 0; i < row1; i++)
    {
        for (j = 0; j < col1; j++)
        {
            std::cin >> a[i][j];
        }
    }
    std::cout << "\nEnter elements of second matrix of size 3*2\n";
    for (i = 0; i < row2; i++)
    {
        for (j = 0; j < col2; j++)
        {
            std::cin >> b[i][j];
        }
    }

    cudaMalloc((void **)&d, row1 * col1 * sizeof(int));
    cudaMalloc((void **)&e, row2 * col2 * sizeof(int));
    cudaMalloc((void **)&f, row1 * col2 * sizeof(int));

    cudaMemcpy(d, a, row1 * col1 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(e, b, row2 * col2 * sizeof(int), cudaMemcpyHostToDevice);

    dim3 grid(col2, row1);

    matproductsharedmemory<<<grid, 1>>>(d, e, f);

    cudaMemcpy(c, f, row1 * col2 * sizeof(int), cudaMemcpyDeviceToHost);

    std::cout << "\nProduct of two matrices:\n";
    for (i = 0; i < row1; i++)
    {
        for (j = 0; j < col2; j++)
        {
            std::cout << c[i][j] << "\t";
        }
        std::cout << std::endl;
    }

    cudaFree(d);
    cudaFree(e);
    cudaFree(f);

    return 0;
}


