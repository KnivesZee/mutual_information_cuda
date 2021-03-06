#include <stdio.h>
// CUDA 
#include <cuda_runtime.h>
#include <helper_functions.h>
#include <helper_cuda.h>
// project 
#include "mutual_information_common.h"
#define MERGE_THREADBLOCK_SIZE 64


static const float  BIN_COUNT = 64;
static const float  MAX = 255;
static const float  MIN = 0;
static const float  PADDING = 2;
static const float MovingImageNormalizedMin = -2;
static const float FixedImageNormalizedMin = -2;
// std::numeric_limits<float>::epsilon();
static const float epsilon = 1.19209e-007;
static const uint  ParzenWindowIndexMin = 2;
static const uint  ParzenWindowIndexMax = BIN_COUNT - 3;
// static const float BINSIZE = (MAX - MIN) / (BIN_COUNT - 2 * PADDING);
static const float ONE_OVER_BINSIZE = (BIN_COUNT - 2 * PADDING) / (MAX - MIN) ;


// Cubic Bspline kernel function
inline __device__ float cubicBSplineKernel( float u )
{
  float sqru = u * u;
  if ( u  < 1 )
    return fdividef( fmaf(-sqru, 6, 4) + 3 * sqru * u,  6 );
  else if ( u < 2 )
    return fdividef( fmaf(u, -12, 8) + fmaf(sqru, 6, -sqru * u), 6 );   
  else
    return 0;
}


// Parzen Windowing kernel function 
__device__ void parzenWindowKernel( float *s_perBlockJointHist,
				    uint *s_perWarpFixedImageHistogram,
				    uchar fixedImageValue,   
				    uchar movingImageValue,
				    uint dataCount ) 
{
  uint fixedImageParzenWindowIndex = (uint)floorf( fmaf( fixedImageValue, ONE_OVER_BINSIZE, - FixedImageNormalizedMin ));
  
  if (fixedImageParzenWindowIndex < ParzenWindowIndexMin)
    fixedImageParzenWindowIndex = ParzenWindowIndexMin;
  else if (fixedImageParzenWindowIndex > ParzenWindowIndexMax)
    fixedImageParzenWindowIndex = ParzenWindowIndexMax;
  
  atomicAdd(s_perWarpFixedImageHistogram + fixedImageParzenWindowIndex, 1);
  
  float movingImageParzenWindowTerm = fmaf( movingImageValue, ONE_OVER_BINSIZE, - MovingImageNormalizedMin);

  uint movingImageParzenWindowIndex = (uint)floorf(movingImageParzenWindowTerm);
  movingImageParzenWindowIndex =(movingImageParzenWindowIndex < ParzenWindowIndexMin) ? ParzenWindowIndexMin : movingImageParzenWindowIndex;

  uint pdfMovingImageParzenWindowIndex = movingImageParzenWindowIndex - 1;
  float movingImageParzenWindowArg = pdfMovingImageParzenWindowIndex - movingImageParzenWindowTerm; 

  float *s_JointHistParzenWindowIdx = s_perBlockJointHist + fixedImageParzenWindowIndex * HISTOGRAM64_BIN_COUNT + pdfMovingImageParzenWindowIndex;
  
  // Parzen Window index 0
  atomicAdd( s_JointHistParzenWindowIdx, fdividef( cubicBSplineKernel( fabsf( movingImageParzenWindowArg )), dataCount) );  
  // Parzen Window index 1
  atomicAdd( ++s_JointHistParzenWindowIdx, fdividef( cubicBSplineKernel( fabsf( ++movingImageParzenWindowArg )), dataCount) );  
  // Parzen Window index 2
  atomicAdd( ++s_JointHistParzenWindowIdx, fdividef( cubicBSplineKernel( fabsf( ++movingImageParzenWindowArg )), dataCount) );   
  // Parzen Window index 3
  atomicAdd( ++s_JointHistParzenWindowIdx, fdividef( cubicBSplineKernel( fabsf( ++movingImageParzenWindowArg )), dataCount) );   
}

