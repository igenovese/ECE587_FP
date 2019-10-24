#include <stdio.h>
#include <stdint.h>

#define RESULT_SIZE			30

#define HISTORY_REG_SIZE	4		// bits
#define HISTORY_REG_MASK 	0xF
#define TABLE_SIZE 			16		// entries


#define HISTORY_ENTRY_SIZE	2		// bits
#define HISTORY_ENTRY_MASK	0x3

uint8_t two_bit_predictor(uint8_t history);
void build_branch_results(uint8_t * results);
void print_branch_results(uint8_t * results);



int main() {

	int correct = 0;
	int incorrect = 0;
	uint8_t prediction = 0;
	uint8_t history_reg = 0;
	uint8_t ptable [TABLE_SIZE];
	uint8_t input;
	uint8_t results[RESULT_SIZE];

	build_branch_results(results);
	//print_branch_results(results);

	int ii, jj;
	for (ii = 0; ii < TABLE_SIZE; ii++)
		ptable[ii] = 0;

#ifdef BIT1
	printf("1-bit predictor\n");
#else
	printf("2-bit predictor\n");
#endif
	printf("History Register Size: %d\n", HISTORY_REG_SIZE);
	printf("History Entry Size:    %d\n", HISTORY_ENTRY_SIZE);


	for (ii = 0; ii < RESULT_SIZE; ii++){

		if (ii % 5 == 0)
			printf("\n");

		printf("Iteration: %2d ", ii);

		printf(" History Reg: %4d", history_reg);

		// get prediction
#ifdef BIT1
		prediction = ptable[history_reg];
#else
		prediction = two_bit_predictor(ptable[history_reg]);
#endif
		printf("   Pred: %d Res: %d ", prediction, results[ii]);

		// compare prediction and result
		if (prediction != results[ii]) {
			printf("- \n");
			incorrect++;
		}
		else {
			printf("Y \n");
			correct++;
		}

		// update pattern history table
#ifdef BIT1
		ptable[history_reg] = results[ii];
#else
		ptable[history_reg] = ((ptable[history_reg] << 1) | results[ii]) & HISTORY_ENTRY_MASK;
#endif
		// update pattern history register
		history_reg = ((history_reg << 1) | results[ii]) & HISTORY_REG_MASK;

	}

	uint8_t total = correct + incorrect;
	float percent = (float)(correct / total);
	printf(" Correct = %d, Incorrect = %d, %0.2f\n", correct, incorrect, percent);

	return 0;
}



uint8_t two_bit_predictor(uint8_t history) {

	int8_t state = 0;
	uint8_t input;

	printf("   Table Entry: ");

	int ii;
	for (ii = 0; ii < HISTORY_ENTRY_SIZE; ii++) {
		input = history >> (HISTORY_ENTRY_SIZE - 1 - ii) & 0x1;
		printf("%d", input);
		state = (input == 0) ? state - 1 : state + 1;
		if (state  < 0)
			state = 0;
		if (state > 3)
			state = 3;
	}

	if (state >= 2)
		state = 1;
	else
		state = 0;

	return (uint8_t)state;
}


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
