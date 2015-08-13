#include "Arduino.h"
#include <Wire.h>
#include "AD533X.h"

#define LDAC 4
#define CLR  5
#define PD0  6
#define PD1  7

AD533X::AD533X(int address, int resolution_bits) {
  this->addr = address;
  this->res_bits = resolution_bits;
}

void AD533X::setOutput(uint8_t channel, uint16_t value) {
  Wire.beginTransmission(addr);

  // Serial.print("Output ");
  // Serial.print(channel);
  // Serial.print(" set to ");
  // Serial.print(value);
  // Serial.print(", Sending message: ");
  // Serial.print((1 << channel));
  // Serial.print(" " );
  // Serial.print((1 << CLR) | ((value >> (res_bits - 4)) & 0x0F));
  // Serial.print(" " );
  // Serial.print((value << (12 - res_bits)) & 0xFF);
  //
  // Serial.println();

  // pointer byte
  Wire.write((1 << channel));
  // data MSB
  Wire.write((1 << CLR) | ((value >> (res_bits - 4)) & 0x0F));
  // data LSB;
  Wire.write((value << (12 - res_bits)) & 0xFF);

  Wire.endTransmission();
}