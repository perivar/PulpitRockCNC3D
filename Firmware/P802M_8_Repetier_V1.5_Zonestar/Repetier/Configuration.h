/*
版本记录:
===================================================================
版本号: 	V1.6
修改时间澹: 2015-08-20
修改内容:
1、热床测温表
2、
*/

/*
Version history:
===================================================================
Version Number: V1.6
Modified: 2015-08-20
Modifications:
1. hot bed temperature table
2.
*/

#ifndef CONFIGURATION_H
#define CONFIGURATION_H

/**************** READ FIRST ************************

   This configuration file was created with the configuration tool. For that
   reason, it does not contain the same informations as the original Configuration.h file.
   It misses the comments and unused parts. Open this file file in the config tool
   to see and change the data. You can also upload it to newer/older versions. The system
   will silently add new options, so compilation continues to work.

   This file is optimized for version 0.91
   generator: http://www.repetier.com/firmware/v091/
*/

#define NUM_EXTRUDER 				1
#define MOTHERBOARD 				63

#include "pins.h"
// ################## ADD BY Hally ################
//#define	ENABLE_BLUETOOTH

//for ADC KEYPAD
#define	HAVE_ADC_KEYPAD				true
#define	HAVE_LCD					true	

#define AUXILIARY_LEVELING			true
#define AUX_LEVEL_GOTOP1_SCRIPT 	"G1 Z3 F600\nG1 X10 Y10 F6000\nG1 Z0.2 F600\n"
#define AUX_LEVEL_GOTOP2_SCRIPT 	"G1 Z3 F600\nG1 X190 Y10 F6000\nG1 Z0.2 F600\n"
#define AUX_LEVEL_GOTOP3_SCRIPT 	"G1 Z3 F600\nG1 X190 Y190 F6000\nG1 Z0.2 F600\n"
#define AUX_LEVEL_GOTOP4_SCRIPT 	"G1 Z3 F600\nG1 X10 Y190 F6000\nG1 Z0.2 F600\n"


// ################## EDIT THESE SETTINGS MANUALLY ################
// ################ END MANUAL SETTINGS ##########################

#define FAN_BOARD_PIN 				-1//ORIG_FAN2_PIN

//#define EXTERNALSERIAL  use Arduino serial library instead of build in. Requires more ram, has only 63 byte input buffer.
// Uncomment the following line if you are using arduino compatible firmware made for Arduino version earlier then 1.0
// If it is incompatible you will get compiler errors about write functions not beeing compatible!
//#define COMPAT_PRE1


#define DRIVE_SYSTEM 				0
#define XAXIS_STEPS_PER_MM 			100
#define YAXIS_STEPS_PER_MM 			100
#define ZAXIS_STEPS_PER_MM 			400
#define EXTRUDER_FAN_COOL_TEMP 		50
#define EXT0_X_OFFSET 				0
#define EXT0_Y_OFFSET 				0
#define EXT0_STEPS_PER_MM 			90
#define EXT0_TEMPSENSOR_PIN 		TEMP_0_PIN
#define EXT0_HEATER_PIN 			HEATER_0_PIN
#define EXT0_STEP_PIN 				ORIG_E0_STEP_PIN
#define EXT0_DIR_PIN 				ORIG_E0_DIR_PIN
#define EXT0_INVERSE 				0
#define EXT0_ENABLE_PIN 			E0_ENABLE_PIN
#define EXT0_ENABLE_ON 				0
#define EXT0_MAX_FEEDRATE 			50
#define EXT0_MAX_START_FEEDRATE 	20
#define EXT0_MAX_ACCELERATION 		5000
#define EXT0_HEAT_MANAGER 			3
#define EXT0_WATCHPERIOD 			1
#define EXT0_PID_INTEGRAL_DRIVE_MAX 230
#define EXT0_PID_INTEGRAL_DRIVE_MIN 50
#define EXT0_PID_P 					7
#define EXT0_PID_I 					2
#define EXT0_PID_D 					40
#define EXT0_PID_MAX 				255
#define EXT0_ADVANCE_K 				0
#define EXT0_ADVANCE_L 				0
#define EXT0_ADVANCE_BACKLASH_STEPS 0
#define EXT0_WAIT_RETRACT_TEMP 		150
#define EXT0_WAIT_RETRACT_UNITS 	0
#define EXT0_SELECT_COMMANDS 		""
#define EXT0_DESELECT_COMMANDS 		""
#define EXT0_EXTRUDER_COOLER_PIN 	-1
#define EXT0_EXTRUDER_COOLER_SPEED 	255
#define RETRACT_DURING_HEATUP 		true
#define PID_CONTROL_RANGE 			20
#define SKIP_M109_IF_WITHIN 		2
#define SCALE_PID_TO_MAX 			1
#define TEMP_HYSTERESIS 			0
#define EXTRUDE_MAXLENGTH 			160
#define NUM_TEMPS_USERTHERMISTOR0 	0
#define USER_THERMISTORTABLE0 		{}

