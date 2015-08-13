#include "VariableChannel.h"

// DAC channels
#define VCONTROL_DAC 0
#define ICONTROL_DAC 1

// ADC channels
#define VFEEDBACK 0
#define ISENSE 1
#define TEMP_1 2
#define TEMP_2 3
#define VCONTROL_ADC 4
#define ICONTROL_ADC 5

#define LM35_TEMP_CONVERT(MV) ((MV) / 4095 * 2048 / 10)

VariableChannel::VariableChannel(AD533X* dac,
                                  ADC128D818* adc,
                                  uint8_t enableSwitchPin,
                                  uint8_t greenLedPin,
                                  uint8_t redLedPin,
                                  uint8_t voltageCoef,
                                  uint8_t currentCoef) {
  this->dac = dac;
  this->adc = adc;
  this->enable_sw = enableSwitchPin;
  this->green_led = greenLedPin;
  this->red_led = redLedPin;
  this->voltage_coef = voltageCoef;
  this->current_coef = currentCoef;
}

void VariableChannel::begin() {
  // set up the ADC
  adc->setReference(2048);
  adc->setReferenceMode(EXTERNAL_REF);
  adc->setOperationMode(SINGLE_ENDED_WITH_TEMP);
  adc->setConversionMode(CONTINUOUS);
  // all the inputs are in use except IN6
  adc->setDisabledMask(1 << 6);
  adc->begin();

  pinMode(green_led, OUTPUT);
  digitalWrite(green_led, HIGH);
  pinMode(red_led, OUTPUT);
  digitalWrite(red_led, HIGH);

  pinMode(enable_sw, INPUT);
  digitalWrite(enable_sw, HIGH);
}

void VariableChannel::setTargetVoltage(uint16_t target_mv) {
  this->target_mv = target_mv;
}

uint16_t VariableChannel::getTargetVoltage() {
  return target_mv;
}

void VariableChannel::setCurrentLimit(uint16_t limit_ma) {
  this->current_limit_ma = limit_ma;
}

uint16_t VariableChannel::getCurrentLimit() {
  return current_limit_ma;
}

void VariableChannel::setCurrentMode(current_mode_t mode) {
  this->current_mode = mode;
}

current_mode_t VariableChannel::getCurrentMode() {
  return current_mode;
}

uint16_t VariableChannel::getActualVoltage() {
  return last_mv;
}

uint16_t VariableChannel::getActualCurrent() {
  return last_current_ma;
}

int8_t VariableChannel::getAmbientTemp() {
  return last_ambient_degc;
}

int8_t VariableChannel::getPassTemp() {
  return last_pass_degc;
}

bool VariableChannel::isOn() {
  return channel_enabled;
}

void VariableChannel::tick() {
  // determine if the channel is supposed to be enabled
  channel_enabled = digitalRead(enable_sw) == HIGH;

  // read all ADC channels and update caches
  last_mv = adc->read(VFEEDBACK) * voltage_coef;
  last_current_ma = adc->read(ISENSE) * current_coef;
  last_ambient_degc = adc->readTemperatureConverted();
  // average of temperatures of each pass element
  last_pass_degc = LM35_TEMP_CONVERT(adc->read(TEMP_1)) 
                   + LM35_TEMP_CONVERT(adc->read(TEMP_2)) / 2;

  if (channel_enabled) {
    // update DAC with target voltage and current levels
    dac->setOutput(VCONTROL_DAC, target_mv / voltage_coef);
    dac->setOutput(ICONTROL_DAC, current_limit_ma / current_coef);
  } else {
    // update DAC targets to 0
    dac->setOutput(VCONTROL_DAC, 0);
    dac->setOutput(ICONTROL_DAC, 0);
  }
}