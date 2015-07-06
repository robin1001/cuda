#include <stdio.h>

#define N 512

__global__ void add(int *a, int *b, int *c) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	if (tid < N) 
		c[tid] = a[tid] + b[tid];
}

int main() {
	int a[N], b[N], c[N];
	int *dev_a, *dev_b, *dev_c;
	for (int i = 0; i < N; i++) {
		a[i] = i;
		b[i] = 1;
	}
	cudaMalloc((void **)&dev_a, N * sizeof(int));
	cudaMalloc((void **)&dev_b, N * sizeof(int));
	cudaMalloc((void **)&dev_c, N * sizeof(int));
	cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
	int block_dim = 128;
	int grid_dim = N / block_dim;
	add<<<grid_dim, block_dim>>>(dev_a, dev_b, dev_c);
	cudaMemcpy(&c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
	for (int i = 0; i < N; i++) {
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	}
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
    return 0;
}
