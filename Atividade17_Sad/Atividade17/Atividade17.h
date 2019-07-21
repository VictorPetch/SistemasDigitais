/*
 * Project14.h
 *
 * Created: 21/05/2019 10:45:12
 *  Author: Victor
 */ 


#ifndef ATIVIDADE17_H_
#define ATIVIDADE17_H_
#include <avr/io.h>
#define F_CPU 16000000
#define PI 3.14259265
#include <util/delay.h>

int ADC_Conversion(int A_i){
	int adcOut;
	if (A_i == 1) ADMUX |= (1<<MUX0);
	else ADMUX &= ~(1<<MUX0);
		
	// Start conversion by setting ADSC in ADCSRA Register
	ADCSRA |= (1<<ADSC);
	// wait until conversion complete ADSC=0 -> Complete
	while (ADCSRA & (1<<ADSC));
	adcOut = ADCH;
	//adcOut = adcOut<< 2;
	//adcOut |= ADCL;
	return adcOut;
	
}

void ADC_init(){
	  // Set ADCSRA Register in ATMega168
	  ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	  // Set ADMUX Register in ATMega168
	  ADMUX = (1<<REFS0) | (1<<ADLAR);	
	
	
	
}

#endif /* ATIVIDADE17_H_ */
