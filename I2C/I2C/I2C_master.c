/*
 * I2C.c
 *
 * Created: 12/06/2019 16:14:42
 * Author : Victor
 */ 

#include <avr/io.h>
#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
#include "I2C.h"

int main(void)
{
	// set all PORTD,and some PORTB pins for output. Also PORTD2 for input
	DDRD = 0xFF;
	DDRB = 0xFF;
	DDRD &= ~(1 << DDD2);    
	//PullUp for DDD2
	PORTD =  (1 << PORTD2);
    while (1) 
    {
		int button = PIND;
		if(button == 0b00000000){
			PORTD |= (1 << PORTD3);
		}
		else PORTD &= ~(1 << PORTD3);
    }
}

