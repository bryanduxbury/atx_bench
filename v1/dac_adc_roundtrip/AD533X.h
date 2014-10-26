#ifndef __AD533X_H__
#define __AD533X_H__

#include "Arduino.h"

class AD533X {
public:
  AD533X(int address, int resolutionBits);

  void init();

  void setOutput(uint8_t channel, uint16_t value);
  
  // void setLatchMode(bool )
  
private:
  uint8_t addr;

  uint8_t res_bits;
};

#endif