/*
 * AmModulator.h
 *
 * Created: 30/05/2019 14:29:04
 *  Author: Victor
 */ 


#ifndef AMMODULATOR_H_
#define AMMODULATOR_H_
#define F_CPU 16000000
#define PI 3.14259265
#define freq = 30
#include <util/delay.h>
#include <math.h>
int ADC_Conversion(int A_i){
	unsigned char adcOut;
	if (A_i == 1) ADMUX |= (1<<MUX0);
	else ADMUX &= ~(1<<MUX0);
	
	// Start conversion by setting ADSC in ADCSRA Register
	ADCSRA |= (1<<ADSC);
	// wait until conversion complete ADSC=0 -> Complete
	while (ADCSRA & (1<<ADSC));
	adcOut = ADCH;
	return adcOut;
	
}
void ADC_init(){
	// Set ADCSRA Register in ATMega168
	ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	// Set ADMUX Register in ATMega168
	ADMUX = (1<<REFS0) | (1<<ADLAR);
	
	
	
}



#endif /* AMMODULATOR_H_ */