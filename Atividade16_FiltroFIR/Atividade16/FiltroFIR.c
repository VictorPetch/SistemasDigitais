#include <avr/io.h>
#define F_CPU 160000000
#include <util/delay.h>  //_delay_ms(iDelay);          // Call Delay function
#include <math.h>
#define len 7 // Number of taps
#include "FiltroFIR.h"
int main(void){

	unsigned int adcOut;
	
	DDRD = 0xFF;                  // Set PORTD as Output
	DDRB = 0xFF;

	// Set ADCSRA Register in ATMega168
	ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1);
	// Set ADMUX Register in ATMega168
	ADMUX = (1<<REFS0) | (1<<ADLAR);
	
	

	uint8_t buff[len];
	
	uint8_t idx = 0;

	while(1) {                     // Loop Forever
		// Start conversion by setting ADSC in ADCSRA Register
		ADCSRA |= (1<<ADSC);
		// wait until conversion complete ADSC=0 -> Complete
		while (ADCSRA & (1<<ADSC));
		//adcOut = (ADCW>>3);
		buff[idx] = ADCH;
		if(idx < len-1){
			idx++;
		}
		else 
		int y;
		double coef[] = {0.8186556917688659,-2.402372519416408,4.7262697696633476,-5.493053203929631,
		4.7262697696633476,-2.402372519416408,0.8186556917688659};
		
		for(uint8_t k =0; k < len; k++){
			for(uint8_t i =0; i<len;i++){
				if(k-i>=0) y += coef[i]*buff[k-i];
			}
		PORTD = y << 2;
		PORTB = y >> 6;
		} 
		for(uint8_t i = 0;i<len;i++){
			adcOut = y[i];
			PORTD = (adcOut & 0b0000000000111111)<<2; // SHIFT RIGHT Two bits to start from port 2
			PORTB = (adcOut & 0b0000000011000000)>>6;
				
			//ADCSRA |= (1<<ADSC);
			// wait until conversion complete ADSC=0 -> Complete
			//while (ADCSRA & (1<<ADSC));
		}
		if(idx == len){
			//tirar o ultimo termo, empurrar geral pra frente
			//e zerar o primeiro
		}
		
	}
	return 0;                      // Standard Return Code
}
// EOF: ADC.c

