
#include <iostream>

__global__ void arradd(int *x, int *y, int *z) {
    int id = blockIdx.x;
    z[id] = x[id] + y[id];
}

int main() {
    int a[6];
    int b[6];
    int c[6];
    int *d, *e, *f;
    int i;

    std::cout << "Enter six elements of first array" << std::endl;
    for (i = 0; i < 6; i++) {
        std::cin >> a[i];
    }

    std::cout << "Enter six elements of second array" << std::endl;
    for (i = 0; i < 6; i++) {
        std::cin >> b[i];
    }

    cudaMalloc((void **)&d, 6 * sizeof(int));
    cudaMalloc((void **)&e, 6 * sizeof(int));
    cudaMalloc((void **)&f, 6 * sizeof(int));

    cudaMemcpy(d, a, 6 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(e, b, 6 * sizeof(int), cudaMemcpyHostToDevice);

    arradd<<<6, 1>>>(d, e, f);

    cudaMemcpy(c, f, 6 * sizeof(int), cudaMemcpyDeviceToHost);

    std::cout << "Sum of two arrays:" << std::endl;
    for (i = 0; i < 6; i++) {
        std::cout << c[i] << "\t";
    }
    std::cout << std::endl;

    cudaFree(d);
    cudaFree(e);
    cudaFree(f);

    return 0;
}
