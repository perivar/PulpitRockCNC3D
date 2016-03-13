@color 9E
@echo #######################################################################
@echo           3D Printer Control Board Firmware Updata Tool
@echo                    for AVR ATMAGE MCU ONLY
@echo Date:2015-05-05
@echo Author:Hally
@echo Web:www.zonestar3d.com
@echo #######################################################################
@pause
@echo Please Input ComPort Number and press ENTER£º 
@set/p x= >nul
:inputfilename
@echo Please Input File Name and press ENTER£º 
@set/p filename= >nul
@if exist %filename%.hex goto start
@echo [ERROR]File is not exist or filename is error!
@goto inputfilename
:start
@avrdude -p m1284p -b57600 -c Arduino -P COM%x% -e -U flash:w:%filename%.hex
@echo Updata Finished!
@pause
