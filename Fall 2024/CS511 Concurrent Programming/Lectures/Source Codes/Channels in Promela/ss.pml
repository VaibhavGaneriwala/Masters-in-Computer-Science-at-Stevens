/*
   Channels in Promela
   Example: Successor server
   25 Nov 2024
*/

#define BUFFER_SIZE 10
mtype = { req, reply };  /* enum type */

chan ch = [BUFFER_SIZE] of { mtype, int, int };

proctype Server() {
  int n;
  int cl_pid;
  do
    :: ch?req(cl_pid,n) ->
       ch!reply(cl_pid,n+1)
  od
}

proctype Client(int m) {
  int r;
  ch!req(_pid,m);
  ch?reply(eval(_pid),r);
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