// <<<64  , 32*32 >>> 
__global__ void histogram64Kernel( float *d_PartialJointHistograms,
				   uint *d_PartialFixedImageHistograms,
				   uchar *d_Data1,
				   uchar *d_Data2,
				   uint dataCount)
{
  __shared__ uint s_Hist[HISTOGRAM64_THREADBLOCK_MEMORY];                 
  __shared__ float s_JointPDF[JOINT_HISTOGRAM64_THREADBLOCK_MEMORY];         
  
#pragma unroll
  for (uint i = 0; i < (HISTOGRAM64_THREADBLOCK_MEMORY / HISTOGRAM64_THREADBLOCK_SIZE); i++)
    {
      s_Hist[threadIdx.x + i * HISTOGRAM64_THREADBLOCK_SIZE] = 0;
    }
  for (uint i = 0; i < (JOINT_HISTOGRAM64_THREADBLOCK_MEMORY / HISTOGRAM64_THREADBLOCK_SIZE); i++)
    {
      s_JointPDF[threadIdx.x + i * HISTOGRAM64_THREADBLOCK_SIZE] = 0;
    }
  __syncthreads();
  // map 1024(32*32) threads into 32 warps 
  // 1st round:
  // threadID       =  0, 1, 2, 3 ... 31; (1 Warp has 32 threads)
  // WarpHistId     =  0, 1, 2, 3 ... 31; (1 threadblock has 32 Histograms)
  // 2nd round:
  // threadID       = 32, 33, 34 .... 63;
  // WarpHistId     =  0,  1,  2 .....31;
  // so on and so forth. 
  uint *s_WarpHist = s_Hist +  ( threadIdx.x & WARP_COUNT - 1 ) *  HISTOGRAM64_BIN_COUNT;

  for (uint pos = UMAD(blockIdx.x, blockDim.x, threadIdx.x); pos < dataCount; pos += UMUL(blockDim.x, gridDim.x))
    {
      parzenWindowKernel(s_JointPDF, s_WarpHist, d_Data1[pos],  d_Data2[pos], dataCount);
    }
  
  __syncthreads();
  
  uint bin = threadIdx.x;

  if (bin < HISTOGRAM64_BIN_COUNT)
    {
      uint sum = 0;
      for (uint i = 0; i < WARP_COUNT; ++i)
	{
	  sum += s_Hist[bin + i * HISTOGRAM64_BIN_COUNT];
	}
      d_PartialFixedImageHistograms[blockIdx.x * HISTOGRAM64_BIN_COUNT + bin] = sum;
    }
// Write per-block joint-histogram to global memory
  for (uint i = 0; i < (JOINT_HISTOGRAM64_THREADBLOCK_MEMORY / HISTOGRAM64_THREADBLOCK_SIZE); i++)
    {
      d_PartialJointHistograms[blockIdx.x * JOINT_HISTOGRAM64_BIN_COUNT + threadIdx.x + i * HISTOGRAM64_THREADBLOCK_SIZE]
	= s_JointPDF[threadIdx.x + i * HISTOGRAM64_THREADBLOCK_SIZE];
    }
}


//<<<HISTOGRAM64_BIN_COUNT, MERGE_THREADBLOCK_SIZE>>>
__global__ void mergeHistogram64Kernel(  uint *d_Histogram,
					 uint *d_PartialHistograms,
					 uint histogramCount )
{
  uint sum = 0;
  for (uint i = threadIdx.x; i < histogramCount; i += MERGE_THREADBLOCK_SIZE)
    {
      sum += d_PartialHistograms[blockIdx.x + i * HISTOGRAM64_BIN_COUNT];
    }
  
  __shared__ uint data[MERGE_THREADBLOCK_SIZE];

  data[threadIdx.x] = sum;
  
  for (uint stride = MERGE_THREADBLOCK_SIZE / 2; stride > 0; stride >>= 1)
    {
      __syncthreads();
      if (threadIdx.x < stride)
	{
	  data[threadIdx.x] += data[threadIdx.x + stride];
	}
    }

  if (threadIdx.x == 0)
    {
      d_Histogram[blockIdx.x] = data[0];
    }
}



