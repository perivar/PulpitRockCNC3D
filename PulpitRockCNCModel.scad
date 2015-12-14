
include <MCAD/bearing.scad>
include <MCAD/materials.scad>
include <stepper.scad>

use <linear_bearing.scad>
use <flexible_coupling.scad>
use <20-GT2-6 Timing Pulley.scad>

// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
$fa=0.5;   	// default minimum facet angle
$fs=0.5; 	// default minimum facet size

// Linear Bearing LM8UU
// 24x15mm, Inside diameter: 8mm
//linearBearing(model="LM8UU");
lm8uuLength = 24*mm;
lm8uuOutDia = 15*mm;
lm8uuInDia = 8*mm;

// 608ZZ Ball Bearing
//bearing(model=608);
608InDia = 8*mm;
608OutDia = 22*mm;
608Thickness = 7*mm;

// 23 x 48 mm wood
woodDepth = 23*mm;
woodWidth = 48*mm;
woodLength = 500*mm;

// mdf plate
mdfHeight = 500*mm;
mdfLength = 500*mm;
mdfDepth = 12.7*mm;
mdfWidth = 80*mm;
mdfHighSideLength = 200*mm;
mdfHighSideRodPos = 140*mm; // mdfHighSideLength/2

// rods
smoothRodLength = 500*mm;
threadRodLength = 500*mm;
smoothRodDia = 8*mm;
threadRodDia = 8*mm;

// Y plate dimensions
yPlateMargin = 30*mm;	// margin on the left and right side of the plate
yPlateWidth = mdfLength-2*mdfDepth-2*yPlateMargin;
yPlateHeight = (mdfLength-(2*mdfDepth))/2; // the height of the yPlate (width in Y direction)
yPlatePos = mdfLength-mdfDepth-yPlateHeight; // from mdfDepth to mdfLength-mdfDepth-yPlateHeight

// LM8UU bearings
yPlateBearingMargin = 10*mm;	// margin from end of plate in to bearing
yPlateBearingInset = -lm8uuOutDia/2;
yPlateBearingLowPos = yPlatePos+ lm8uuLength + yPlateBearingMargin;
yPlateBearingHighPos = yPlatePos + yPlateHeight - yPlateBearingMargin;

// sliding drill holder variables
slidingBackPlateLength = 80*mm;
slidingBottomPlateLength = 60*mm;			
holderHoleDiameter = 30*mm; // hole for the pen or dremmel

// Z axis and back plate
zBackPlateHeightPos = 200*mm;	// position of the zmodule compared to the rest of the CNC
zBackPlateWidth = 100*mm;		// width of the back plate
zBackPlateHeight = 250*mm;		// height of the back plate
zShortHeight = 60*mm;			// height of the short end plates
zRodMargin = 20*mm;				// margins from the sides for the smooth rod holes

// Z Position: min = mdfDepth, max = zBackPlateHeight-mdfDepth-slidingBackPlateLength
zPos = mdfDepth;

// X axis
xAxisPos = (mdfLength-zBackPlateWidth)/2; 	// position on the X axis. 
						// Min = mdfDepth. Middle = (mdfLength-zBackPlateWidth)/2
xRodLowPos = 250*mm;
xRodHighPos = 400*mm;
xRodMidPos = xRodLowPos + (xRodHighPos-xRodLowPos)/2;


// Nema17 "Screw diameter: 3 mm, distance: 31 mm, depth= 4.5 mm"
nema17HoleDist = 31.00*mm * 0.5;	// standard spec length = 31 +/- 0.1 mm  
nema17HoleRadius = 3*mm * 0.5;		// M3 screws
nema17HoleDepth = mdfDepth+1; 		// M3 screw depth
nema17Side = 42.30*mm;				// max length = 42.3 mm
nema17Mid = (nema17Side / 2);
nema17BaseHoleDia = 22*mm;			// hole big enough for nema 17 base diameter (22 mm)

stepperExtraMargin = 5*mm; 			// an additional margin to allow place for the flexible coupling

// zip-tie
zipTieHoleRadius = 3*mm * 0.5;	// M3 is enough for the zip-tie hole
zipTieHoleDepth = mdfDepth+1;	// M3 screw depth

couplingNutFastenerHoleRadius = 4*mm * 0.5;	// M4 is enough for the zip-tie hole
couplingNutFastenerHoleDepth = mdfDepth+1;	// M4 screw depth

