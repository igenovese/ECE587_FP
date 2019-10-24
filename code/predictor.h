/*	Header file for the Branch Predictor
 *
 */

#include <stdint.h>
#include <stdbool.h>



void predictor_setup();

void update_history_table(uint32_t * entry, uint8_t branch_result);

void update_history_register(uint32_t * reg, uint8_t branch_result);

bool two_bit_updown_counter(uint32_t history, uint32_t size);

