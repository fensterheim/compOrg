#include<stdio.h>
#define LITTLE 1
#define BIG 0
/*****************************************************************
returns the endiannes of the computer.
1 - little
0 - big
*****************************************************************/
int is_little_endian() {
	int x = 1;
	if (*(char*)&x == 1) 
		return LITTLE;
	return BIG;
}
/*****************************************************************
returns number composed of LSB of y and rest from x
*****************************************************************/
unsigned long merge_bytes(unsigned long x, unsigned long y) {
	unsigned long yMask = 0xFF, xMask = 0xFFFFFFFFFFFFFF00, newY = y & yMask, newX = x & xMask, result = newY|newX;
	return result;
}
/*****************************************************************
replaces the ith index in x with b starting from LSB at index 0
*****************************************************************/
unsigned long put_byte(unsigned long x, unsigned char b, int i) {
	char *p = (char*)(&x);
	int index = i;	//the index for memory iteration
	//when we are on Big endian the MSB will be in index 0 instead of LSB, so we will iterate from MSB up, hence ith index in x is actually 7-i index in  memory.
	if (!is_little_endian()) { //is big endian
		index = 7 - i;
	}
	p[index] = b;
	return x;
}