#define NUM_TEMPS_USERTHERMISTOR1 	0
#define USER_THERMISTORTABLE1 		{}
#define NUM_TEMPS_USERTHERMISTOR2 	0
#define USER_THERMISTORTABLE2 		{}
#define GENERIC_THERM_VREF 			5
#define GENERIC_THERM_NUM_ENTRIES 	33
#define HEATER_PWM_SPEED 			0

// ############# Heated bed configuration ########################
#define HAVE_HEATED_BED 			1
#define HEATED_BED_MAX_TEMP 		120
#define SKIP_M190_IF_WITHIN 		3
#define HEATED_BED_SENSOR_PIN 		TEMP_1_PIN
#define HEATED_BED_HEATER_PIN 		HEATER_1_PIN
#define HEATED_BED_SET_INTERVAL 	5000
#define HEATED_BED_HEAT_MANAGER 	0
#define HEATED_BED_PID_INTEGRAL_DRIVE_MAX 255
#define HEATED_BED_PID_INTEGRAL_DRIVE_MIN 80
#define HEATED_BED_PID_PGAIN   		196
#define HEATED_BED_PID_IGAIN   		33
#define HEATED_BED_PID_DGAIN 		290
#define HEATED_BED_PID_MAX 			255
#define MIN_EXTRUDER_TEMP 			150
#define MAXTEMP 					275
#define MIN_DEFECT_TEMPERATURE 		-10
#define MAX_DEFECT_TEMPERATURE 		290

#if 0
#define EXT0_TEMPSENSOR_TYPE 		1
#define HEATED_BED_SENSOR_TYPE 		1
#define NUM_TEMPS_USERTHERMISTOR0 	0
#define USER_THERMISTORTABLE0 {}
#elif 0
#define EXT0_TEMPSENSOR_TYPE 		97
#define HEATED_BED_SENSOR_TYPE 		97
#define USE_GENERIC_THERMISTORTABLE_1
#define GENERIC_THERM1_T0 			25
#define GENERIC_THERM1_R0 			100000
#define GENERIC_THERM1_BETA 		3950
#define GENERIC_THERM1_MIN_TEMP 	-20
#define GENERIC_THERM1_MAX_TEMP 	300
#define GENERIC_THERM1_R1 			0
#define GENERIC_THERM1_R2 			4700
#else
#define EXT0_TEMPSENSOR_TYPE 		5
#define NUM_TEMPS_USERTHERMISTOR0 	58
#define USER_THERMISTORTABLE0 {		\
{  56,300*8},{  59,295*8},{  64,290*8},{  70,285*8},{  76,280*8},{  82,275*8},{  89,270*8},{  98,265*8},\
{ 108,260*8},{ 118,255*8},{ 128,250*8},{ 145,245*8},{ 156,240*8},{ 168,235*8},{ 187,230*8},{ 208,225*8},\
{ 227,220*8},{ 248,215*8},{ 272,210*8},{ 301,205*8},{ 336,200*8},{ 370,195*8},{ 400,190*8},{ 450,185*8},\
{ 492,180*8},{ 552,175*8},{ 615,170*8},{ 690,165*8},{ 750,160*8},{ 830,155*8},{ 920,150*8},{1010,145*8},\
{1118,140*8},{1215,135*8},{1330,130*8},{1460,125*8},{1594,120*8},{1752,115*8},{1900,110*8},{2040,105*8},\
{2200,100*8},{2350, 95*8},{2516, 90*8},{2671, 85*8},{2831, 80*8},{2975, 75*8},{3115, 70*8},{3251, 65*8},\
{3375, 60*8},{3480, 55*8},{3580, 50*8},{3660, 45*8},{3740, 40*8},{3869, 30*8},{3912, 25*8},{3948, 20*8},\
{4077,-20*8},{4094,-55*8}}

