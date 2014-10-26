#include "Wire.h"
#include "ADC128D818.h"
#include "AD533X.h"

// calibration values
// CH1:
//    1mV: 35
//    1000mV: 2030
// CH2:
//    1mV: ?
//    1000mV: 2006
AD533X dac(0xC, 12);

// calibration values
// in4:
//    4.5mV: 1
//    1000mV: 1988
// in5:
//    4.5mV: 1
//    1000mV: 1986
ADC128D818 adc(0x1D);

void setup() {
  Wire.begin();
  Serial.begin(115200);

  pinMode(13, OUTPUT);

  adc.setReferenceMode(EXTERNAL_REF);
  adc.setReference(2.048);
  // only IN4 and IN7 enabled
  // adc.setDisabledMask(0x6f);
  adc.begin();
}

void loop() {
  // for (uint16_t target = 0; target < 4096; target++) {
  //   dac.setOutput(0, target);
  //   dac.setOutput(1, target);
  //
  //   delay(100);
  //
  //   Serial.print(target);
  //   Serial.print("\t");
  //   Serial.print(adc.read(4));
  //   Serial.print("\t");
  //   Serial.println(adc.read(5));
  // }
  //
  // while(1) {delay(1);}
  
  
  dac.setOutput(0, 42);
  dac.setOutput(1, 15);
  
  while(1) {
    for (int channel = 0; channel < 7; channel ++) {
      Serial.print("\t");
      Serial.print(adc.read(channel));
    }

    Serial.print("\t");
    Serial.println(adc.readTemperatureConverted());
    delay(1000);
  }

  // for (uint16_t i = 0; i < 4096; i++) {
  //   // dac.setOutput(0, i);
  //   // dac.setOutput(1, i);
  //
  //   delay(200);
  //
  //   Serial.print(i);
  //   // for (int sample = 0; sample < 10; sample++) {
  //   //   Serial.print(",");
  //   //   Serial.print(adc.read(4));
  //   //   delay(20);
  //   // }
  //
  //
  //   for (int channel = 0; channel < 7; channel ++) {
  //     Serial.print("\t");
  //     Serial.print(adc.read(channel));
  //   }
  //
  //   Serial.print("\t");
  //   Serial.println(adc.readTemperatureConverted());
  // }
  // Serial.println("All the way around");
}