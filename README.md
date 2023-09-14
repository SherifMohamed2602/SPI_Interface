# SPI_Interface
SPI Slave with Single Port RAM

Serial Peripheral Interface or SPI is a synchronous serial communication protocol that provides full – duplex communication at very high speeds. Serial Peripheral Interface (SPI) is a master – slave type protocol that provides a simple and low-cost interface between a microcontroller and its peripherals.

Specifications of the design:
(1) Inputs & Outputs
clk >> Clock
rst_n >> Active low synchronous reset
SS_n >> Active low enable signal which activate or deactivate the device
MOSI >> The serial input from Master to Slave
MISO >> The serial output of Slave to Master
(2) The used hardware
Single-Port RAM >> It is the storage element which the master needs to communicate with
SPI-Slave >> It is the element which is the interface between the master and the RAM as it converts the serial input of the master into a parallel input to the RAM and converts the parallel output of the RAM into a serial output to the master. It is designed using a FSM (Finite State Machine).
one shot timers >> It is used to help the slave in converting the parallel input into a serial one and vice versa.

