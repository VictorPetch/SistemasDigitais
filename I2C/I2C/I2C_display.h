/*
 * I2C.h
 *
 * Created: 13/06/2019 10:51:23
 *  Author: Victor
 */ 


#ifndef I2C_LUIB
#define I2C_LUIB
#include <avr/io.h>
#define PI 3.14259265
#define START 0x08
#define MT_SLA_ACK 0x18
#define MT_DATA_ACK 0x28

#define SR_SLA_ACK 0x60
#define SR_DATA_ACK 0x80
#define SR_STOP 0xA0

#include <util/delay.h>

void ERROR() { PORTB ^= 1; }
void ERROR_yay() {
	 while(1){
	 PORTD ^= 1<<2;
	 _delay_ms(200);
	 }
}
void Master_transmitter(uint8_t data,uint8_t addr) {
	DDRB = 0xFF;
	TWSR = (0<<TWPS1)|(0 << TWPS0); // Bit rate Pre scaler
	TWBR = 0xFF; //Bit rate	pre scaler
	
	while (1) {
		ERROR();
		TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN); // start condition
		while(!(TWCR & 1<<TWINT)); // While this step isn't over
		
		//_delay_ms(1);
		if ((TWSR & 0xF8) == 0x08){ //Start is sucessful
			TWDR = addr;//0b00000010; // Address
			TWCR = 0b10000100; // Send the addr
			while(!(TWCR & 1<<TWINT)); // While this step isn't over
			
			//_delay_ms(1);
			if((TWSR & 0xF8) == 0x18){ // Address was sent
				TWDR = data; //0b00101000; // Data
				TWCR = 0b10000100; // Send data
				
				while(!(TWCR & 1<<TWINT)); //While this step isn't over
				//_delay_ms(1);
				
			}
			TWCR = 0b10010100; // End
			ERROR();
			_delay_ms(20);
			ERROR();
			data++;
		}
	}
}
void Slave_receiver(uint8_t addr){
	DDRD = 0xFF;
	PORTD = 0x00;
	TWAR = addr; // Slave addr
	TWCR = 0b11000100; // Start slave
	if((TWSR & 0xF8) == 0x60){ // Start received
		while(1){
			TWCR = 0b11000100; // Wait for data
			while(!(TWCR & 1<<TWINT)); // While this step isn't over
			if((TWSR & 0xF8) == 0x80){
				uint8_t data = TWDR;
				PORTD = data;
			}
			if((TWSR & 0xF8) == 0xA0){
				_delay_ms(10);
				break;
			}
		}		
	}
}
void Button_setup(){
	DDRD &= ~(1 << DDD2)& ~(1 << DDD3);
	PORTD |= (1 << PORTD2)|(1 << PORTD3);
	
	DDRB &= ~(1 << DDB2) & ~(1 << DDB1)& ~(1 << DDB0); 
	PORTB |= (1 << PORTB2)|(1 << PORTB1)|(1 << PORTB0);
	
}
#endif

