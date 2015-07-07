* cuda notes

** structure
*** cpu vs gpu
1. cpu bigger cache, branch predict
2. gpu multiple ALU
[[./img/gpu-cpu.png]]

*** cuda conception
SMX, GPU负责将这些block分配到SM，所有SM独立并行的执行。一个block内的所有threads会在同一处理器内核上共享内存资源，所以block内有多少threads是有限制的。目前GPU限制每个 block最多有1024个threads。
+ thread 
+ block
+ grid
[[./img/smx.png]]

** task 
+ map 1-1
+ gather N-1, e.g sum, average 
+ scatter 1-N
+ transpose
some arithmetic: reduce scan historgram


** memory
+ host(cpu) memory | device(gpu) memory
+ local > shared > global
+ coalesced > strided > random(连续 > 固定步长 > 随机)


** program efficiency
+ expand concurrency 增大并发
+ reduce access memory 减少访存

** program pattern
从执行角度看，程序经过了以下步骤：
1. initialises card
2. allocates memory in host and on device
3. copies data from host to device memory
4. launches multiple instances of execution “kernel” on device
5. copies data from device memory to host
6. repeats 3-5 as needed
7. de-allocates all memory and terminates
总结：每个kernel放在一个grid上执行，1个kernel有多个instance，每个instance在一个block上执行，每个block只能在一个SM上执行，如果block数>SM数，多个block抢SM用。kernel的一个instance在SMX上通过一组进程来执行。


** program details

1. if(tid < N) 存储保护
2. __device__
3. __syncthreads(), 线程同步, a[i] = a[i-1] assign.cu
4. __shared__ memory, 数组求和使用 sum.cu
5. atomicAdd

The CUDA model uses huge numbers of threads to hide memory latency (the time it takes for a memory request to
come back). Typically, latency to the global memory (DRAM) is around 400–600 cycles. During
this time the GPU is busy doing other tasks, rather than idly waiting for the memory fetch to complete.
