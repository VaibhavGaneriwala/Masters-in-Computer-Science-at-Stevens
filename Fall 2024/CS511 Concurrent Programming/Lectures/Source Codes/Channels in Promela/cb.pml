
/*
    Verifying correctness of the cyclic barrier solution
    25 Nov 2024
*/

#include "bw_sem.h"
#define N 2
#define B 2

byte mutexE = 1;
byte mutexL = 1;
byte barrier = 0;
byte barrier2 = 0;

int enter=0;
int leaving=0;

byte c[N];

proctype P() {
  int i;
  for (i:1..10) {
    acquire(mutexE);
    c[_pid-1]++;
    enter++;
    if
      :: enter==B ->
	 releaseN(barrier,B);
	 enter=0
      :: else -> skip
    fi;
    release(mutexE);
    acquire(barrier);

    atomic {
      int j;
      for (j:1.. N) {
	assert (c[_pid-1]==c[j-1])
      }
    }
    acquire(mutexL);
    leaving++;
    if
      :: leaving==B ->
	 releaseN(barrier2,B);
	 leaving=0
      :: else -> skip
    fi;
    release(mutexL);
    acquire(barrier2)
  }
}

init {
  int i;
  for (i:1.. N) {
    c[i-1]=0
  };
  atomic {
    for (i:1.. N) {
      run P()
    }
  } 
}
