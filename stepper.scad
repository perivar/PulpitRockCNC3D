/*
* A nema standard stepper motor module.
* 
* Originally by Hans Häggström, 2010.
* Modified so that the 17HS4401 has correct measurements and colors, Per Ivar Nerseth, 2015.
* Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
*/

include <MCAD/units.scad>
include <MCAD/materials.scad>
use <roundedcube.scad>

// Demo, uncomment to show:
//nema_demo();
//motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);

module nema_demo(){
	for (size = [NemaShort, NemaMedium, NemaLong]) {  
		translate([-100,size*100,0]) motor(Nema34, size, dualAxis=true);
		translate([0,size*100,0])    motor(Nema23, size, dualAxis=true);
		translate([100,size*100,0])  motor(Nema17, size, dualAxis=true);
		translate([200,size*100,0])  motor(Nema14, size, dualAxis=true);
		translate([300,size*100,0])  motor(Nema11, size, dualAxis=true);
		translate([400,size*100,0])  motor(Nema08, size, dualAxis=true);
	}
}


// Parameters: 
NemaModel = 0;
NemaLengthShort = 1;
NemaLengthMedium = 2;
NemaLengthLong = 3;
NemaSideSize = 4;
NemaDistanceBetweenMountingHoles = 5;
NemaMountingHoleDiameter = 6;
NemaMountingHoleDepth = 7;
NemaMountingHoleLip = 8;
NemaMountingHoleCutoutRadius = 9;
NemaEdgeRoundingRadius = 10;
NemaRoundExtrusionDiameter = 11;
NemaRoundExtrusionHeight = 12;
NemaAxleDiameter = 13;
NemaFrontAxleLength = 14;
NemaBackAxleLength = 15;
NemaAxleFlatDepth = 16;
NemaAxleFlatLengthFront = 17;
NemaAxleFlatLengthBack = 18;

NemaShort = 1;
NemaMedium = 2;
NemaLong = 3;

// TODO: The small motors seem to be a bit too long, I picked the size specs from all over the place, is there some canonical reference?
Nema08 = [
[NemaModel, 8],
[NemaLengthShort, 33*mm],
[NemaLengthMedium, 43*mm],
[NemaLengthLong, 43*mm],
[NemaSideSize, 20*mm], 
[NemaDistanceBetweenMountingHoles, 15.4*mm], 
[NemaMountingHoleDiameter, 2*mm], 
[NemaMountingHoleDepth, 1.75*mm], 
[NemaMountingHoleLip, -1*mm], 
[NemaMountingHoleCutoutRadius, 0*mm], 
[NemaEdgeRoundingRadius, 2*mm], 
[NemaRoundExtrusionDiameter, 16*mm], 
[NemaRoundExtrusionHeight, 1.5*mm], 
[NemaAxleDiameter, 4*mm], 
[NemaFrontAxleLength, 13.5*mm], 
[NemaBackAxleLength, 9.9*mm],
[NemaAxleFlatDepth, -1*mm],
[NemaAxleFlatLengthFront, 0*mm],
[NemaAxleFlatLengthBack, 0*mm]
];

Nema11 = [
[NemaModel, 11],
[NemaLengthShort, 32*mm],
[NemaLengthMedium, 40*mm],
[NemaLengthLong, 52*mm],
[NemaSideSize, 28*mm], 
[NemaDistanceBetweenMountingHoles, 23*mm], 
[NemaMountingHoleDiameter, 2.5*mm], 
[NemaMountingHoleDepth, 2*mm], 
[NemaMountingHoleLip, -1*mm], 
[NemaMountingHoleCutoutRadius, 0*mm], 
[NemaEdgeRoundingRadius, 2.5*mm], 
[NemaRoundExtrusionDiameter, 22*mm], 
[NemaRoundExtrusionHeight, 1.8*mm], 
[NemaAxleDiameter, 5*mm], 
[NemaFrontAxleLength, 13.7*mm], 
[NemaBackAxleLength, 10*mm],
[NemaAxleFlatDepth, 0.5*mm],
[NemaAxleFlatLengthFront, 10*mm],
[NemaAxleFlatLengthBack, 9*mm]
];

Nema14 = [
[NemaModel, 14],
[NemaLengthShort, 26*mm], 
[NemaLengthMedium, 28*mm], 
[NemaLengthLong, 34*mm], 
[NemaSideSize, 35.3*mm], 
[NemaDistanceBetweenMountingHoles, 26*mm], 
[NemaMountingHoleDiameter, 3*mm], 
[NemaMountingHoleDepth, 3.5*mm], 
[NemaMountingHoleLip, -1*mm], 
[NemaMountingHoleCutoutRadius, 0*mm], 
[NemaEdgeRoundingRadius, 5*mm], 
[NemaRoundExtrusionDiameter, 22*mm], 
[NemaRoundExtrusionHeight, 1.9*mm], 
[NemaAxleDiameter, 5*mm], 
[NemaFrontAxleLength, 18*mm], 
[NemaBackAxleLength, 10*mm],
[NemaAxleFlatDepth, 0.5*mm],
[NemaAxleFlatLengthFront, 15*mm],
[NemaAxleFlatLengthBack, 9*mm]
];