//<<< 64 * 64 , 64 >>>
__global__ void mergeJointHistogram64Kernel(float *d_JointHistogram, float *d_PartialHistograms, uint jointHistogramCount )
{
  float sum = 0;
  for (uint i = threadIdx.x; i < jointHistogramCount; i += MERGE_THREADBLOCK_SIZE)
    {
      sum += d_PartialHistograms[blockIdx.x + i * JOINT_HISTOGRAM64_BIN_COUNT];
    }

  __shared__ float data[MERGE_THREADBLOCK_SIZE];

  data[threadIdx.x] = sum;

  /*
  for (uint stride = MERGE_THREADBLOCK_SIZE / 2; stride > 0; stride >>= 1)
    {
      __syncthreads();
      if (threadIdx.x < stride)
	{
	  data[threadIdx.x] += data[threadIdx.x + stride];
	}
    }
  if (threadIdx.x == 0)
    {
      d_JointHistogram[blockIdx.x] = data[0];
    }
  */

  // for MERGE_THREADBLOCK_SIZE = 64 only.
  __syncthreads();
  uint tid = threadIdx.x;
  if (tid < 32) data[tid] += data[tid + 32];
  if (tid < 16) data[tid] += data[tid + 16];
  if (tid < 8)  data[tid] += data[tid + 8];
  if (tid < 4)  data[tid] += data[tid + 4];
  if (tid < 2)  data[tid] += data[tid + 2];
  if (tid < 1)  data[tid] += data[tid + 1];
  // blockIdx is the bin number.
  if (tid == 0) d_JointHistogram[blockIdx.x] = data[0];
  
}


//<<<64, 64 >>>
__global__ void movingImagePDFKernel(float *d_Histogram2, float *d_JointHistogram)
{
  __shared__ float s_perRowJointHist[64];

  uint tid = threadIdx.x;
  s_perRowJointHist[tid] = d_JointHistogram[blockIdx.x + HISTOGRAM64_BIN_COUNT * tid];
  __syncthreads();

  if (tid < 32)
      s_perRowJointHist[tid] += s_perRowJointHist[tid + 32];
  if (tid < 16)
    s_perRowJointHist[tid] += s_perRowJointHist[tid + 16];
  if (tid < 8)
    s_perRowJointHist[tid] += s_perRowJointHist[tid + 8];
  if (tid < 4)
    s_perRowJointHist[tid] += s_perRowJointHist[tid + 4];
  if (tid < 2)
    s_perRowJointHist[tid] += s_perRowJointHist[tid + 2];
  if (tid < 1)
    s_perRowJointHist[tid] += s_perRowJointHist[tid + 1];
  if (tid == 0)
    d_Histogram2[blockIdx.x] = s_perRowJointHist[0];
}





static const uint  PARTIAL_HISTOGRAM64_COUNT = 64;

static uint *d_PartialFixedImageHistograms;
static float *d_PartialJointHistograms;
static float *d_partialMattesMutualInfo;


//Internal memory allocation
extern "C" void initMattesMutualInfo(void)
{
  checkCudaErrors(cudaMalloc((void **)&d_PartialFixedImageHistograms, PARTIAL_HISTOGRAM64_COUNT * HISTOGRAM64_BIN_COUNT * sizeof(uint)));
  checkCudaErrors(cudaMalloc((void **)&d_PartialJointHistograms, PARTIAL_HISTOGRAM64_COUNT * JOINT_HISTOGRAM64_BIN_COUNT * sizeof(float)));
  checkCudaErrors(cudaMalloc((void **)&d_partialMattesMutualInfo, HISTOGRAM64_BIN_COUNT * sizeof(float)));
}


//Internal memory deallocation
extern "C" void closeMattesMutualInfo(void)
{
  checkCudaErrors(cudaFree(d_PartialFixedImageHistograms));
  checkCudaErrors(cudaFree(d_PartialJointHistograms));
    checkCudaErrors(cudaFree(d_partialMattesMutualInfo));
}



