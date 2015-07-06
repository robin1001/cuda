#include <stdio.h>

#define N 100

__global__ void assign(int *arr) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;	
	if (tid < N && tid > 0) {
        for (int i = 0; i < 50; i++) {
		    int tmp = arr[tid-1];
		    __syncthreads();
		    arr[tid] = tmp;
		    //arr[tid] = arr[tid-1]; //false operation
        }
	}
}


int main() {
	int arr[N] = {0};
	for (int i = 0; i < N; i++)
		arr[i] = i;
	int b[N] = {0};
	int *dev_arr;
	cudaMalloc(&dev_arr, N * sizeof(int));
	cudaMemcpy(dev_arr, arr, N * sizeof(int), cudaMemcpyHostToDevice);

	assign<<<16, 16>>>(dev_arr);
	cudaMemcpy(b, dev_arr, N * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(dev_arr);

	for (int i = 0; i < N; i++) {
		printf("%d ", b[i]);
	}
	printf("\n");
}
