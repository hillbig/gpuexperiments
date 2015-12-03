#include <iostream>
#include <vector>
#include <fstream>
#include "postinglist.hpp"

using namespace std;
using namespace postinglist;

int main(int argc, char* argv[]){
  if (argc != 2){
	cout << argv[0] << " file" << endl;
	return -1;
  }

  ifstream ifs(argv[1]);
  if (!ifs){
	cerr << "cannot open " << argv[1];
	return -1;
  }
  ifs.seekg(0, ios::end);
  size_t size = ifs.tellg();
  ifs.seekg(0);
  vector<char> input(size);
  cout << "read start" << endl;
  ifs.read(&input[0], size);
  if (!ifs){
	cerr << "read error" << endl;
	return -1;
  }
  cout << "read done" << endl;
  {
	PostingList(input);
  }
  cout << "posting list done"<< endl;
}

  
