#ifndef __VARIABLE_CHANNEL_H__
#define __VARIABLE_CHANNEL_H__

#include "AD533X.h"
#include "ADC128D818.h"

enum current_mode_t {
  BREAKER = 0,
  CONSTANT = 1
};

class VariableChannel {
public:
  VariableChannel(AD533X* dac,
                  ADC128D818* adc,
                  uint8_t enableSwitchPin,
                  uint8_t greenLedPin,
                  uint8_t redLedPin,
                  uint8_t voltageCoef,
                  uint8_t currentCoef);

  void begin();

  // Target in mV
  void setTargetVoltage(uint16_t target_mv);
  uint16_t getTargetVoltage();

  // Target in mA
  void setCurrentLimit(uint16_t limit_ma);
  uint16_t getCurrentLimit();

  void setCurrentMode(current_mode_t mode);
  current_mode_t getCurrentMode();

  uint16_t getActualVoltage();

  uint16_t getActualCurrent();

  int8_t getAmbientTemp();

  int8_t getPassTemp();

  bool isOn();

  void tick();

private:
  AD533X *dac;
  ADC128D818 *adc;

  // constructor parameters
  uint8_t enable_sw;
  uint8_t green_led;
  uint8_t red_led;
  uint8_t voltage_coef;
  uint8_t current_coef;

  // latest settings
  uint16_t target_mv;
  uint16_t current_limit_ma;
  current_mode_t current_mode;
  bool channel_enabled;

  // latest measurements
  uint16_t last_mv;
  uint16_t last_current_ma;
  uint16_t last_ambient_degc;
  uint16_t last_pass_degc;
};

#endif