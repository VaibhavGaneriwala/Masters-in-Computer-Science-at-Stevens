/*
   Channels in Promela
   Example: Successor server
Variation where client sends local channel to receive response.
   25 Nov 2024
*/
#define BUFFER_SIZE 10
mtype = { req, reply };  /* enum type */

chan ch = [BUFFER_SIZE] of { mtype, int, int };

proctype Server() {
  int n;
  chan rch;
  do
    :: ch?req(rch,n) ->
       rch!reply(n+1)
  od
}

proctype Client(int m) {
  int r;
  chan local_ch = [1] of { mtype, int };
  ch!req(local_ch,m);
  local_ch?reply(r);
  printf("%d sent %d and got %d\n",_pid,m,r)
}

init {
  int i;
  int n;
  atomic {
    run Server();
    for (i:1..7) {
      select(n:1..20);
      run Client(n)
    }
  }
}

