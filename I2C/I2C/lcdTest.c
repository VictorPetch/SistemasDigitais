#include <avr/io.h>

#ifndef F_CPU
#define F_CPU 16000000
#endif

#include <util/delay.h>
#include "luizCrystal.h"

int main(void) {
  lcdbegin();
  print("HELLO WORLD");
  _delay_ms(100000);
}