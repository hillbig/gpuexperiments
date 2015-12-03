# set LD_LIBRARY_PATH
export CC  = gcc
export CXX = g++
export NVCC =nvcc
export CFLAGS = -Wall -O3
export LDFLAGS= -lm -lcudart 
export NVCCFLAGS = -O3 --use_fast_math

# specify tensor path local_sum.cpu
BIN = 
OBJ = postinglist_main.o
CUOBJ = countword.o vectorToWords.o postinglist.o
CUBIN = postinglist
.PHONY: clean all

all: $(BIN) $(OBJ) $(CUOBJ) $(CUBIN)

postinglist: postinglist_main.o countword.o postinglist.o vectorToWords.o
postinglist_main.o: postinglist_main.cpp
postinglist.o: postinglist.cu
countword.o: countword.cu
vectorToWords.o: vectorToWords.cu


$(BIN) :
	$(CXX) $(CFLAGS) -o $@ $(filter %.cpp %.o %.c, $^)  $(LDFLAGS)

$(OBJ) :
	$(CXX) -c $(CFLAGS) -o $@ $(firstword $(filter %.cpp %.c, $^) )

$(CUOBJ) :
	$(NVCC) -c -o $@ $(NVCCFLAGS) -Xcompiler "$(CFLAGS)" $(filter %.cu, $^)

$(CUBIN) :
	$(NVCC) -o $@ $(NVCCFLAGS) -Xcompiler "$(CFLAGS)" -Xlinker "$(LDFLAGS)" $(filter %.cu %.cpp %.o, $^)

clean:
	$(RM) $(OBJ) $(BIN) $(CUBIN) $(CUOBJ) *~
