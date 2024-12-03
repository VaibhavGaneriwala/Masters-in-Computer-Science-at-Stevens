#include "bw_sem.h"
#define ND 5
#define NC 5

byte mutexC = 1;
byte mutexD = 1;
byte resource = 1;
int c=0;
int d=0;

/* ghost variables (for assertions) */
int cc=0;  /* cat counter */
int dg=0;  /* dog counter */

proctype Cat() {
  acquire(mutexC);
  c++;
  if
    :: c==1 -> acquire(resource)
    :: else -> skip
  fi;
  cc++;
  release(mutexC);
  /* feed */
  assert (dc==0);
  
  acquire(mutexC);
  c--;
  if
    :: c==0 -> release(resource)
    :: else -> skip
  fi;
  release(mutexC)
  
}

proctype Dog() {
  acquire(mutexD);
  d++;
  if
    :: d==1 -> acquire(resource)
    :: else -> skip
  fi;
  dc++;
  release(mutexD);
  /* feed */
  assert (cc==0);
  
  acquire(mutexD);
  d--;
  if
    :: d==0 -> release(resource)
    :: else -> skip
  fi;
  release(mutexD)
}

init {
  int i;
  atomic {
    for (i: 1 .. NC) {
      run Cat();
    };
    for (i: 1 .. ND) {
      run Dog();
    }
  }
}
