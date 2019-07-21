

#ifndef DISPLAY_H_
#define DISPLAY_H_

#include <avr/io.h>
#include <stdlib.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include <string.h>


// commands
#define LCD_CLEARDISPLAY 0x01
#define LCD_RETURNHOME 0x02
#define LCD_ENTRYMODESET 0x04
#define LCD_DISPLAYCONTROL 0x08
#define LCD_FUNCTIONSET 0x20

// flags for display entry mode
#define LCD_ENTRYLEFT 0x02
#define LCD_ENTRYSHIFTDECREMENT 0x00

// flags for display on/off control
#define LCD_DISPLAYON 0x04
#define LCD_CURSOROFF 0x00
#define LCD_BLINKOFF 0x00

// flags for function set
#define LCD_4BITMODE 0x00
#define LCD_2LINE 0x08
#define LCD_5x8DOTS 0x00

uint8_t _rs_pin = 12;
uint8_t _rw_pin = 255;
uint8_t _enable_pin = 11;
uint8_t _data_pins[8] = {2, 3, 4, 5, 0, 0, 0, 0};
uint8_t _displayfunction = LCD_4BITMODE | LCD_2LINE | LCD_5x8DOTS;
uint8_t _displaycontrol;
uint8_t _displaymode;


char daysOfTheWeek[7][3] = {"DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SAB"};
uint8_t Cursor_flag = 4;
uint8_t State_flag = 0;

void lcd_number(int num);
void lcd_write(uint8_t value);
void lcd_write_byte(uint8_t value);
void lcd_print(uint8_t value);
void lcd_begin();
void lcd_number(int num){
	int mil, cen, dec, uni;
	if(num>=1000 && num<10000){
		mil = num/1000;
		lcd_print(mil+48);
	}
	else mil = 0;
	if(num>=100){
		cen = (num%1000)/100;
		lcd_print(cen+48);
	}
	else cen = 0;
	if(num>=10){
		dec = (num%100)/10;
		lcd_print(dec+48);
	}
	else dec = 0;
	uni = num%10;
	lcd_print(uni+48);

}
void lcd_write(uint8_t value){
	PORTD = value<<4;

	PORTB &=~(1<<3); // digitalWrite(_enable_pin, LOW);
	_delay_us(1);
	PORTB |= (1<<3); // digitalWrite(_enable_pin, HIGH);
	_delay_us(1);    // enable pulse must be >450ns
	PORTB &=~(1<<3); // digitalWrite(_enable_pin, LOW);
	_delay_us(100);   // commands need > 37us to settle
}
void lcd_write_byte(uint8_t value){
	lcd_write(value>>4);
	lcd_write(value);
}
void lcd_print(uint8_t value){
	PORTB |= (1<<4); // digitalWrite(_rs_pin, HIGH);
	_delay_us(37);
	lcd_write_byte(value);
	PORTB &=~(1<<4); // digitalWrite(_rs_pin, LOW);
	_delay_us(37);
}
void lcd_begin(){
	DDRB = 0b00011010;
	DDRD = 0b11110000;
	
	_delay_us(50000);
	// Now we pull both RS and R/W low to begin commands
	
	PORTB &=~(1<<4); // digitalWrite(_rs_pin, LOW);
	PORTB &=~(1<<3); // digitalWrite(_enable_pin, LOW);
	
	lcd_write_byte(LCD_FUNCTIONSET | _displayfunction);
	_delay_us(4500);  // wait more than 4.1ms
	
	lcd_write_byte(LCD_FUNCTIONSET | _displayfunction);  // second try
	_delay_us(150);
	
	lcd_write_byte(LCD_FUNCTIONSET | _displayfunction);  // third go
	
	lcd_write_byte(LCD_FUNCTIONSET | _displayfunction);  // finally, set # lines, font size, etc.
	
	_displaycontrol = LCD_DISPLAYON | LCD_CURSOROFF | LCD_BLINKOFF;  // turn the display on with no cursor or blinking default
	
	lcd_write_byte(LCD_DISPLAYCONTROL | _displaycontrol);
	
	lcd_write_byte(LCD_CLEARDISPLAY);// clear it off
	_delay_ms(2);  // this command takes a long time!
	
	_displaymode = LCD_ENTRYLEFT | LCD_ENTRYSHIFTDECREMENT;  // Initialize to default text direction (for romance languages)

	lcd_write_byte(LCD_ENTRYMODESET | _displaymode);  // set the entry mode
}
void lcd_teste(char texto[]){
	
	lcd_begin();
	_delay_ms(1000);
	for(int i =0;i < strlen(texto)-1;i++){
		lcd_print(texto[i]);
		_delay_ms(100);
		if(i>15){
			lcd_write_byte(0b00011000);
			_delay_ms(300);
		}
	}
	_delay_ms(1000);
	lcd_write_byte(0b00001111);
}
void Week_print(char Week[], uint8_t Hour, uint8_t Min){
	for(int i =0;i < 3;i++){
		lcd_print(Week[i]);
		_delay_ms(50);
	}
	for(int i =0;i <6 ;i++){
		lcd_write_byte(0b00010100);
		_delay_ms(50);
		
	}	
	if(Hour < 10)lcd_number(0);
	_delay_ms(50);
	lcd_number(Hour);
	_delay_ms(50);
	lcd_print(58);//":"
	if(Min < 10)lcd_number(0);
	lcd_number(Min);
	_delay_ms(50);
	
}
void Home_print(char Home[]){
	for(uint8_t i = 0; i < strlen(Home); i++) {
		lcd_print(Home[i]);
		_delay_ms(50);
	}
}
void Move_left(uint8_t num){
	for(uint8_t i = 0; i < num; i++) lcd_write_byte(0b00010000);
}
void Move_right(uint8_t num){
	for(uint8_t i = 0; i < num; i++) lcd_write_byte(0b00010100);
}
#endif /* DISPLAY_H_ */