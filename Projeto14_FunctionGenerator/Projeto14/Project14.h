/*
 * Project14.h
 *
 * Created: 21/05/2019 10:45:12
 *  Author: Victor
 */ 


#ifndef PROJECT14_H_
#define PROJECT14_H_
#include <avr/io.h>
#define F_CPU 16000000
#define PI 3.14259265
#define freq = 30
#include <util/delay.h>
void triangular(){
	for(int n =0; n < 255; n++){
		PORTD = n << 2;
		PORTB = n >> 6;
		_delay_ms(0.1);
	}
	for(int n =255; n >=0; n--){
		PORTD = n << 2;
		PORTB = n >> 6;
		_delay_ms(0.1);
		
	}	
}
void squared(){
	PORTD = 0xFF;
	PORTB = 0xFF;
	_delay_ms(100);
	PORTD ^= 0xFF;
	PORTB ^= 0xFF;
	_delay_ms(100);	
	
}
void seno(){
	double n=0;
	while(n<255){
		int temp = sin(n)*127+127;
		PORTD = temp << 2;
		PORTB = temp >> 6;	
		n+=0.1;	
	}

	
	
}	
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

#endif /* PROJECT14_H_ */
