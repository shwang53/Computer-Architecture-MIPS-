/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here

		unsigned a = input & 0x55555555; // 0101 * 8
		unsigned b = input & 0xAAAAAAAA; // 1010 * 8
		b >>= 1; //shift by 1
		input = a+b; //return input

		a = input & 0x33333333; //0011 * 8
		b = input & 0xCCCCCCCC; //1100 * 8
		b >>= 2; //shift by 2
		input = a+b;

		a = input & 0x0F0F0F0F; // 0000 1111 * 4
		b = input & 0xF0F0F0F0; // 1111 0000 * 4
		b >>= 4; //shift by 4
		input = a+b;

		a = input & 0x00FF00FF; // 00000000 11111111 *2
		b = input & 0xFF00FF00; // 11111111 00000000 *2
		b >>= 8; //shift by 8
		input = a+b;

		a = input & 0x0000FFFF; // 0*16 1*16
		b = input & 0xFFFF0000; // 1*16 0*16
		b >>= 16;
		input = a+b;


		return input;
	}
