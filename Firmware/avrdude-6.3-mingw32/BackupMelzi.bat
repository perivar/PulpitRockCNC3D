@color 9E
@echo #######################################################################
@echo                      Firmware Backup Tool
@echo                    for AVR ATMAGE MCU ONLY
@echo Date:2016-03-13
@echo Author:Per Ivar Nerseth (Based on Update Tool from Hally @ zonestar3d)
@echo #######################################################################
@pause
@echo Please Input ComPort Number and press ENTER (E.g. 8)
@set/p x= >nul

@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -U flash:r:MelziBackup-flash.hex:i
@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -U eeprom:r:MelziBackup-eeprom.hex:i
@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -U hfuse:r:MelziBackup-hfuse.hex:i
@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -U lfuse:r:MelziBackup-lfuse.hex:i
@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -U efuse:r:MelziBackup-efuse.hex:i

@echo Backup Finished!
@pause
