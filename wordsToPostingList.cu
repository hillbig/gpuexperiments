#include <thrust/inner_product.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/partition.h>
#include "postinglist.cuh"

using namespace thrust;

namespace postinglist {

struct IsWord {
  template<typename Tuple>
  __host__ __device__
  bool operator() (const Tuple& x) {
	return thrust::get<0>(x);
  }
};

  void wordsToPostingList(thrust::device_vector<bool>& isWords,
						  thrust::device_vector<word_t>& words,
						  uint32_t wordNum){
	stable_partition
	  (make_zip_iterator
	   (make_tuple
		(isWords.begin(),
		 words.begin())),
	   make_zip_iterator
	   (make_tuple
		(isWords.end(),
		 words.end())),
	   IsWord());

	words.resize(wordNum);
	//	sort(words.begin(), words.end())
  
}

}
