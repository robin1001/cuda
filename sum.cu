#include <stdio.h>
#include <assert.h>

#define N 16

__global__ void assign(int *arr, int *r) {
	__shared__ int data[N];
	int tid = threadIdx.x;	
	if (tid < N) {
		data[tid] = arr[tid];
		__syncthreads();
		for (int i = blockDim.x / 2; i != 0; i /= 2) {
			if (tid < i) {
				data[tid] += data[tid+i];	
				__syncthreads();
			}
		}
	}
	if (blockIdx.x == 0)	
		*r = data[0];
}


int main() {
	int arr[N] = {0};
	int *dev_arr;
	int *dev_r;
	int r, v = 0;
	for (int i = 0; i < N; i++)	{
		arr[i] = i;
		v += arr[i];
	}
	cudaMalloc(&dev_arr, N * sizeof(int));
	cudaMemcpy(dev_arr, arr, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMalloc(&dev_r, sizeof(int));

	assign<<<1, N>>>(dev_arr, dev_r);
	cudaMemcpy(&r, dev_r, sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(dev_arr);
	cudaFree(dev_r);

	printf("%d %d\n", r, v);
	assert(r == v);
}
