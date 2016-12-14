//Daniel Fensterheim 302547880
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define DOS 1
#define MAC 2
#define UNIX 3
#define SWAP 1
#define KEEP 0

char* setNL(int writeType);
int* getTypes(char *argv[], int argc);
int getSwap(char *argv[], int argc);
FILE** getFiles(int argc, char* argv[]);
int setJumpRate(int type);
void copyFileOneToFIleTwo(FILE* input, FILE* output, int fixMSB, char*NL, int inJumpRate, int outJumpRate);
void straightCopy(FILE* input, FILE* output);

int main(int argc, char* argv[])
{
	//int fixMSB = setMSB(argv, argc);
	int swap = getSwap(argv, argc);
	int* types = getTypes(argv, argc);
	int readType = types[0];
	int writeType = types[1];
	if(writeType == -1 && readType == -1){
		FILE **files = getFiles(argc, argv);
		FILE *input = files[0];
		FILE *output = files[1];
		straightCopy(input, output);
		return 0;
	} else if(writeType == -1) {
		return 1;
	}
	int inJumpRate = setJumpRate(readType), outJumpRate = setJumpRate(writeType);
	char* outBuffer;
	char* NL = setNL(writeType);
	FILE **files = getFiles(argc, argv);
	FILE *input = files[0];
	FILE *output = files[1];
	if(NULL == input || NULL == output)
		return 1;
	//copyFileOneToFIleTwo(input, output, fixMSB, NL, inJumpRate, outJumpRate);
	copyFileOneToFIleTwo(input, output, swap, NL, inJumpRate, outJumpRate);
	exit(0);
}
/**********************************
result: sets the newLine appropriately
***********************************/
char* setNL(int writeType) {
	char *NL;
	char *dos = malloc(sizeof(char)*4);
	char *mac = malloc(sizeof(char)*2);
	char *nix = malloc(sizeof(char)*2);
	if (NULL == dos || NULL == mac || NULL == nix) {
		exit(1);
	}
	dos[0] = 0x00;
	dos[1] = '\r';
	dos[2] = 0x00;
	dos[3] = '\n';
	//char dos[2] = {'\r','\n'};
	mac[0] = 0x00;	
	mac[1] = '\r';
	//char mac[1] = {'\r'};
	nix[0] = 0x00;	
	nix[1] = '\n';
	//char nix[1] = {'\n'};
	switch(writeType) {
	case DOS: NL = dos;
		free(nix);
		free(mac);
		break;
	case UNIX: NL = nix;
		free(mac);
		free(dos);
		break;
	case MAC: NL = mac;
		free(nix);
		free(dos);
		break;
	default: NL = NULL;
		free(nix);
		free(dos);
		free(mac);
		break;
	}
	return NL;
}

/**********************************
result: detects the readType and writeType
***********************************/
int* getTypes(char *argv[], int argc) {
	int *types = malloc(sizeof(int)*2);
	types[0] = -1;
	types[1] =  -1;
	int foundCount = 0;
	int i;
	for(i = 1; (i < argc) && (foundCount < 2); i++) {
		if(strcmp(argv[i], "-mac") == 0) {
			types[foundCount] = MAC;
			foundCount++;
		} else if(strcmp(argv[i], "-win") == 0) {
			types[foundCount] = DOS;
			foundCount++;
		} else if(strcmp(argv[i], "-unix") == 0) {
			types[foundCount] = UNIX;
			foundCount++;
		}
	}
	return types;
}


/**********************************
result: gets the swap/keep flag from the command line arguments.
return - SWAP if exists -swap flag, KEEP otherwise
returns
***********************************/
int getSwap(char *argv[], int argc) {
	int i;
	for(i = 1; i < argc; i++) {
			if(strcmp(argv[i], "-swap") == 0) {
				return SWAP;
			}
		}
	return KEEP;
}
/**********************************
result: gets the files from the input arguments
***********************************/
FILE** getFiles(int argc, char* argv[]) {
	FILE *files[2];
	FILE** filesp = files;
	//both modes - made an array so it will be simple to distinguish between the input file and output file
	char* modes[2] = {"rb", "wb"};
	int j = 0;
	int i; 
	for(i = 1; (i < argc) && (j < 2); i++) {
		if(argv[i][0]!= '-') {
			//if evaluated as true - we are reading the file name
			filesp[j] = fopen(argv[i], modes[j]);
			//j++ will go to the next mode -> means that we read the first one and we are now changing the mode to wb so that the next file will be writable
			j++;
		}
	}
	return filesp;
}

/**********************************
result: sets the amount of bytes to write when writing a NL
***********************************/
int setJumpRate(int type) {
	if(type == DOS) return 2;
	return 1;
}
/**********************************
result: copies from one file to the next through a buffer while maintaining the required formats
***********************************/
void copyFileOneToFIleTwo(FILE* input, FILE* output, int swap, char*NL, int inJumpRate, int outJumpRate){
	char* buffer = (char*)malloc(4);
	unsigned char firstChar;
	int isFirst = 1;
	//continue reading as long as there is what to read
	while(fread(buffer, 2, 1, input)) {
		if (isFirst) {
			isFirst = 0;
			firstChar = buffer[0];
		}
		while(firstChar == 0xff && ((buffer[0] == '\n' && buffer[1] == 0x00) || 
			(buffer[0] == '\r' && buffer[1] == 0x00))) {
			//if the incoming NL is a DOS NL hence has 2 bytes
			if(inJumpRate == 2) {
				//read another character just to increment the input pointer aproperly
				if(!fread(buffer,2, 1, input)) {
					return;
				}
			}
			//now that we know we are replacing a NL -> replace it with the relevant one
			buffer[0] = NL[!swap];
			buffer[1] = NL[swap];
			if (outJumpRate == 2) {
				buffer[2] = NL[2 + !swap];
				buffer[3] = NL[2 + swap];
			}
			//writing the new NL to the output file with the relevant MSB
			fwrite(buffer, 2, outJumpRate, output);
			//reading the next byte which could be NL or not
			if(!fread(buffer, 2, 1, input)) {
				return;
			}
		}
		while(firstChar == 0xfe && ((buffer[1] == '\n' && buffer[0] == 0x00) || 
			(buffer[1] == '\r' && buffer[0] == 0x00))) {
			//if the incoming NL is a DOS NL hence has 2 characters
			if(inJumpRate == 2) {
				//read another character just to increment the input pointer aproperly
				if(!fread(buffer,2, 1, input)) {
					return;
				}
			}
			//now that we know we are replacing a NL -> replace it with the relevant one
			buffer[0] = NL[swap];
			buffer[1] = NL[!swap];
			if (outJumpRate == 2) {
				buffer[2] = NL[2 + swap];
				buffer[3] = NL[2 + !swap];
			}
			//writing the new NL to the output file with the relevant MSB
			fwrite(buffer, 2, outJumpRate, output);
			//reading the next byte which could be NL or not
			if(!fread(buffer, 2, 1, input)) {
				return;
			}
		}
		fwrite(buffer + swap, 1, 1, output);
		fwrite(buffer + !swap, 1, 1, output);
	}
}
/**********************************
result: copies input file to output file as is
***********************************/
void straightCopy(FILE* input, FILE* output) {
	char buffer[1];
	while(fread(buffer, 1, 1, input)) {
		fwrite(buffer, 1, 1, output);
	}
}
