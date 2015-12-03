#include <thrust/device_vector.h>
#include <thrust/inner_product.h>
#include "util.cuh"

using namespace thrust;

namespace postinglist {

__host__ __device__
bool isAlpha(char c){
  return (c >= 'A' && c <= 'z');
}

struct IsWordStart {
  __host__ __device__
  bool operator()(const char left, const char right) const {
	return isAlpha(right) && !isAlpha(left);
  }
};

uint32_t CountWord(const device_vector<char>& input){
  if (input.empty()){
	return 0;
  }
  uint32_t count = inner_product
	(input.begin(), 
	 input.end()-1,
	 input.begin()+1,
	 0,
	 thrust::plus<uint32_t>(),
	 IsWordStart());
  if (isAlpha(input.front())){
	count++;
  }
  return count;
}
}
