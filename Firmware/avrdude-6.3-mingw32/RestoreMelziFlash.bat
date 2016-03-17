@echo off
@color 9E
@echo #######################################################################
@echo           Restore Melzi Flash Image
@echo Date:2016-03-17
@echo Author: perivar@nerseth.com
@echo #######################################################################
@pause
@echo Please Input ComPort Number and press ENTER (e.g. 8)
@set/p x= >nul
:inputfilename
@echo Please Input File Name and press ENTER (without .hex extension)
@set/p filename= >nul
@if exist %filename%.hex goto start
@echo [ERROR]File is not exist or filename is error!
@goto inputfilename
:start
REM C:\Users\perivar.nerseth\Desktop\MAKER\arduino-1.6.7\hardware\tools\avr/bin/avrdude ^
REM -CC:\Users\perivar.nerseth\Desktop\MAKER\arduino-1.6.7\hardware\tools\avr/etc/avrdude.conf ^
REM C:\Users\perivar.nerseth\Desktop\MAKER\arduino-1.0.5-r2\hardware/tools/avr/bin/avrdude ^
REM -CC:\Users\perivar.nerseth\Desktop\MAKER\arduino-1.0.5-r2\hardware/tools/avr/etc/avrdude.conf ^
@avrdude ^
-p atmega1284p ^
-c arduino ^
-P COM%x% ^
-b 115200 ^
-D ^
-U flash:w:%filename%.hex:i ^

@echo Update Finished!
@pause