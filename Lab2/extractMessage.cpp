/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here
  // bitset<8> test = message_in[0];
  // cout << "Wow : "  << test <<endl;

  //spread 8bit of binary num (of decimal num that stored in message_in[])
  bitset<8> bit[length];
  //declare temp[i] that will store the right direction of binary combination for decoing
  bitset<8> temp[length];

  // store message_in charactor as a 8bit of bitset.
  for(int a=0; a<length; a++){
    bit[a] = message_in[a];
  }

  //store manipulated binary num in temp to read encoded num.
  for(int factor =0; factor<length; factor+= 8){
    for(int i=0; i<8; i++){
      for(int j= 0; j<8; j++){
            temp[i+factor][j] = bit[j+factor][i];
      }
    }
  }
  // cout << "1st decoded : temp[0]" <<endl;
  // cout << temp[0]<<endl;
  // cout << temp[0].to_ulong()<<endl;

  //store the decoded num in message_out[]
  for(int i =0; i<length; i++){
    message_out[i] = temp[i].to_ulong();
  }
	return message_out;
}