// --------------------------------
// Choose view
// --------------------------------
Assembled();
//Exploded();
//Parts();

// full model view
module Assembled() {

	Front();
    //Back();
    SideLeft();
    SideRight();
	//Bottom();
	YPlate();

	SmoothRods();
	ThreadedRods();
	StepperMotors();
	Bearings();

	ZModule();		
}

// exploded view
module Exploded() {
    expanded = 100;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();   
	translate([0, 0, -expanded]) Bottom();		
	translate([0, 0, expanded]) YPlate();
	
	SmoothRods();
	ThreadedRods();
	Bearings();
	
	StepperMotors(exploded = expanded);
	
	ZModule(exploded = expanded);
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 50;
	
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([0,margin,500+margin]) SideRight();  
	projection() rotate([0,0,0]) translate([0,500+margin*2,margin]) Bottom();	
	projection() rotate([0,0,0]) translate([0,-700+margin,margin]) YPlate();
	
	projection() translate([-150,600,0]) ZModuleTop();
	projection() translate([-150,700,0]) ZModuleBack();
	projection() translate([-150,1000,0]) ZModuleBottom();	
	projection() translate([-300,700,0]) ZModuleSlidingBack();			
	projection() translate([-300,1000,0]) ZModuleSlidingBottom();
}

// originally from metric_fastners.scad
// modified the flat_nut module to make it right length
// M8 * 35 mm (13mm dia)
module CouplingNut(dia=8, width=13, height=35) {
	
	// When you make a hexagon, the radius is the distance from the center to the corners. 
	// To get a hexagon with a specified dimension from the center to the flats (called the apothem),
	// divide your radius by cos(180/6). 
	// This works for other polygons too if you change the 6 to whatever $fn value you're using. 
	Num_Sides = 6;		// Hexagon = 6
	Nut_Flats = width; 	// Measure across the flats
	Flats_Rad = Nut_Flats/2;
	Nut_Rad = Flats_Rad / cos(180/Num_Sides);
	center = true;	
		
	// center 
	//translate([Nut_Flats/2,0,0]) // measure that the nut radius was correct
	rotate([0,0,180/Num_Sides]) 
	difference()
		{
			cylinder(r=Nut_Rad,h=height,$fn=Num_Sides,center=center);
			translate([0,0,-1])cylinder(r=dia/2,h=height+2,center=center);
		}
}

module Nema17AndPulley() {   

	// set zero at pulley start
	translate([0,0,0]) {
		motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
		translate ([0, 0, 22-16.2]) GT2Pulley();
		
		// nema 17 inclusive pulley is 65 mm tall
		//translate([0,0,-43]) cylinder(h=65, r=6); // check height
	}
}

module Nema17AndCoupling() {          

	// set zero at coupling start
	translate([0,0,-23]) 
	{
		motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
		translate ([0, 0, 15]) FlexibleCoupling();
				
		// check that the nema 17 inclusive coupling is 83 mm tall
		//translate([0,0,-43]) cylinder(h=83, r=6); // check height
	}
	
	// check that the 8mm hole depth is correct = 17 mm
	//cylinder(h=17, r=6);
}

module SmoothRods() {
	color(Steel) {
	
		// left bottom Y rod
		rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-500]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
		
		// right bottom Y rod
		rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-500]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
				
		// low X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0, 90, 0]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
		
		// high X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0, 90, 0]) cylinder(r=smoothRodDia/2,h=smoothRodLength);		
	}
}

module ThreadedRods() {
	color(Stainless) {
	
		// Y rod
		rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-threadRodLength]) 
		cylinder(r=threadRodDia/2,h=threadRodLength);	

		// X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0, 90, 0]) 
		cylinder(r=threadRodDia/2,h=threadRodLength);
	}
}

