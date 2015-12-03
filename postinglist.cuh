#pragma once

#include <thrust/device_vector.h>

namespace postinglist {
  typedef uint32_t position_t;
  typedef uint32_t hash_t;
  typedef uint8_t length_t;
  typedef thrust::tuple<hash_t, position_t, length_t> word_t;

  uint32_t CountWord(const thrust::device_vector<char>& input);
  void vectorToWords(const thrust::device_vector<char>& input,
					 thrust::device_vector<bool>& isWords,
					 thrust::device_vector<word_t>& words);
}