#define HEATED_BED_SENSOR_TYPE 		6
#define NUM_TEMPS_USERTHERMISTOR1 	33
#define USER_THERMISTORTABLE1 {		\
{  56,300*8},{ 187,250*8},{ 615,190*8},{ 690,185*8},{ 750,180*8},{ 830,175*8},{ 920,170*8},{1010,165*8},\
{1118,160*8},{1215,155*8},{1330,145*8},{1460,140*8},{1594,135*8},{1752,130*8},{1900,125*8},{2040,120*8},\
{2200,115*8},{2350,110*8},{2516,105*8},{2671, 98*8},{2831, 92*8},{2975, 85*8},{3115, 76*8},{3251, 72*8},\
{3480, 62*8},{3580, 52*8},{3660, 46*8},{3740, 40*8},{3869, 30*8},{3912, 25*8},{3948, 20*8},{4077,-20*8},\
{4094,-55*8}}
#endif

// ################ Endstop configuration #####################

#define ENDSTOP_PULLUP_X_MIN 		true
#define ENDSTOP_X_MIN_INVERTING 	true
#define MIN_HARDWARE_ENDSTOP_X 		true
#define ENDSTOP_PULLUP_Y_MIN 		true
#define ENDSTOP_Y_MIN_INVERTING 	true
#define MIN_HARDWARE_ENDSTOP_Y 		true
#define ENDSTOP_PULLUP_Z_MIN 		true
#define ENDSTOP_Z_MIN_INVERTING 	true
#define MIN_HARDWARE_ENDSTOP_Z 		true
#define ENDSTOP_PULLUP_X_MAX 		true
#define ENDSTOP_X_MAX_INVERTING 	false
#define MAX_HARDWARE_ENDSTOP_X 		false
#define ENDSTOP_PULLUP_Y_MAX 		true
#define ENDSTOP_Y_MAX_INVERTING 	false
#define MAX_HARDWARE_ENDSTOP_Y 		false
#define ENDSTOP_PULLUP_Z_MAX 		true
#define ENDSTOP_Z_MAX_INVERTING 	false
#define MAX_HARDWARE_ENDSTOP_Z 		false
#define max_software_endstop_r 		true

#define min_software_endstop_x 		false
#define min_software_endstop_y 		false
#define min_software_endstop_z 		false
#define max_software_endstop_x 		true
#define max_software_endstop_y 		true
#define max_software_endstop_z 		true
#define ENDSTOP_X_BACK_MOVE 				5
#define ENDSTOP_Y_BACK_MOVE 				5
#define ENDSTOP_Z_BACK_MOVE 				2
#define ENDSTOP_X_RETEST_REDUCTION_FACTOR 	3
#define ENDSTOP_Y_RETEST_REDUCTION_FACTOR 	3
#define ENDSTOP_Z_RETEST_REDUCTION_FACTOR 	3
#define ENDSTOP_X_BACK_ON_HOME 				1
#define ENDSTOP_Y_BACK_ON_HOME 				1
#define ENDSTOP_Z_BACK_ON_HOME 				0
#define ALWAYS_CHECK_ENDSTOPS 				1

// ################# XYZ movements ###################

#define X_ENABLE_ON 	0
#define Y_ENABLE_ON 	0
#define Z_ENABLE_ON 	0
#define DISABLE_X 		0
#define DISABLE_Y 		0
#define DISABLE_Z 		0
#define DISABLE_E 		0
#define INVERT_X_DIR	0
#define INVERT_Y_DIR 	0
#define INVERT_Z_DIR 	1///0
#define X_HOME_DIR 		-1
#define Y_HOME_DIR 		-1
#define Z_HOME_DIR 		-1
#define X_MAX_LENGTH 	265
#define Y_MAX_LENGTH 	230
#define Z_MAX_LENGTH 	235
#define X_MIN_POS 		-45
#define Y_MIN_POS 		-5
#define Z_MIN_POS 		0

