#include <stdio.h>

#define BLOCK_SIZE 64

__global__ void Mul(int *a, int *b, int row_a, int col_a, int row_b, int col_b, int *c) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	if (tid < row_a * col_b) {
        int value = 0;
        int row  = tid / col_b, col = tid % col_b;
		for (int k = 0; k < col_a; k++)
			value += a[row * col_a + k] * b[k * col_b + col];
		c[tid] = value;
		//c[tid] = 1;
	}
}

int main() {
    int data_a[3][3] = {0}, data_b[3][3] = {0}, data_c[3][3];
    int *dev_a, *dev_b, *dev_c;
    data_a[0][0] = 1, data_a[1][1] = 1, data_a[2][2] = 1;
    data_b[0][0] = 2, data_b[1][1] = 1, data_b[2][2] = 1;

	cudaMalloc((void **)&dev_a, 3 * 3 * sizeof(int));
	cudaMemcpy(dev_a, data_a, 3 * 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMalloc((void **)&dev_b, 3 * 3 * sizeof(int));
	cudaMemcpy(dev_b, data_b, 3 * 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMalloc((void **)&dev_c, 3 * 3 * sizeof(int));
    Mul<<<10, 10>>>(dev_a, dev_b, 3, 3, 3, 3, dev_c);
	cudaMemcpy(data_c, dev_c, 3 * 3 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
	
    for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			printf("%d ", data_c[i][j]);
		}
		printf("\n");
	}
}


