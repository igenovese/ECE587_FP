/*	Source file for the branch predictor
 *
 */

#include "predictor.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

//**********************************************************************
//								DEFINES
//**********************************************************************
#define HISTORY_REG_SIZE	4		// number of bits in history register
#define HISTORY_REG_MASK 	0xF		// mask for history register bits

#define HISTORY_ENTRY_SIZE	2		// number of bits in history table entry
#define HISTORY_ENTRY_MASK	0x3		// mask for the table entry bits


//**********************************************************************
//						     PRIVATE MEMBERS
//**********************************************************************
uint32_t history_register;
uint32_t * history_table;


//**********************************************************************
//						       FUNCTIONS
//**********************************************************************


void predictor_setup() {

	uint32_t size;

	// initialize the history register
	history_register = 0;

	// initialize the history table
	size = pow(2, HISTORY_REG_SIZE);
	history_table = (uint32_t*) malloc (sizeof(uint32_t) * size);
}


/*	Updates the pattern history table entry
 *
 */
void update_history_table(uint32_t * entry, uint8_t branch_result) {
	*entry = ((*entry << 1) | branch_result) & HISTORY_ENTRY_MASK;
}

/*	Updates the pattern history register with the branch result
 *
 */
void update_history_register(uint32_t * reg, uint8_t branch_result) {
	*reg = ((*reg << 1) | branch_result) & HISTORY_REG_MASK;
}



/*	Two-Bit Up-Down Saturating Counter
 *
 *	Implements the algorithm for the 2-bit up/down counter.
 *
 *	Inputs:
 *		history: the branch history entry
 *
 *	Outputs:
 *		1 = branch taken
 *		0 = branch not taken
 */
bool two_bit_updown_counter(uint32_t history, uint32_t size) {

	int8_t state = 0;
	uint8_t input;

	int ii;
	for (ii = 0; ii < size; ii++) {
		input = history >> (size - 1 - ii) & 0x1;
		state = (input == 0) ? state - 1 : state + 1;

		if (state  < 0)
			state = 0;
		if (state > 3)
			state = 3;
	}

	if (state >= 2)
		return true;
	return false;
}