// ##########################################################################################
// ##                           Movement settings                                          ##
// ##########################################################################################

#define FEATURE_BABYSTEPPING 							0///1
#define BABYSTEP_MULTIPLICATOR 							100///1

#define DELTA_SEGMENTS_PER_SECOND_PRINT 				180 // Move accurate setting for print moves
#define DELTA_SEGMENTS_PER_SECOND_MOVE 					70 // Less accurate setting for other moves

// Delta settings
#define DELTA_HOME_ON_POWER 							0

#define MAX_DELTA_SEGMENTS_PER_LINE 					24
#define STEPPER_INACTIVE_TIME 							360L//S
#define MAX_INACTIVE_TIME 								0L
#define MAX_FEEDRATE_X 									400
#define MAX_FEEDRATE_Y 									400
#define MAX_FEEDRATE_Z 									4
#define HOMING_FEEDRATE_X 								100
#define HOMING_FEEDRATE_Y 								100
#define HOMING_FEEDRATE_Z 								2
#define HOMING_ORDER 									HOME_ORDER_XYZ
#define ENABLE_BACKLASH_COMPENSATION 					0
#define X_BACKLASH 										0
#define Y_BACKLASH 										0
#define Z_BACKLASH 										0
#define RAMP_ACCELERATION 								1
#define STEPPER_HIGH_DELAY 								0
#define STEP_DOUBLER_FREQUENCY 							12000
#define ALLOW_QUADSTEPPING 								1
#define DOUBLE_STEP_DELAY 								1 // time in microseconds
#define MAX_HALFSTEP_INTERVAL 							1999
#define MAX_ACCELERATION_UNITS_PER_SQ_SECOND_X 			400
#define MAX_ACCELERATION_UNITS_PER_SQ_SECOND_Y 			400
#define MAX_ACCELERATION_UNITS_PER_SQ_SECOND_Z 			400
#define MAX_TRAVEL_ACCELERATION_UNITS_PER_SQ_SECOND_X 	400
#define MAX_TRAVEL_ACCELERATION_UNITS_PER_SQ_SECOND_Y 	400
#define MAX_TRAVEL_ACCELERATION_UNITS_PER_SQ_SECOND_Z 	400
#define MAX_JERK 										20
#define MAX_ZJERK 										0.3
#define MOVE_CACHE_SIZE 								16
#define MOVE_CACHE_LOW 									10
#define LOW_TICKS_PER_MOVE 								250000
#define FEATURE_TWO_XSTEPPER 							0
#define X2_STEP_PIN   									ORIG_E2_STEP_PIN//ORIG_E2_STEP_PIN
#define X2_DIR_PIN    									ORIG_E2_DIR_PIN
#define X2_ENABLE_PIN 									ORIG_E2_ENABLE_PIN
#define FEATURE_TWO_YSTEPPER 							0
#define Y2_STEP_PIN   									ORIG_E2_STEP_PIN
#define Y2_DIR_PIN    									ORIG_E2_DIR_PIN
#define Y2_ENABLE_PIN 									ORIG_E2_ENABLE_PIN
#define FEATURE_TWO_ZSTEPPER 							0
#define Z2_STEP_PIN   									ORIG_E2_STEP_PIN
#define Z2_DIR_PIN    									ORIG_E2_DIR_PIN
#define Z2_ENABLE_PIN 									ORIG_E2_ENABLE_PIN
#define FEATURE_DITTO_PRINTING 							0

// ################# Misc. settings ##################

#define BAUDRATE 										115200
#define ENABLE_POWER_ON_STARTUP
#define POWER_INVERTING 								0
#define KILL_METHOD 									1
#define GCODE_BUFFER_SIZE 								2
#define ACK_WITH_LINENUMBER
#define WAITING_IDENTIFIER 								"wait"
#define ECHO_ON_EXECUTE
#define EEPROM_MODE 									16

