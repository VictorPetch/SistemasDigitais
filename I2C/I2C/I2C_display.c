#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include "I2C_display.h"
#include "Display.h"
	uint8_t ss = 0;
	uint8_t mm = 0;
	uint8_t hh = 8;
	uint8_t d =0 ;
	uint8_t m = 0;
	uint8_t y = 0;
	uint8_t w = 0;
#include "rtc.h"
#include <string.h>

int main(void) {

	lcd_begin();
	rtcBegin();
	Button_setup(); // Seta D2,D3,B0,B1 pra entrada
	char texto[] = "Vai dar certo";
	lcd_write_byte(0b00001111); 
	int Estado = 0;


	lcd_write_byte(1);
	_delay_ms(100);
	while(1){
		
		switch (Estado){
			case 0:
			lcd_write_byte(1);
			_delay_ms(500);
			Home_print(texto);
				
			while(!((PINB & 0b00000010) == 0)){;}
			Estado = 1;
			_delay_ms(100); // Delay pra apertar o botao
			break;
				
			
			case 1:
				lcd_write_byte(1);
				_delay_ms(500);
				Week_print(daysOfTheWeek[0],hh,mm);
				_delay_ms(1000);			
			while(!((PINB & 0b00000001) == 0) & !((PINB & 0b00000010) == 0)){
			}
			
			if( (PINB & 0b00000001) == 0 ) Estado = 2;
			else Estado = 0;	
			_delay_ms(300);
			break;
			
			case 2:
				lcd_write_byte(1);
				_delay_ms(100);
				Week_print(daysOfTheWeek[1],hh,mm);
				Move_left(Cursor_flag);
				_delay_ms(500);
				//lcd_write_byte(0b00010000);
				while( !((PINB & 1<<PINB0) == 0) & !((PINB & 1<<PINB1) == 0) & !((PINB & 1<<PINB2) == 0) ){
				}
				if((PINB & 1<<PINB1) == 0) {
					if(Cursor_flag == 4) hh++;
					else mm++;
					}
					
				else if((PINB & 1<<PINB0) == 0){
					if(Cursor_flag == 4) hh--;
					else mm--;
					} 
				else { //Mandar as info por I2C
					Cursor_flag = 1;
					State_flag ++;
					if(State_flag == 2) Estado = 6;
					} // Esse eh pra selecionar e mover o cursor
				
				_delay_ms(500);
			break;
			
			case 3:
			lcd_write_byte(0b00010000);//shift left
			while(!((PINB & 1<<PINB1) == 0) & !((PINB & 1<<PINB0) == 0) & !((PINB & 1<<PINB2) == 0)){
			}
			if((PINB & 1<<PINB1) == 0){
				Estado = 3;
			}else Estado = 4;
			
			_delay_ms(500);
			break;
			
			case 4:
			 lcd_write_byte(0b00010100); // Shift right
			 while(!((PINB & 0b00000001) == 0) & !((PINB & 0b00000010) == 0)){
			 }
			 if((PINB & 1<<PINB1) == 0){
				 Estado = 3;
			 }else Estado = 4;
			 _delay_ms(500);
			break;
			
			case 5:
			Home_print("Calculando");
			for (int i =0; i< 3; i ++){
				Home_print(".");
				Move_right(1);
			}
			Move_left(1);
			for (int i =0; i< 3; i ++){
				Home_print(" ");
				Move_left(1);
			}
			Move_right(1);
			break;
			
			case 6:
			lcd_write_byte(1);
			_delay_ms(300);
			//Le a hora por I2C
			rtcNow();
			requestFrom(0x68);
			Home_print("Hora exata:");
			if(hh < 10)lcd_number(0);
			_delay_ms(50);
			lcd_number(hh);
			_delay_ms(50);
			lcd_print(58);//":"
			if(mm < 10)lcd_number(0);
			lcd_number(mm);
			_delay_ms(50);	
			while(1){};
			break;
		}
	
		_delay_ms(20);
	}

	
	return 0;
}

//uint8_t data = 6;
	//uint8_t addr = 0b00000010;
	//Master_transmitter(data,addr);
	//Slave_receiver(addr);
	//Serial.begin(250000);
	// 
	//int Estado = 0;
	//char texto[] = "dasasdadssdasad";
	
	//lcd_teste(texto);
	//while(1){;}
	/*while(1){
	
	switch (0){
	case 0:
	
	

	break;

	case 1:
	
	break;

	default:
	Estado = 0;
	Week_print("DEU","ERROR");
	break;
	}
	
	}*/