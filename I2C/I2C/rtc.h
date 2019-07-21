#ifndef RTC_LUIZ
#define RTC_LUIZ

#define DS3231_ADDRESS 0x68
#define DS3231_CONTROL 0x0E
#define DS3231_STATUSREG 0x0F

#include <util/delay.h>

uint8_t beginTransmission();
uint8_t address(uint8_t addr, uint8_t mode);
void endTransmission();
uint8_t write(uint8_t data);

uint8_t requestFrom(uint8_t addr);

static uint8_t bcd2bin (uint8_t val) {
	return val - 6 * (val >> 4);
}
static uint8_t bin2bcd (uint8_t val) {
	return val + 6 * (val / 10);
}


void rtcBegin() {
	//Serial.begin(2000000);
	//Wire.begin();
	TWSR = (0 << TWPS1) | (0 << TWPS0);
	TWBR = 0xFF;
}

void rtcNow() {
	uint8_t status = 0;

	do {
		status = beginTransmission();  // SEND START BIT
	} while (status == 0);
	//Serial.println("START BIT SENT");

	do {

		status = address(DS3231_ADDRESS, 0); // ENDEREÇA O SLAVE

	} while (status == 0);
	//Serial.println("ENDEREÇO SLAVE ACK");


	do {
		//Serial.println("DATA SENDING\t");

		status = write(0);  // ENDEREÇA O SLAVE
	} while (status == 0);
	//Serial.println("DATA SENT ACK");


	endTransmission();
	//requestFrom(DS3231_ADDRESS);
}

uint8_t beginTransmission() {
	TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	while (!(TWCR & 1 << TWINT))
	;
	//_delay_ms(1);
	if ((TWSR & 0xF8) == 0x08) {
		// SLA+W has been transmitted;
		// ACK has been received
		return 1;
	}
	return 0;
}

uint8_t address(uint8_t addr, uint8_t mode) {
	uint8_t temp = addr << 1 | mode; // Address
	TWDR = temp;

	TWCR = 0b10000100;

	while (!(TWCR & 1 << TWINT)) {
		;

	}

	//Serial.println((TWSR & 0xF8), BIN);
	if ((TWSR & 0xF8) == 0x18) {
		return 1;
		} else if ((TWSR & 0xF8) == 0x40) {
		return 2;
	}
	return 0;
}

void endTransmission() {
	TWCR = 0b10010100;
	_delay_ms(2);
	//Serial.println("STOP");
}

uint8_t write(uint8_t data) {

	TWDR = data;  // Data
	TWCR = 0b10000100;
	while (!(TWCR & 1 << TWINT))
	;
	//Serial.println((TWSR & 0xF8), HEX);
	if ((TWSR & 0xF8) == 0x28) {
		return 1;
	}
	return 0;
}


uint8_t requestFrom(uint8_t addr) {
	uint8_t status = 0;
	uint8_t vec[7];
	do {
		//Serial.println("START BIT");

		status = beginTransmission();  // SEND START BIT
	} while (status == 0);
	do {

		//Serial.println("DEREÇO SLAVE READ");
		status = address(DS3231_ADDRESS, 1); // ENDEREÇA O SLAVE

	} while (status != 2);
	//Serial.println("READ ACK");
	//Serial.println("READ DATA\t");
	uint8_t temp;
	for (uint8_t i = 0; i < 7; i++) {
		do {

			TWCR = 0b11000100;
			while (!(TWCR & 1 << TWINT))
			;
			status = (TWSR & 0xF8);
			//Serial.println((TWSR & 0xF8), HEX);
			uint8_t data = TWDR;
			if (i == 0 ) {
				temp = bcd2bin(data & 0x7F);
				//Serial.print(bcd2bin(data & 0x7F));
			}
			else {
				temp = bcd2bin(data);
				//Serial.print(bcd2bin(data));
			}
			vec[i] = temp;
			//Serial.print('\t');

		} while (status != 0x50);
		
	}
	ss = vec[0];
	mm = vec[1];
	hh = vec[2];
	d = vec[4];
	m = vec[5];
	y = vec[6];
}


#endif