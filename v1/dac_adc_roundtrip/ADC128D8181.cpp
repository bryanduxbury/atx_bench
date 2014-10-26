#include "Wire.h"
#include "ADC128D818.h"

#define CONFIG_REG    0x00
#define CONV_RATE_REG 0x07
#define CHANNEL_DISABLE_REG 0x08
#define ADV_CONFIG_REG 0x0B
#define BUSY_STATUS_REG 0x0C

#define READ_REG_BASE 0x20
#define LIMIT_REG_BASE 0x2A
#define INTERRUPT_MASK_REG 0x03

#define TEMP_REGISTER 0x27

#define START_BIT 0
#define INIT_BIT 7

#define EXT_REF_ENABLE 0
#define MODE_SELECT_1 1
#define MODE_SELECT_2 2

#define BUSY_BIT 0
#define NOT_READY_BIT 1

ADC128D818::ADC128D818(uint8_t address) {
  this->addr = address;

  // enable all channels disabled by default
  disabled_mask = 0;

  ref_v = 2.56f;
  ref_mode = INTERNAL_REF;
  op_mode = SINGLE_ENDED_WITH_TEMP;
  conv_mode = CONTINUOUS;
}

void ADC128D818::setReference(double ref_voltage) {
  ref_v = ref_voltage;
}

void ADC128D818::setReferenceMode(reference_mode_t mode) {
  ref_mode = mode;
}

void ADC128D818::setOperationMode(operation_mode_t mode) {
  op_mode = mode;
}

void ADC128D818::setConversionMode(conv_mode_t mode) {
  conv_mode = mode;
}

void ADC128D818::setDisabledMask(uint8_t disabled_mask) {
  this->disabled_mask = disabled_mask;
}

void ADC128D818::begin() {
  // dumpRegisters();
  
  // wipe out current config by triggering power on reset
  setRegister(CONFIG_REG, 1 << 7);

  // Serial.println("after POR");
  // dumpRegisters();
  
  // read busy reg until it returns 0
  setRegisterAddress(BUSY_STATUS_REG);
  while (1) {
    Serial.println("waiting for ready bit unset");
    if ((readCurrentRegister8() & (1 << NOT_READY_BIT)) == 0) {
      break;
    }
    delay(35);
  }
  
  // Serial.println("made it out");

  // program advanced config reg
  setRegister(ADV_CONFIG_REG, ref_mode | (op_mode << 1));

  // program conversion rate reg
  setRegister(CONV_RATE_REG, conv_mode);

  // program enabled channels
  setRegister(CHANNEL_DISABLE_REG, disabled_mask);

  // program interrupt mask
  // turn 'em all off for now
  setRegister(INTERRUPT_MASK_REG, 0xFF);

  // program limit regs
  for (int i = 0; i < 7; i++) {
    setRegister(LIMIT_REG_BASE + 2 * i, 4096);
    setRegister(LIMIT_REG_BASE + 2 * i + 1, 0);
  }

  // set start bit in configuration (interrupts disabled)
  setRegister(CONFIG_REG, 1);

  // Serial.println("after:");
  // dumpRegisters();
}

uint16_t ADC128D818::read(uint8_t channel) {
  // dumpRegisters();

  setRegisterAddress(READ_REG_BASE + channel);
  Wire.requestFrom(addr, (uint8_t)2);
  while (!Wire.available()) {
    delay(1);
  }

  uint8_t high_byte = Wire.read();
  uint8_t low_byte = Wire.read();

  // Serial.print("h: ");
  // Serial.print(high_byte);
  // Serial.print(",");
  // Serial.print(low_byte);
  // Serial.print(":");
  
  uint16_t result = 0;
  result = ((uint16_t)high_byte << 8) | (uint16_t)low_byte;
  result >>=4;
  result &= 0x0fff;
  
  // result |= (((uint16_t)high_byte) & 0xff);
  // result <<= 4;
  // result |= (((uint16_t)low_byte) & 0x0f);
  // result &= 0xfff;
  
  // result |= (((uint16_t)high_byte) & 0xff);
  // result <<= 8;
  // result |= (((uint16_t)low_byte) & 0xff);
  // // result &= 0xfff;
  // result >>= 4;
  
  // uint16_t result = (((((uint16_t)high_byte) << 8) | ((uint16_t)low_byte)) >> 4) & 0x0FFF;
  return result;
}

double ADC128D818::readConverted(uint8_t channel) {
  return (double)read(channel) / 4096.0 * ref_v;
}

double ADC128D818::readTemperatureConverted() {
  setRegisterAddress(READ_REG_BASE + 7);
  Wire.requestFrom(addr, (uint8_t)2);
  while (!Wire.available()) {
    delay(1);
  }
  uint8_t high_byte = Wire.read();
  uint8_t low_byte = Wire.read();


  // Serial.print("raw temp bits: ");
  // Serial.println((high_byte << 8) | low_byte );
  uint16_t raw = ((high_byte << 8) | low_byte) >> 7;
  raw &= 0x1ff;
  if ((raw & 0x100) == 0) {
    return (double)raw / 2;
  } else {
    return -(double)(512 - raw) / 2;
  }
}


//
// private methods
//

void ADC128D818::setRegisterAddress(uint8_t reg_addr) {
  Wire.beginTransmission(addr);
  Wire.write(reg_addr);
  Wire.endTransmission();
}

void ADC128D818::setRegister(uint8_t reg_addr, uint8_t value) {
  Wire.beginTransmission(addr);
  Wire.write(reg_addr);
  Wire.write(value);
  Wire.endTransmission();
}

uint8_t ADC128D818::readCurrentRegister8() {
  Wire.requestFrom(addr, (uint8_t)1);
  while (!Wire.available()) {
    delay(1);
  }
  return Wire.read();
}

const char nyb2h[] = {'0', '1', '2', '3', 
                      '4', '5', '6', '7', 
                      '8', '9', 'A', 'B', 
                      'C', 'D', 'E', 'F'};

char* i2h(uint8_t i) {
  char* result = "00";
  result[1] = nyb2h[i & 0x0f];
  result[0] = nyb2h[(i >> 4) & 0x0f];
  return result;
}

void ADC128D818::dumpRegisters() {
  for (int i = 0; i <= 0x0C; i++) {
    setRegisterAddress(i);
    Wire.requestFrom(addr, (uint8_t)1);
    uint8_t value = Wire.read();
    Serial.print("0x");
    Serial.print(i2h(i));
    Serial.print(": 0x");
    Serial.println(i2h(value));
  }
}
