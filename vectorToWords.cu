#include <thrust/iterator/zip_iterator.h>
#include <thrust/reduce.h>
#include "postinglist.cuh"
#include "util.cuh"

using namespace thrust;

namespace postinglist {

__host__ __device__
bool isAlpha2(char c){
  return (c >= 'A' && c <= 'z');
}

struct IsAlpha : std::unary_function<char, bool>{
  __host__ __device__
  bool operator()(const char c){
	return isAlpha2(c);
  }
};

struct CharToHash : std::unary_function<char, hash_t>{
  __host__ __device__
  hash_t operator() (const char c){
	return static_cast<hash_t>(c);
  }
};

static const int WSIZE = 128;
__constant__ uint32_t hash_mult[WSIZE];

struct WordReducer {
  template<typename Tuple>
  __host__ __device__
  Tuple operator() (Tuple lhs, Tuple rhs){
	return Tuple
	  (thrust::get<0>(lhs) * hash_mult[thrust::get<2>(rhs)] + thrust::get<0>(rhs), // hash
	   thrust::get<1>(lhs), // position
	   thrust::get<2>(lhs) + thrust::get<2>(rhs)); // length
  }
};

void vectorToWords(const thrust::device_vector<char>& input,
				   thrust::device_vector<bool>& isWords,
				   thrust::device_vector<word_t>& words){
  uint64_t* hash_mult_host = new uint64_t[WSIZE];
  uint64_t hash = 33;
  for (int i = 1; i < WSIZE; i++) {
	  hash_mult_host[i] = hash;
	  hash *= 33;
  }
  cudaMemcpyToSymbol(hash_mult, hash_mult_host, WSIZE*sizeof(uint64_t));

  uint32_t size = input.size();
  reduce_by_key
	(make_transform_iterator
	 (input.begin(), IsAlpha()), // key begin
	 make_transform_iterator(input.begin(), IsAlpha()) + size, // key end
	 make_zip_iterator
	 (make_tuple
	  (make_transform_iterator(input.begin(), CharToHash()), // values begin
	   counting_iterator<position_t>(0),
	   constant_iterator<length_t>(1))),
	 isWords.begin(),// reduced key begin
	 words.begin(), // reduced val begin
	 thrust::equal_to<bool>(),// key equality
	 WordReducer());// reduce op);
}
}