/* ======== Servos =======
Control the servos with
M340 P<servoId> S<pulseInUS>   / ServoID = 0..3  pulseInUs = 500..2500
Servos are controlled by a pulse width normally between 500 and 2500 with 1500ms in center position. 0 turns servo off.
WARNING: Servos can draw a considerable amount of current. Make sure your system can handle this or you may risk your hardware!
*/
#define FEATURE_SERVO 									0
#define SERVO0_PIN 										11
#define SERVO1_PIN 										-1
#define SERVO2_PIN 										-1
#define SERVO3_PIN 										-1
#define FEATURE_WATCHDOG 								0///1

// #################### Z-Probing #####################
#define	AUTO_LEVEL_DEBUG								0
#define FEATURE_Z_PROBE 								0
#define Z_PROBE_BED_DISTANCE 							4
#define Z_PROBE_PIN 									-1
#define Z_PROBE_PULLUP 									1
#define Z_PROBE_ON_HIGH 								0
#define Z_PROBE_X_OFFSET 								0
#define Z_PROBE_Y_OFFSET 								0
#define Z_PROBE_WAIT_BEFORE_TEST 						0
#define Z_PROBE_SPEED 									2
#define Z_PROBE_XY_SPEED 								200
#define Z_PROBE_SWITCHING_DISTANCE 						0.3
#define Z_PROBE_REPETITIONS 							2
#define Z_PROBE_HEIGHT 									5
#define Z_PROBE_START_SCRIPT 							"G28 Y0 X0\n G1 X-40\n G28 Z0\n G1 Z5\n"
#define Z_PROBE_FINISHED_SCRIPT 						"G28 X0 Y200\n"

#define FEATURE_AUTOLEVEL	 							0
#define Z_PROBE_X0 										-30
#define Z_PROBE_Y0 										-5

#define Z_PROBE_X1 										150
#define Z_PROBE_Y1 										-5

#define Z_PROBE_X2 										150
#define Z_PROBE_Y2 										160

#define Z_PROBE_X3 										-30
#define Z_PROBE_Y3 										160

#ifndef SDSUPPORT  // Some boards have sd support on board. These define the values already in pins.h
#define SDSUPPORT 										1
#define SDCARDDETECT 									-1
#define SDCARDDETECTINVERTED 							0
#endif

#define SD_EXTENDED_DIR 								1 /** Show extended directory including file length. Don't use this with Pronterface! */
#define ARC_SUPPORT 									1
#define FEATURE_MEMORY_POSITION 						1
#define FEATURE_CHECKSUM_FORCED 						0
#define FEATURE_FAN_CONTROL 							1
#define FEATURE_CONTROLLER 								16//8
#define UI_LANGUAGE 									0
#define UI_PRINTER_NAME 								"P802M_8"
#define	UI_FIRWWARE_VERSION								"P802M_8_V1.5"
#define UI_PRINTER_COMPANY 								"Zonestar 3D Printer"
#define UI_PAGES_DURATION 								5000
#define UI_ANIMATION 									1
#define UI_SPEEDDEPENDENT_POSITIONING 					false
#define UI_DISABLE_AUTO_PAGESWITCH 						1
#define UI_AUTORETURN_TO_MENU_AFTER 					50000
#define FEATURE_UI_KEYS 								0
#define UI_ENCODER_SPEED 								0
#define UI_KEY_BOUNCETIME 								2
#define UI_KEY_FIRST_REPEAT 							250
#define UI_KEY_REDUCE_REPEAT 							25
#define UI_KEY_MIN_REPEAT 								25
#define FEATURE_BEEPER 									0
#define CASE_LIGHTS_PIN 								-1
#define CASE_LIGHT_DEFAULT_ON 							1
#define UI_START_SCREEN_DELAY 							1000
/**
Beeper sound definitions for short beeps during key actions
and longer beeps for important actions.
Parameter is delay in microseconds and the secons is the number of repetitions.
Values must be in range 1..255
*/
#define BEEPER_SHORT_SEQUENCE 							2,2
#define BEEPER_LONG_SEQUENCE 							8,8
#define UI_SET_PRESET_HEATED_BED_TEMP_PLA 				55
#define UI_SET_PRESET_EXTRUDER_TEMP_PLA   				190
#define UI_SET_PRESET_HEATED_BED_TEMP_ABS 				85
#define UI_SET_PRESET_EXTRUDER_TEMP_ABS   				240
#define UI_SET_MIN_HEATED_BED_TEMP  					30
#define UI_SET_MAX_HEATED_BED_TEMP 						120
#define UI_SET_MIN_EXTRUDER_TEMP   						170
#define UI_SET_MAX_EXTRUDER_TEMP   						260
#define UI_SET_EXTRUDER_FEEDRATE 						2
#define UI_SET_EXTRUDER_RETRACT_DISTANCE 				3

