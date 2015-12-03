#include <thrust/device_vector.h>
#include "postinglist.hpp"
#include "postinglist.cuh"

using namespace std;
using namespace thrust;

namespace postinglist {

void PostingList(const vector<char>& input_cpu){
  device_vector<char> input = input_cpu;

  uint32_t wordNum = CountWord(input);
  cout << "wordNum=" << wordNum << endl;
  device_vector<bool> isWords(wordNum*2);
  device_vector<word_t> words(wordNum*2);
  vectorToWords(input, isWords, words);
}

} // postinglist