extern "C" void computeHistogramAndJointPDF(  float *d_JointPDF,
					      uint *d_FixedImageHist,
					      float *d_MovingImagePDF,
					      void *d_Data1,
					      void *d_Data2,
					      uint dataCount)
{
  histogram64Kernel<<<PARTIAL_HISTOGRAM64_COUNT, HISTOGRAM64_THREADBLOCK_SIZE>>>( d_PartialJointHistograms,
										  d_PartialFixedImageHistograms,
										  (uchar *) d_Data1,
										  (uchar *) d_Data2,
										  dataCount);
  getLastCudaError("histogram64Kernel() execution failed\n");
  

  mergeHistogram64Kernel<<<HISTOGRAM64_BIN_COUNT, MERGE_THREADBLOCK_SIZE>>>( d_FixedImageHist,
									     d_PartialFixedImageHistograms,
									     PARTIAL_HISTOGRAM64_COUNT );
  getLastCudaError("mergeHistogram64Kernel() execution failed\n");
  

  mergeJointHistogram64Kernel<<<JOINT_HISTOGRAM64_BIN_COUNT, MERGE_THREADBLOCK_SIZE>>>( d_JointPDF,
											d_PartialJointHistograms,
											PARTIAL_HISTOGRAM64_COUNT );
  getLastCudaError("mergeJointHistogram64Kernel() execution failed\n");


  movingImagePDFKernel<<<HISTOGRAM64_BIN_COUNT, HISTOGRAM64_BIN_COUNT>>>(d_MovingImagePDF, d_JointPDF);
  getLastCudaError("movingImagePDFKernel\n");
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Mattes Mutual Information kernel
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//<<<64,64>>>
__global__ void MattesMutualInformation_kernel( float *d_partialMattesMutualInfo,
						uint *d_FixedImageHist,
						float *d_MovingImagePDF,
						float *d_JointPDF,
						uint totalCount)
{
  __shared__ float fixedImagePDF; 
  __shared__ float perBlockPartialMutualInfo[64];
  
  uint tid = threadIdx.x;
  if (tid < 64)
    {
      perBlockPartialMutualInfo[tid] = 0;
    }
  __syncthreads();
  
  fixedImagePDF = (float)d_FixedImageHist[blockIdx.x] / totalCount;
  float jointPDF = d_JointPDF[blockIdx.x * HISTOGRAM64_BIN_COUNT + tid];
  float movingImagePDF = d_MovingImagePDF[tid];

  if ( movingImagePDF > epsilon && jointPDF > epsilon)
    {
      perBlockPartialMutualInfo[tid] = jointPDF * ( log2f(jointPDF) - log2f(movingImagePDF) - log2f(fixedImagePDF) );
      //printf("tid: %d\njointPDF = %f\tmovingImagePDF = %f\tfixedImagePDF = %f\n", tid, jointPDF, movingImagePDF, fixedImagePDF);
    }
  __syncthreads();


  if (tid < 32)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 32];
  if (tid < 16)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 16];
  if (tid < 8)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 8];
  if (tid < 4)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 4];
  if (tid < 2)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 2];
  if (tid < 1)
    perBlockPartialMutualInfo[tid] += perBlockPartialMutualInfo[tid + 1];
  if (tid == 0)
    d_partialMattesMutualInfo[blockIdx.x] = perBlockPartialMutualInfo[0];
}

//<<< 1 , 64 >>>
__global__ void mergeMattesMutualInforMation_kernel(float *d_MattesMutualInfo, float *d_partialMattesMutualInfo)
{
  uint tid = threadIdx.x;
  if (tid < 32)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 32];
  if (tid < 16)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 16];
  if (tid < 8)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 8];
  if (tid < 4)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 4];
  if (tid < 2)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 2];
  if (tid < 1)
    d_partialMattesMutualInfo[tid] += d_partialMattesMutualInfo[tid + 1];
  if (tid == 0)
    *d_MattesMutualInfo = - d_partialMattesMutualInfo[0];
  // Notice the negative sign, because we seek minimum value when registrating two images. It is merely a convention.
}


