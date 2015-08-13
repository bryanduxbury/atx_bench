#include "Wire.h"
#include "ADC128D818.h"
#include "AD533X.h"
#include "VariableChannel.h"
#include "./LiquidCrystal.h"

// Channel 1
AD533X ch1_dac(0xC, 12);
ADC128D818 ch1_adc(0x1D);
// TODO: use actual gain settings from board
VariableChannel channel1(&ch1_dac, &ch1_adc, 3, 4, 5, 5, 8);

// Channel 2
// TODO: assign actual pins
// TODO: use actual gain settings from board
AD533X ch2_dac(0xD, 12);
ADC128D818 ch2_adc(0x1F);
VariableChannel channel2(&ch2_dac, &ch2_adc, 6, 7, 8, 5, 8);

LiquidCrystal lcd(0);

void setup() {
  Wire.begin();
  Serial.begin(115200);

  channel1.begin();
  // channel2.begin();

  lcd.begin(20, 4);
  Serial.println("initialized!");
  lcd.setBacklight(HIGH);
}

void printChannelDisplay(VariableChannel& ch, int num, int colOffset) {
  lcd.setCursor(colOffset, 0);
  lcd.print("Channel ");
  lcd.print(num);
  lcd.print(ch.isOn() ? "O" : "-");
  lcd.setCursor(0, 1);
  lcd.print(ch.getActualVoltage());
  lcd.print(" mV");
  lcd.setCursor(0, 2);
  lcd.print(ch.getActualCurrent());
  lcd.print(" mA");
}

void loop() {
  printChannelDisplay(channel1, 1, 0);
  printChannelDisplay(channel2, 2, 10);

  channel1.tick();
  channel2.tick();

  delay(1);
}