module Bearings() {
	color (Aluminum) {
		
		// 608 bearing Y axis
		translate([mdfLength*1/2,mdfDepth/2,mdfWidth/2-stepperExtraMargin]) rotate([90,0,0]) bearing(model=608);
		
		// 608 bearing X axis
		translate([mdfLength-(mdfDepth/2),mdfLength-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0,90,0]) bearing(model=608);
		
		// LM8UU X axis (first parameter is position on the rod, last parameter is height)
		translate([xAxisPos+yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([xAxisPos+yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([xAxisPos+zBackPlateWidth-lm8uuLength-yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([xAxisPos+zBackPlateWidth-lm8uuLength-yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0,90,0]) linearBearing(model="LM8UU");
				
		// hexagon bolt X axis
		translate([xAxisPos+(zBackPlateWidth/2),500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0,90,0]) CouplingNut();
		
		
		// LM8UU Y axis (second parameter is position on the rod)
		translate([mdfLength*1/3,yPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,yPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*1/3,yPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,yPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		
		// hexagon bolt Y axis
		translate([mdfLength/2,yPlatePos+(yPlateHeight/2),mdfWidth/2-stepperExtraMargin]) rotate([90,0,0]) CouplingNut();
		
	}	
}

module SideChamfered(height, depth, mdfHighSideLengthidth) {
	difference() {
		cube([height,depth,mdfHighSideLengthidth]);
		
		union() {
			// first corner
			rotate([0, 0, 45]) translate([0,0,-1]) cube([mdfHighSideLengthidth*2, mdfHighSideLengthidth, mdfHighSideLengthidth+2]);

			// second corner
			translate([height,0,0]) rotate([0, 0, 45]) translate([0,0,-1]) cube([mdfHighSideLengthidth, mdfHighSideLengthidth*2, mdfHighSideLengthidth+2]);
		}
	}
}

module StepperMotors(exploded = 0) {

	// Y axis
	translate([mdfLength/2,mdfLength-23+exploded*2,mdfWidth/2-stepperExtraMargin]) rotate([90,90,0]) Nema17AndCoupling();	
	// check that the base is 41 mm heigh
	//translate([mdfLength/2,500+41,mdfWidth/2]) rotate([90,90,0]) cylinder(r=10, h=41);
	
	// X axis
	translate([23-exploded*2,500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0,90,0]) Nema17AndCoupling();	
}

module Nema17ScrewHoles() {
	translate([nema17Mid+nema17HoleDist,nema17Mid+nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid-nema17HoleDist,nema17Mid+nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid+nema17HoleDist,nema17Mid-nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid-nema17HoleDist,nema17Mid-nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
}

module ZipTieBearingHoles() {
	zipTieMarginSide = zipTieHoleRadius;		// margin in the bearing width direction (diameter)
	zipTieMarginLength = zipTieHoleRadius+2;	// margin in the bearing length direction

	translate([-zipTieMarginSide,zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
	
	translate([lm8uuOutDia+zipTieMarginSide,zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
	
	translate([-zipTieMarginSide,lm8uuLength-zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);

	translate([lm8uuOutDia+zipTieMarginSide,lm8uuLength-zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
}

module CouplingNutFastenerHoles() {

	// left
	translate([-13/2-couplingNutFastenerHoleRadius,0,-1]) 
	cylinder(h=couplingNutFastenerHoleDepth+1*mm, r=couplingNutFastenerHoleRadius);
	
	// right
	translate([13/2+couplingNutFastenerHoleRadius,0,-1]) 
	cylinder(h=couplingNutFastenerHoleDepth+1*mm, r=couplingNutFastenerHoleRadius);
}

module Front() {
    color(Pine)
    {	
		difference() {
			cube(size=[mdfLength,mdfDepth,mdfWidth]);
			echo("Front dimensions in mm: ", mdfLength, mdfDepth, mdfWidth);
			
			union() {				
				// first hole
				rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

				// second hole
				rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

				// middle hole
				rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-mdfDepth-1]) cylinder(r=608OutDia/2,h=mdfDepth+2);				
			}
		}
    }	
}

module Back() {
    color(Pine)
    {
		translate([0,mdfLength-mdfDepth,0]) {
			difference() {
				cube(size=[mdfLength,mdfDepth,mdfHeight]);
				echo("Back dimensions in mm: ", mdfLength, mdfDepth, mdfHeight);

				union() {				
					// first hole
					rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-mdfDepth-1]) cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);
					
					// screw holes
					translate([mdfLength/2-nema17Mid,mdfDepth,mdfWidth/2-nema17Mid-stepperExtraMargin]) rotate([90,0,0]) Nema17ScrewHoles(); 		
										
					// window
					rotate([90, 0, 0]) translate([150,250,-mdfDepth-1]) cube([200,150,mdfDepth+2]);
				}					
			}
		}
    }
}

module SideLeft() {
    color(Oak)
	{
		// mdf side
		rotate([0,0,-90]) translate([-mdfLength+mdfDepth,0,0]) 
		{
			difference() {
				cube(size=[mdfLength-(mdfDepth*2),mdfDepth,mdfHeight]);
				echo("Left Side dimensions in mm: ", mdfLength-(mdfDepth*2), mdfDepth, mdfHeight, mdfWidth);
				
				union() {
					// cut out a rounded cube
					translate([mdfHighSideLength,mdfDepth+1,mdfWidth]) rotate([90,0,0]) rbox(size=[mdfHeight, mdfLength, mdfDepth+2], radius=50, fn=30); 
					
					// first hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodLowPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodHighPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos-stepperExtraMargin,xRodMidPos,-mdfDepth-1]) 
					cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);			

					// screw holes
					translate([mdfHighSideRodPos-nema17Mid-stepperExtraMargin,mdfDepth,xRodMidPos-nema17Mid]) rotate([90,0,0]) Nema17ScrewHoles(); 		

				}
			}
		}
	}
}

module SideRight() {
    color(Oak)
	{	
		// mdf side
		rotate([0,0,-90]) translate([-mdfLength+mdfDepth,mdfLength-mdfDepth,0]) 
		{
			difference() {
				cube(size=[mdfLength-(2*mdfDepth),mdfDepth,mdfHeight]);
				echo("Right Side dimensions in mm: ", mdfLength-(mdfDepth*2), mdfDepth, mdfHeight, mdfWidth);

				union() {
					// cut out a rounded cube
					translate([mdfHighSideLength,mdfDepth+1,mdfWidth]) rotate([90,0,0]) rbox(size=[mdfHeight, mdfLength, mdfDepth+2], radius=50, fn=30); 
					
					// first hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodLowPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodHighPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos-stepperExtraMargin,xRodMidPos,-mdfDepth-1]) 
					cylinder(r=608OutDia/2,h=mdfDepth+2);										
				}
			}
		}
	}   
}

module Bottom() {
    color(Birch)
    {
		translate([0,0,-mdfDepth]) cube(size=[mdfLength,mdfHeight,mdfDepth]);
		echo("Bottom dimensions in mm: ", mdfLength, mdfHeight, mdfDepth);
	}
}

module YPlate() {
		
	translate([mdfDepth+yPlateMargin,yPlatePos,(mdfWidth/2)+(lm8uuOutDia/2*mm)]) 
	{ 
		// debug pointer to find middle position on Y plate
		//translate([xAxisPos+8, 0, 0]) cylinder(r=10, h=300); // mid position
	
		// plate
		color(Pine) {
			difference() {
				cube(size=[yPlateWidth,yPlateHeight,mdfDepth]);
				echo("YPlate dimensions in mm: ", yPlateWidth, yPlateHeight, mdfDepth);					
				
				union() {				
					// bearing positions
					bearingLeftPos = (mdfLength*1/3)-(mdfDepth+yPlateMargin)
					-( lm8uuOutDia / 2);
					bearingRightPos = (mdfLength*2/3)-(mdfDepth+yPlateMargin)
					-( lm8uuOutDia / 2);				
					
					threadedRodMidPos = (mdfLength*1/2)-(mdfDepth+yPlateMargin);
									
					// cut out room for the zip-ties
					// top bearings zip-tie holes
					translate([bearingLeftPos,yPlateBearingMargin,0]) ZipTieBearingHoles();
					
					translate([bearingRightPos,yPlateBearingMargin,0]) ZipTieBearingHoles();

					// bottom bearings zip-tie holes
					translate([bearingLeftPos,yPlateHeight-yPlateBearingMargin-lm8uuLength,0]) ZipTieBearingHoles();
					
					translate([bearingRightPos,yPlateHeight-yPlateBearingMargin-lm8uuLength,0]) ZipTieBearingHoles();
			
					// cut out room for the Coupling Nut fastener screw
					translate([threadedRodMidPos,yPlateHeight/2, 0]) CouplingNutFastenerHoles();
				}
			}
		}
				
	}			
}

module ZModuleBack() {

	difference() {	
		// back plate
		cube(size=[zBackPlateWidth,zBackPlateHeight,mdfDepth]);
		echo("ZModule back plate dimensions in mm: ", zBackPlateWidth, zBackPlateHeight, mdfDepth);
		
		// cut out room for the zip-ties
		// top bearings zip-tie holes
		translate([yPlateBearingMargin+lm8uuLength,xRodLowPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();
	
		translate([yPlateBearingMargin+lm8uuLength,xRodHighPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();

		// bottom bearings zip-tie holes
		translate([zBackPlateWidth-yPlateBearingMargin,xRodLowPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();
		
		translate([zBackPlateWidth-yPlateBearingMargin,xRodHighPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();

		// cut out room for the Coupling Nut fastener screw
		translate([zBackPlateWidth/2,xRodMidPos-zBackPlateHeightPos,0]) rotate([0,0,90]) CouplingNutFastenerHoles();
	}
}

// top plate with motor fastener
module ZModuleTop() {
	difference() {			
		cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
		echo("ZModule short plate dimensions in mm: ", zBackPlateWidth, zShortHeight, mdfDepth);								
		// first hole
		translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

		// second hole
		translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

		// middle hole
		translate([zBackPlateWidth/2,zShortHeight/2+stepperExtraMargin,-1]) cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);

		// screw holes
		translate([zBackPlateWidth/2-nema17Mid,zShortHeight/2-nema17Mid+stepperExtraMargin,0]) Nema17ScrewHoles(); 		
	}
}

module ZModuleBottom() {
	difference() {			
		cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
		
		// first hole
		translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

		// second hole
		translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

		// middle hole
		translate([zBackPlateWidth/2,zShortHeight/2+stepperExtraMargin,-1]) cylinder(r=608OutDia/2,h=mdfDepth+2);																			
	}
}

// sliding back plate
module ZModuleSlidingBack() {
	difference() {
		cube(size=[zBackPlateWidth,slidingBackPlateLength,mdfDepth]);
		
		// TODO cut out holes for the zip-ties that will hold the bearings
		// #ZipTieBearingHoles();
	}
}

module ZModuleSlidingBottom() {
	difference() {					
		// bottom plate
		translate([0,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-slidingBottomPlateLength,zPos]) 
		cube(size=[zBackPlateWidth,slidingBottomPlateLength,mdfDepth]);
		
		// hole for the pen or dremmel
		translate([zBackPlateWidth/2,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-(slidingBottomPlateLength/2),zPos-1]) cylinder(r=holderHoleDiameter/2,h=mdfDepth+2);
	}
}

module ZModule(exploded = 0) {
					
	translate([xAxisPos,500-(mdfHighSideRodPos)-mdfDepth-lm8uuOutDia/2*mm-exploded,zBackPlateHeightPos]) 
	{
		color(Oak) 
		{			
			// back plate
			rotate([90,0,0]) ZModuleBack();
			
			// top plate with motor fastener
			translate([0,-(zShortHeight+mdfDepth)-exploded,zBackPlateHeight-mdfDepth]) ZModuleTop();
			
			// bottom plate
			translate([0,-(zShortHeight+mdfDepth)-exploded,0]) ZModuleBottom();
		}		
			
		// 608 bearing Z axis
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,mdfDepth/2-608Thickness/2]) bearing(model=608);
						
		// stepper motor at the top with coupling
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)-exploded+stepperExtraMargin,-2+zBackPlateHeight-23+exploded]) rotate([180,0,0]) Nema17AndCoupling();	
			
		// sliding drill holder
		color (Pine) { 			
			// back plate
			translate([0,-mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-exploded*2,zPos+exploded]) 
			rotate([90,0,0]) 
			ZModuleSlidingBack();
			
			translate([0,-exploded*2,0]) ZModuleSlidingBottom();
		}
		
		// Rods
		zRodLength = zBackPlateHeight; // smoothRodLength;
		color(Steel) {
			// left Z rod
			translate([zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
			
			// right Z rod
			translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
		}
		
		color(Stainless) {
			// Z threaded rod
			translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,0]) cylinder(r=threadRodDia/2,h=zRodLength);
		}

		// LM8UU bearings
		// From min: mdfDepth 
		// To max: 	 zBackPlateHeight-mdfDepth-lm8uuLength
		slidingBearingMargin = 5;
		slidingBearingLowPos = zPos+slidingBearingMargin;
		slidingBearingHighPos = slidingBearingLowPos + slidingBackPlateLength - lm8uuLength - 2 *slidingBearingMargin;
		
		// LM8UU on left rod (third parameter is position on the rod)
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");

		// LM8UU on right rod (third parameter is position on the rod)
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");		
		
		// hexagon bolt Y axis
		color (Aluminum) translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,zPos+(slidingBackPlateLength/2)]) CouplingNut();
	}
}
