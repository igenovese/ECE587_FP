#include <stdio.h>
#include <stdint.h>

#define RESULT_SIZE			30




void build_branch_results(uint8_t * results);
void print_branch_results(uint8_t * results);



int main() {

	uint8_t results[RESULT_SIZE];

	build_branch_results(results);
	print_branch_results(results);


	return 0;
}




/*	Build a string of branch results to test the predictor
 *
 */
void build_branch_results(uint8_t * results) {

	int ii = 0;
	int jj = 0;

	uint8_t pattern [5];
	pattern[0] = 1;
	pattern[1] = 1;
	pattern[2] = 1;
	pattern[3] = 0;
	pattern[4] = 1;


	for (ii = 0; ii < RESULT_SIZE; ii++) {
		results[ii] = pattern[jj];
		jj = (jj + 1) % 5;
	}
}

/*	Print the built test result string
 *
 */
void print_branch_results(uint8_t * results) {

	int ii;

	for (ii = 0; ii < RESULT_SIZE; ii++){
		if (ii > 1 && ii % 5 == 0)
			printf(" ");

		if (results[ii] == 0)
			printf("N");
		else
			printf("T");
	}
	printf("\n");
}
