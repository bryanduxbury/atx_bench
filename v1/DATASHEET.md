atx_bench Datasheet
==============

Features
=========
- 2 independently controlled adjustable output channels
- High-current fixed output of 3V3, 5V, and 12V
- LCD and control panel for configuring the supply and channels
- USB-serial connector for data logging and programmable control

Adjustable output channels
======
atx_bench offers two adjustable output channels. Both channels are identical and independent.

Output voltage can be varied between 0V and 12V in 1mV increments. The output voltage is produced via generating a precision reference voltage, which is amplified by the output stage pass transistors.

Output current limit can be varied between 0A and 5A in 1mA increments. Current is sensed via a high-side shunt resistor. When an over-current condition develops, the controller disconnects the pass transistor and breaks the circuit. This error state latches until the user clears it via the controls.

In addition to the Vout and Vgnd terminals, each channel also breaks out the Sense terminal. This terminal output a buffered 0-5V signal that is proportional to channel current at the rate of 1V = 1A. You can connect this output to an oscilloscope to see the realtime current waveform. 

High-current fixed output of 3V3, 5V, and 12V
============
These terminals break out the ATX PSU's existing supply channels. Each channel has a resettable polyfuse connected in series to limit current.