#endif

/* Below you will find the configuration string, that created this Configuration.h

========== Start configuration string ==========
{
    "editMode": 2,
    "processor": 0,
    "baudrate": 115200,
    "xStepsPerMM": 100,
    "yStepsPerMM": 100,
    "zStepsPerMM": 400,
    "xInvert": 0,
    "xInvertEnable": 0,
    "eepromMode": 1,
    "yInvert": 0,
    "yInvertEnable": 0,
    "zInvert": 0,
    "zInvertEnable": 0,
    "extruder": [
        {
            "id": 0,
            "heatManager": 3,
            "pidDriveMin": 40,
            "pidDriveMax": 230,
            "pidMax": 255,
            "sensorType": 100,
            "sensorPin": "TEMP_0_PIN",
            "heaterPin": "HEATER_0_PIN",
            "maxFeedrate": 50,
            "startFeedrate": 20,
            "invert": "0",
            "invertEnable": "0",
            "acceleration": 5000,
            "watchPeriod": 1,
            "pidP": 7,
            "pidI": 2,
            "pidD": 40,
            "advanceK": 0,
            "advanceL": 0,
            "waitRetractTemp": 150,
            "waitRetractUnits": 0,
            "waitRetract": 0,
            "stepsPerMM": 160,
            "coolerPin": -1,
            "coolerSpeed": 255,
            "selectCommands": "",
            "deselectCommands": "",
            "xOffset": 0,
            "yOffset": 0,
            "xOffsetSteps": 0,
            "yOffsetSteps": 0,
            "stepper": {
                "name": "Extruder 0",
                "step": "ORIG_E0_STEP_PIN",
                "dir": "ORIG_E0_DIR_PIN",
                "enable": "E0_ENABLE_PIN"
            },
            "advanceBacklashSteps": 0
        }
    ],
    "uiLanguage": 0,
    "uiController": 0,
    "xMinEndstop": 1,
    "yMinEndstop": 1,
    "zMinEndstop": 1,
    "xMaxEndstop": 1,
    "yMaxEndstop": 1,
    "zMaxEndstop": 1,
    "motherboard": 701,
    "driveSystem": 0,
    "xMaxSpeed": 50,
    "xHomingSpeed": 40,
    "xTravelAcceleration": 200,
    "xPrintAcceleration": 200,
    "yMaxSpeed": 50,
    "yHomingSpeed": 40,
    "yTravelAcceleration": 200,
    "yPrintAcceleration": 200,
    "zMaxSpeed": 2,
    "zHomingSpeed": 2,
    "zTravelAcceleration": 100,
    "zPrintAcceleration": 100,
    "xMotor": {
        "name": "X motor",
        "step": "ORIG_X_STEP_PIN",
        "dir": "ORIG_X_DIR_PIN",
        "enable": "ORIG_X_ENABLE_PIN"
    },
    "yMotor": {
        "name": "Y motor",
        "step": "ORIG_Y_STEP_PIN",
        "dir": "ORIG_Y_DIR_PIN",
        "enable": "ORIG_Y_ENABLE_PIN"
    },
    "zMotor": {
        "name": "Z motor",
        "step": "ORIG_Z_STEP_PIN",
        "dir": "ORIG_Z_DIR_PIN",
        "enable": "ORIG_Z_ENABLE_PIN"
    },
    "enableBacklash": "1",
    "backlashX": 0,
    "backlashY": 0,
    "backlashZ": 0,
    "stepperInactiveTime": 360,
    "maxInactiveTime": 0,
    "xMinPos": 0,
    "yMinPos": 0,
    "zMinPos": 0,
    "xLength": 200,
    "yLength": 200,
    "zLength": 120,
    "alwaysCheckEndstops": "1",
    "disableX": "0",
    "disableY": "0",
    "disableZ": "0",
    "disableE": "0",
    "xHomeDir": "-1",
    "yHomeDir": "-1",
    "zHomeDir": "-1",
    "xEndstopBack": 1,
    "yEndstopBack": 1,
    "zEndstopBack": 0,
    "deltaSegmentsPerSecondPrint": 180,
    "deltaSegmentsPerSecondTravel": 70,
    "deltaDiagonalRod": 445,
    "deltaHorizontalRadius": 209.25,
    "deltaAlphaA": 210,
    "deltaAlphaB": 330,
    "deltaAlphaC": 90,
    "deltaDiagonalCorrA": 0,
    "deltaDiagonalCorrB": 0,
    "deltaDiagonalCorrC": 0,
    "deltaMaxRadius": 150,
    "deltaRadiusCorrA": 0,
    "deltaRadiusCorrB": 0,
    "deltaRadiusCorrC": 0,
    "deltaXOffsetSteps": 0,
    "deltaYOffsetSteps": 0,
    "deltaZOffsetSteps": 0,
    "deltaSegmentsPerLine": 24,
    "stepperHighDelay": 0,
    "stepDoublerFrequency": 12000,
    "allowQuadstepping": "1",
    "doubleStepDelay": 1,
    "maxHalfstepInterval": 1999,
    "maxJerk": 20,
    "maxZJerk": 0.3,
    "moveCacheSize": 16,
    "moveCacheLow": 10,
    "lowTicksPerMove": 250000,
    "enablePowerOnStartup": "1",
    "echoOnExecute": "1",
    "sendWaits": "1",
    "ackWithLineNumber": "1",
    "killMethod": 1,
    "useAdvance": "0",
    "useQuadraticAdvance": "0",
    "powerInverting": 0,
    "mirrorX": 0,
    "mirrorXMotor": {
        "name": "Extruder 1",
        "step": "ORIG_E1_STEP_PIN",
        "dir": "ORIG_E1_DIR_PIN",
        "enable": "E1_ENABLE_PIN"
    },
    "mirrorY": 0,
    "mirrorYMotor": {
        "name": "Extruder 1",
        "step": "ORIG_E1_STEP_PIN",
        "dir": "ORIG_E1_DIR_PIN",
        "enable": "E1_ENABLE_PIN"
    },
    "mirrorZ": 0,
    "mirrorZMotor": {
        "name": "Extruder 1",
        "step": "ORIG_E1_STEP_PIN",
        "dir": "ORIG_E1_DIR_PIN",
        "enable": "E1_ENABLE_PIN"
    },
    "dittoPrinting": "0",
    "featureServos": "0",
    "servo0Pin": 11,
    "servo1Pin": -1,
    "servo2Pin": -1,
    "servo3Pin": -1,
    "featureWatchdog": "1",
    "hasHeatedBed": "0",
    "enableZProbing": "0",
    "extrudeMaxLength": 160,
    "homeOrder": "HOME_ORDER_XYZ",
    "featureController": 8,
    "uiPrinterName": "RepRap",
    "uiPrinterCompany": "Home made",
    "uiPagesDuration": 4000,
    "uiAnimation": "1",
    "uiDisablePageswitch": "1",
    "uiAutoReturnAfter": 30000,
    "featureKeys": "0",
    "uiEncoderSpeed": 1,
    "uiKeyBouncetime": 10,
    "uiKeyFirstRepeat": 500,
    "uiKeyReduceRepeat": 50,
    "uiKeyMinRepeat": 50,
    "featureBeeper": "1",
    "uiPresetBedTempPLA": 60,
    "uiPresetBedABS": 110,
    "uiPresetExtruderPLA": 190,
    "uiPresetExtruderABS": 240,
    "uiMinHeatedBed": 30,
    "uiMaxHeatedBed": 120,
    "uiMinEtxruderTemp": 170,
    "uiMaxExtruderTemp": 260,
    "uiExtruderFeedrate": 2,
    "uiExtruderRetractDistance": 3,
    "uiSpeeddependentPositioning": "0",
    "maxBedTemperature": 120,
    "bedSensorType": 1,
    "bedSensorPin": "TEMP_1_PIN",
    "bedHeaterPin": "HEATER_1_PIN",
    "bedHeatManager": 0,
    "bedUpdateInterval": 5000,
    "bedPidDriveMin": 80,
    "bedPidDriveMax": 255,
    "bedPidP": 196,
    "bedPidI": 33,
    "bedPidD": 290,
    "bedPidMax": 255,
    "caseLightPin": "ORIG_FAN2_PIN",
    "caseLightDefaultOn": "1",
    "bedSkipIfWithin": 3,
    "gen1T0": 25,
    "gen1R0": 100000,
    "gen1Beta": 4036,
    "gen1MinTemp": -20,
    "gen1MaxTemp": 300,
    "gen1R1": 0,
    "gen1R2": 4700,
    "gen2T0": 25,
    "gen2R0": 100000,
    "gen2Beta": 4036,
    "gen2MinTemp": -20,
    "gen2MaxTemp": 300,
    "gen2R1": 0,
    "gen2R2": 4700,
    "gen3T0": 25,
    "gen3R0": 100000,
    "gen3Beta": 4036,
    "gen3MinTemp": -20,
    "gen3MaxTemp": 300,
    "gen3R1": 0,
    "gen3R2": 4700,
    "userTable0": {
        "r1": 0,
        "r2": 4700,
        "temps": [

        ]
    },
    "userTable1": {
        "r1": 0,
        "r2": 4700,
        "temps": [

        ]
    },
    "userTable2": {
        "r1": 0,
        "r2": 4700,
        "temps": [

        ]
    },
    "tempHysteresis": 0,
    "pidControlRange": 20,
    "skipM109Within": 2,
    "extruderFanCoolTemp": 50,
    "minTemp": 150,
    "maxTemp": 275,
    "minDefectTemp": -10,
    "maxDefectTemp": 290,
    "arcSupport": "1",
    "featureMemoryPositionWatchdog": "1",
    "forceChecksum": "0",
    "sdExtendedDir": "1",
    "featureFanControl": "1",
    "fanPin": "ORIG_FAN_PIN",
    "scalePidToMax": "1",
    "zProbePin": -1,
    "zProbeBedDistance": 10,
    "zProbePullup": "0",
    "zProbeOnHigh": "0",
    "zProbeXOffset": 0,
    "zProbeYOffset": 0,
    "zProbeWaitBeforeTest": "0",
    "zProbeSpeed": 2,
    "zProbeXYSpeed": 150,
    "zProbeHeight": 40,
    "zProbeStartScript": "",
    "zProbeFinishedScript": "",
    "featureAutolevel": "1",
    "zProbeX1": 20,
    "zProbeY1": 20,
    "zProbeX2": 160,
    "zProbeY2": 20,
    "zProbeX3": 100,
    "zProbeY3": 160,
    "zProbeSwitchingDistance": 1,
    "zProbeRepetitions": 1,
    "sdSupport": "1",
    "sdCardDetectPin": "SDCARDDETECT",
    "sdCardDetectInverted": "1",
    "uiStartScreenDelay": 1000,
    "xEndstopBackMove": 5,
    "yEndstopBackMove": 5,
    "zEndstopBackMove": 2,
    "xEndstopRetestFactor": 3,
    "yEndstopRetestFactor": 3,
    "zEndstopRetestFactor": 3,
    "xMinPin": "ORIG_X_MIN_PIN",
    "yMinPin": "ORIG_Y_MIN_PIN",
    "zMinPin": "ORIG_Z_MIN_PIN",
    "xMaxPin": "ORIG_X_MAX_PIN",
    "yMaxPin": "ORIG_Y_MAX_PIN",
    "zMaxPin": "ORIG_Z_MAX_PIN",
    "deltaHomeOnPower": "0",
    "fanBoardPin": "ORIG_FAN2_PIN",
    "heaterPWMSpeed": 0,
    "featureBabystepping": "1",
    "babystepMultiplicator": 1,
    "hasMAX6675": false,
    "hasMAX31855": false,
    "hasGeneric1": false,
    "hasGeneric2": false,
    "hasGeneric3": false,
    "hasUser0": false,
    "hasUser1": false,
    "hasUser2": false,
    "numExtruder": 1,
    "version": 91.7
}
========== End configuration string ==========

*/