Nema17 = [
[NemaModel, 17],
[NemaLengthShort, 33*mm],
[NemaLengthMedium, 41*mm],	// standard spec length = 40 mm
[NemaLengthLong, 47*mm],
[NemaSideSize, 42.30*mm],	// max length = 42.3 mm
[NemaDistanceBetweenMountingHoles, 31.00*mm], // standard spec length = 31 +/- 0.1 mm  
[NemaMountingHoleDiameter, 3*mm],	// M3 screws
[NemaMountingHoleDepth, 4.5*mm],	// M3 screw depth
[NemaMountingHoleLip, -1*mm], 		// disabled
[NemaMountingHoleCutoutRadius, 0*mm],	// disabled
[NemaEdgeRoundingRadius, 7*mm], 
[NemaRoundExtrusionDiameter, 22*mm],	// base diameter
[NemaRoundExtrusionHeight, 2*mm],		// base height
[NemaAxleDiameter, 5*mm], 
[NemaFrontAxleLength, 24*mm],	// this is the shaft including base height 
[NemaBackAxleLength, 15*mm],	// if dualAxis
[NemaAxleFlatDepth, 0.5*mm],
[NemaAxleFlatLengthFront, 15*mm],
[NemaAxleFlatLengthBack, 14*mm]
];

Nema23 = [
[NemaModel, 23],
[NemaLengthShort, 39*mm],
[NemaLengthMedium, 54*mm],
[NemaLengthLong, 76*mm],
[NemaSideSize, 56.4*mm], 
[NemaDistanceBetweenMountingHoles, 47.14*mm], 
[NemaMountingHoleDiameter, 4.75*mm], 
[NemaMountingHoleDepth, 5*mm], 
[NemaMountingHoleLip, 4.95*mm], 
[NemaMountingHoleCutoutRadius, 9.5*mm], 
[NemaEdgeRoundingRadius, 2.5*mm], 
[NemaRoundExtrusionDiameter, 38.10*mm], 
[NemaRoundExtrusionHeight, 1.52*mm], 
[NemaAxleDiameter, 6.36*mm], 
[NemaFrontAxleLength, 18.80*mm], 
[NemaBackAxleLength, 15.60*mm],
[NemaAxleFlatDepth, 0.5*mm],
[NemaAxleFlatLengthFront, 16*mm],
[NemaAxleFlatLengthBack, 14*mm]
];

Nema34 = [
[NemaModel, 34],
[NemaLengthShort, 66*mm],
[NemaLengthMedium, 96*mm],
[NemaLengthLong, 126*mm],
[NemaSideSize, 85*mm], 
[NemaDistanceBetweenMountingHoles, 69.58*mm], 
[NemaMountingHoleDiameter, 6.5*mm], 
[NemaMountingHoleDepth, 5.5*mm], 
[NemaMountingHoleLip, 5*mm], 
[NemaMountingHoleCutoutRadius, 17*mm], 
[NemaEdgeRoundingRadius, 3*mm], 
[NemaRoundExtrusionDiameter, 73.03*mm], 
[NemaRoundExtrusionHeight, 1.9*mm], 
[NemaAxleDiameter, 0.5*inch], 
[NemaFrontAxleLength, 37*mm], 
[NemaBackAxleLength, 34*mm],
[NemaAxleFlatDepth, 1.20*mm],
[NemaAxleFlatLengthFront, 25*mm],
[NemaAxleFlatLengthBack, 25*mm]
];



function motorWidth(model=Nema23) = lookup(NemaSideSize, model);
function motorLength(model=Nema23, size=NemaMedium) = lookup(size, model);


module motor(model=Nema23, size=NemaMedium, dualAxis=false, pos=[0,0,0], orientation = [0,0,0]) {

	length = lookup(size, model);

	echo(str("Motor: Nema",lookup(NemaModel, model),", length= ",length," mm, dual axis=",dualAxis));

	stepperBlack    = BlackPaint;
	stepperAluminum = Aluminum;

	side = lookup(NemaSideSize, model);

	echo(str("Side: ",side, " mm"));
	
	cutR = lookup(NemaMountingHoleCutoutRadius, model);
	lip = lookup(NemaMountingHoleLip, model);

