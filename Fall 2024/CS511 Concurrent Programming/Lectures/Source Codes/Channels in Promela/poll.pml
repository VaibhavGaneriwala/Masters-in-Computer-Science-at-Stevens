/* Polling
   25 Nov 2024
*/

#define BUFFER_SIZE 10
mtype = { msg };  /* enum type */

chan ch = [BUFFER_SIZE] of { mtype };

proctype P() {
  mtype m;
  if
    :: atomic { ch?[m] -> ch?m } ->
       printf("Got a message\n")
    :: else ->
       printf("No message\n")
  fi
}

init {
  if
    :: true -> ch!msg
    :: true -> skip
  fi
}

