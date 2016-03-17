@color 9E
@echo #######################################################################
@echo                      Firmware Backup Tool
@echo                    for AVR ATMAGE MCU ONLY
@echo Date:2016-03-13
@echo Author:Per Ivar Nerseth (Based on Update Tool from Hally @ zonestar3d)
@echo #######################################################################
@pause
@echo Please Input ComPort Number and press ENTER (e.g. 8)
@set/p x= >nul
:inputfilename
@echo Please Input File Name and press ENTER (without .hex extension)
@set/p filename= >nul
:start
@avrdude -p m1284p -b115200 -c Arduino -P COM%x% -U flash:r:%filename%-flash.hex:i
@avrdude -p m1284p -b115200 -c Arduino -P COM%x% -U eeprom:r:%filename%-eeprom.hex:i
@avrdude -p m1284p -b115200 -c Arduino -P COM%x% -U hfuse:r:%filename%-hfuse.hex:i
@avrdude -p m1284p -b115200 -c Arduino -P COM%x% -U lfuse:r:%filename%-lfuse.hex:i
@avrdude -p m1284p -b115200 -c Arduino -P COM%x% -U efuse:r:%filename%-efuse.hex:i

@echo Backup Finished!
@pause
