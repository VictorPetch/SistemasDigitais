/*
 * Atividade15_ModuladorAM.c
 *
 * Created: 30/05/2019 14:25:08
 * Author : Victor
 */ 

#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
#include "AmModulator.h"
#include <math.h>
int main(void)
{
	ADC_init();
	DDRD = 0xff;
	DDRB = (1 << PORTB0) | (1 << PORTB1);
	double n=0;
    while (1) 
    {
		uint8_t AdcOut = ADC_Conversion(0);
		//PORTD = (AdcOut << 2);
		//PORTB = (AdcOut >> 6);
		int temp = cos(n)*AdcOut+127;
		PORTD = temp << 2;
		PORTB = temp >> 6;
		n+=0.05;
		
    }
}

