#include <stdio.h>


__global__ void print() {
	printf("block = %d, thread = %d\n", blockIdx.x, threadIdx.x);
}

int main() {
	print<<<3,3>>>();
	cudaDeviceSynchronize();

}