	axleLengthFront = lookup(NemaFrontAxleLength, model);
	axleLengthBack = lookup(NemaBackAxleLength, model);
	axleRadius = lookup(NemaAxleDiameter, model) * 0.5;
	axleFlatDepth = lookup(NemaAxleFlatDepth, model);
	axleFlatLengthFront = lookup(NemaAxleFlatLengthFront, model);
	axleFlatLengthBack = lookup(NemaAxleFlatLengthBack, model);

	echo(str("Axle (shaft) length incl. base: ",axleLengthFront," mm"));
	
	// base
	extrSize = lookup(NemaRoundExtrusionHeight, model);
	extrRad = lookup(NemaRoundExtrusionDiameter, model) * 0.5;

	echo(str("Base height: ",extrSize," mm"));
	
	holeDepth = lookup(NemaMountingHoleDepth, model);
	holeDist = lookup(NemaDistanceBetweenMountingHoles, model) * 0.5;
	holeRadius = lookup(NemaMountingHoleDiameter, model) * 0.5;

	echo(str("Screw diameter: ", holeRadius*2, " mm, distance: ", holeDist*2, " mm, depth= ",holeDepth, " mm"));
	
	mid = side / 2;

	roundR = lookup(NemaEdgeRoundingRadius, model);
	
	translate(pos) rotate(orientation) {
		translate([-mid, -mid, 0]) // center at the middle
		difference() {          
			// cube with height that includes the base
			//color(stepperBlack) rcube(size=[side, side, length + extrSize], center = false, radius = 0.5);
			
			// 17HS4401:
			// Top: 11.85 / 10.2 mm
			// Bottom: 12.9 / 11 mm
			// Corner Diameter: 53.7 / 50.2
			top = 10.2*mm;
			bottom = 11.0*mm;
			middle = length-top-bottom;
			chamfer_radius = 5;
			tape_margin = 1;
			union() {					
				// bottom steel edge// base
				color(stepperAluminum) rbox(size=[side, side, extrSize], radius=chamfer_radius); 

				// top steel edge
				translate([0, 0, extrSize])						
				color(stepperAluminum) rbox(size=[side, side, top], radius=chamfer_radius); 
				
				// black tape
				translate([tape_margin, tape_margin, extrSize+top])
				color(stepperBlack) rbox(size=[side-2*tape_margin, side-2*tape_margin, middle], radius=chamfer_radius); 
				
				// bottom steel edge
				translate([0, 0, extrSize+top+middle])
				color(stepperAluminum) rbox(size=[side, side, bottom], radius=chamfer_radius); 
			}
			
			// Corner cutouts
			if (lip > 0) {
				translate([0,    0,    lip]) cylinder(h=length, r=cutR);
				translate([side, 0,    lip]) cylinder(h=length, r=cutR);
				translate([0,    side, lip]) cylinder(h=length, r=cutR);
				translate([side, side, lip]) cylinder(h=length, r=cutR);
			}
			
			// Bolt holes
			color(stepperAluminum, $fs=holeRadius/8) {
				translate([mid+holeDist,mid+holeDist,-1*mm]) cylinder(h=holeDepth+1*mm, r=holeRadius);
				translate([mid-holeDist,mid+holeDist,-1*mm]) cylinder(h=holeDepth+1*mm, r=holeRadius);
				translate([mid+holeDist,mid-holeDist,-1*mm]) cylinder(h=holeDepth+1*mm, r=holeRadius);
				translate([mid-holeDist,mid-holeDist,-1*mm]) cylinder(h=holeDepth+1*mm, r=holeRadius);
			} 

			// Grinded flat (i.e. base)
			// the extra 1mm added to the height is cancelled out?!
			color(stepperAluminum) {
				difference() {
					translate([-1*mm, -1*mm, -extrSize]) 
					cube(size=[side+2*mm, side+2*mm, extrSize + 1*mm]);
					translate([side/2, side/2, -extrSize - 1*mm]) 
					cylinder(h=4*mm, r=extrRad);
				}
			}
		}

		// Axle / Shaft
		translate([0, 0, extrSize-axleLengthFront]) color(stepperAluminum) 
		difference() {
			
			cylinder(h=axleLengthFront + 1*mm , r=axleRadius, $fs=axleRadius/10);

			// Flat
			if (axleFlatDepth > 0)
			translate([axleRadius - axleFlatDepth,-5*mm,-extrSize*mm -(axleLengthFront-axleFlatLengthFront)] ) cube(size=[5*mm, 10*mm, axleLengthFront]);
		}

		if (dualAxis) {
			translate([0, 0, length+extrSize]) color(stepperAluminum) 
			difference() {
				
				cylinder(h=axleLengthBack + 0*mm, r=axleRadius, $fs=axleRadius/10);

				// Flat
				if (axleFlatDepth > 0)
				translate([axleRadius - axleFlatDepth,-5*mm,(axleLengthBack-axleFlatLengthBack)]) cube(size=[5*mm, 10*mm, axleLengthBack]);
			}
		}
	}
}