extern "C" void computeMattesMutualInformation( float *d_MattesMutualInfo,
					        uint *d_FixedImageHist,
					        float *d_MovingImagePDF,
						float *d_JointPDF,
						uint  pixelCount)
{  
  //puts("MattesMutualInformation_kernel");
  MattesMutualInformation_kernel<<<HISTOGRAM64_BIN_COUNT, HISTOGRAM64_BIN_COUNT>>>( d_partialMattesMutualInfo,
										    d_FixedImageHist,
										    d_MovingImagePDF,
										    d_JointPDF,
										    pixelCount);
  getLastCudaError("MattesMutualInformation_kernel() execution failed\n");

  //puts("mergeMattesMutualInformation_kernel");
  mergeMattesMutualInforMation_kernel<<<1, HISTOGRAM64_BIN_COUNT>>>(d_MattesMutualInfo,
								    d_partialMattesMutualInfo);
  getLastCudaError("mergeMattesMutualInforMation_kernel() execution failed\n");
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Mattes mutual information kernel
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


extern "C" bool cudaMattesMutualInformation64( float *h_MattesMutualInfo,
					       float *h_JointPDF,
					       uint *h_Histogram1,
					       float *h_Histogram2,
					       uchar *h_Data1,
					       uint dataCount1,
					       uchar *h_Data2,
					       uint dataCount2)
{
  
  cudaEvent_t start_device, stop_device;
  cudaEventCreate(&start_device);
  cudaEventCreate(&stop_device);
  cudaEventRecord(start_device,0);
  
  
  uint dataCount = (dataCount1 < dataCount2) ? dataCount1 : dataCount2;
  uchar *d_Data1, *d_Data2;
  uint *d_Histogram1;
  float *d_Histogram2;
  float *d_JointPDF;
 

  checkCudaErrors(cudaMalloc((void **)&d_Data1, dataCount));
  checkCudaErrors(cudaMalloc((void **)&d_Data2, dataCount));
  checkCudaErrors(cudaMemcpy(d_Data1, h_Data1, dataCount, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_Data2, h_Data2, dataCount, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMalloc((void **)&d_Histogram1, HISTOGRAM64_BIN_COUNT * sizeof(uint)));
  checkCudaErrors(cudaMalloc((void **)&d_Histogram2, HISTOGRAM64_BIN_COUNT * sizeof(float)));
  checkCudaErrors(cudaMalloc((void **)&d_JointPDF, HISTOGRAM64_BIN_COUNT * HISTOGRAM64_BIN_COUNT * sizeof(float)));
  
  /* init CUDA */
  initMattesMutualInfo();

  /* start histogram calculation */
  computeHistogramAndJointPDF( d_JointPDF, d_Histogram1, d_Histogram2, d_Data1, d_Data2, dataCount );
  cudaDeviceSynchronize();
  
  // uncomment following code if need to see histograms of two images, and their joint histogram.
  // Histogram data is not needed to be returned. Main purpuse here is for debugging.
  checkCudaErrors(cudaMemcpy(h_Histogram1,
			     d_Histogram1,
			     HISTOGRAM64_BIN_COUNT * sizeof(uint),	
			     cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(h_Histogram2,
			     d_Histogram2,
			     HISTOGRAM64_BIN_COUNT * sizeof(float),	
			     cudaMemcpyDeviceToHost));
  
  checkCudaErrors(cudaMemcpy(h_JointPDF,
			     d_JointPDF,
			     HISTOGRAM64_BIN_COUNT * HISTOGRAM64_BIN_COUNT * sizeof(float),	
			     cudaMemcpyDeviceToHost));

  
  float *d_MattesMutualInfo;
  checkCudaErrors(cudaMalloc((void **)&d_MattesMutualInfo, sizeof(float)));

  /* Compute Mattes Mutual Info */
  computeMattesMutualInformation(d_MattesMutualInfo, d_Histogram1, d_Histogram2, d_JointPDF, dataCount);
  cudaDeviceSynchronize();
  checkCudaErrors(cudaMemcpy(h_MattesMutualInfo, d_MattesMutualInfo, sizeof(float), cudaMemcpyDeviceToHost));
  
  closeMattesMutualInfo();
  checkCudaErrors(cudaFree(d_Data1));
  checkCudaErrors(cudaFree(d_Data2));
  checkCudaErrors(cudaFree(d_Histogram1));
  checkCudaErrors(cudaFree(d_Histogram2));
  checkCudaErrors(cudaFree(d_JointPDF));

  
  cudaEventRecord(stop_device,0);
  cudaEventSynchronize(stop_device);
  float device_time;
  cudaEventElapsedTime(&device_time, start_device, stop_device);
  printf("CUDA Device Total Running Time         =  %f ms\n\n", device_time );
  
  return 0;
}