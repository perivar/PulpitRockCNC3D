
include <MCAD/bearing.scad>
include <MCAD/metric_fastners.scad> // mdfHighSideLengthasher
include <MCAD/materials.scad>
include <stepper.scad>

use <linear_bearing.scad>
use <flexible_coupling.scad>
use <20-GT2-6 Timing Pulley.scad>

// use $fa=1 and $fs=1.5 during design phase
// and 0.5 mdfHighSideLengthhen done
$fa=1;   // default minimum facet angle
$fs=1.5; // default minimum facet size

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
mdfHighSideLength = 150*mm;

// rods
smoothRodLength = 500*mm;
threadRodLength = 500*mm;

// X plate dimensions
xPlateMargin = 20;	// margin on the left and right side of the plate
xPlateWidth = mdfLength-2*mdfDepth-2*xPlateMargin;
xPlateHeight = (mdfLength-(2*mdfDepth))/2; // the height of the xPlate (width in Y direction)
xPlatePos = mdfLength-mdfDepth-xPlateHeight; // from mdfDepth to mdfLength-mdfDepth-xPlateHeight

// LM8UU bearings
xPlateBearingMargin = 10;
xPlateBearingInset = -lm8uuOutDia/2;//-5;
xPlateBearingLowPos = xPlatePos+ lm8uuLength + xPlateBearingMargin;
xPlateBearingHighPos = xPlatePos + xPlateHeight - xPlateBearingMargin;

//Nema17AndCoupling();
//Nema17AndPulley();

//csk_bolt(3,14);
//flat_nut(3);
//bolt(4,14);
//cylinder_chamfer(8,2);
//chamfer(15,4);

// Normal ViemdfHighSideLengths
Assembled();
//Exploded();
//Parts();

// full model viemdfHighSideLength
module Assembled() {
	Front();
    Back();
    SideLeft();
    SideRight();
	Bottom();
	
	XPlate();

	SmoothRods();
	ThreadedRods();
	
	StepperMotors();
	Bearings();

	ZModule();	
}

// exploded viemdfHighSideLength
module Exploded() {
    expanded = 100;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();   
	translate([0, 0, -expanded]) Bottom();	
	
	translate([0, 0, expanded]) XPlate();
	
	SmoothRods();
	ThreadedRods();
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 50;
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([0,margin,500+margin]) SideRight();    
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
	
		// left bottom X rod
		rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-500]) cylinder(r=8/2,h=smoothRodLength);
		
		// right bottom X rod
		rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-500]) cylinder(r=8/2,h=smoothRodLength);
				
		// low Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0, 90, 0]) cylinder(r=8/2,h=smoothRodLength);
		
		// high Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0, 90, 0]) cylinder(r=8/2,h=smoothRodLength);		
	}
}

module ThreadedRods() {
	color(Stainless) {
	
		// X rod
		rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-500]) 
		cylinder(r=8/2,h=threadRodLength);	

		// Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0, 90, 0]) 
		cylinder(r=8/2,h=threadRodLength);
	}
}

module Bearings() {
	color (Aluminum) {
		
		// 608 bearing X axis
		translate([mdfLength*1/2,mdfDepth/2,mdfWidth/2]) rotate([90,0,0]) bearing(model=608);
		
		// 608 bearing Y axis
		translate([mdfLength-(mdfDepth/2),mdfLength-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0,90,0]) bearing(model=608);
		
		// LM8UU Y axis (first parameter is position on the rod, last parameter is height)
		posAdd = 50;
		translate([mdfLength*1/3-lm8uuLength/2+posAdd,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([mdfLength*1/3-lm8uuLength/2+posAdd,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3-lm8uuLength/2-posAdd,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3-lm8uuLength/2-posAdd,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0,90,0]) linearBearing(model="LM8UU");
				
		// hexagon bolt Y axis
		translate([mdfLength/2,500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0,90,0]) flat_nut(8);
		
		
		// LM8UU X axis (second parameter is position on the rod)
		translate([mdfLength*1/3,xPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,xPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*1/3,xPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,xPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		
		// hexagon bolt X axis
		translate([mdfLength/2,xPlatePos+(xPlateHeight/2),mdfWidth/2]) rotate([90,90,0]) flat_nut(8);
		
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

module StepperMotors() {

	// X axis
	translate([mdfLength/2,mdfLength-23,mdfWidth/2]) rotate([90,90,0]) Nema17AndCoupling();	
	// check that the base is 41 mm heigh
	//translate([mdfLength/2,500+41,mdfWidth/2]) rotate([90,90,0]) cylinder(r=10, h=41);
	
	// Y axis
	translate([23,500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0,90,0]) Nema17AndCoupling();	
}

module Front() {
    color(Pine)
    {	
		difference() {
			cube(size=[mdfLength,mdfDepth,mdfWidth]);
			echo("Front dimensions in mm: ", mdfLength, mdfDepth, mdfWidth);
			
			union() {				
				// first hole
				rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8/2,h=mdfDepth+2);

				// second hole
				rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8/2,h=mdfDepth+2);

				// middle hole
				rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-mdfDepth-1]) cylinder(r=22/2,h=mdfDepth+2);				
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
					rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-mdfDepth-1]) cylinder(r=24/2,h=mdfDepth+2);
					
					// window
					rotate([90, 0, 0]) translate([150,300,-mdfDepth-1]) cube([200,100,mdfDepth+2]);
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
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,300,-mdfDepth-1])  cylinder(r=8/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,400,-mdfDepth-1])  cylinder(r=8/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,350,-mdfDepth-1]) 
					cylinder(r=24/2,h=mdfDepth+2);										
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
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,300,-mdfDepth-1])  cylinder(r=8/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,400,-mdfDepth-1])  cylinder(r=8/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideLength/2,350,-mdfDepth-1]) 
					cylinder(r=22/2,h=mdfDepth+2);										
				}
			}
		}
	}   
}

module Bottom() {
    color(Birch)
    {
		//translate([0,0,-mdfDepth]) cube(size=[mdfLength,mdfHeight,mdfDepth]);
		echo("Bottom dimensions in mm: ", mdfLength, mdfHeight, mdfDepth);
	}
}

module XPlate() {

	xPlateCutOutBearingHeight = 30;
	xPlateCutOutBearingWidth = 40;
		
	translate([mdfDepth+xPlateMargin,xPlatePos,(mdfWidth/2)+(lm8uuOutDia/2*mm)]) 
	{ 
		// plate
		color(Pine) {
			difference() {
				cube(size=[xPlateWidth,xPlateHeight,mdfDepth]);
				echo("XPlate dimensions in mm: ", xPlateWidth, xPlateHeight, mdfDepth);					
				
				union() {
					// cut out place for the flexible coupling
					translate([xPlateWidth/2-xPlateCutOutBearingWidth/2,xPlateHeight-xPlateCutOutBearingHeight,-1]) 
					cube(size=[xPlateCutOutBearingWidth,xPlateCutOutBearingHeight+2,mdfDepth+2]);
				
					// and cut out room for the bearings
					bearingInsetFixPos = 11.2;
					bearingInsetWidth = 10;
					bearingInsetHeight = lm8uuLength;
					bearingInsetLeftPos = xPlateWidth*1/3-bearingInsetWidth/2-bearingInsetFixPos;
					bearingInsetRightPos = xPlateWidth*2/3-bearingInsetWidth/2+bearingInsetFixPos;
					
					translate([bearingInsetLeftPos,xPlateBearingMargin,-1])
					cube(size=[bearingInsetWidth,bearingInsetHeight,mdfDepth+2]);

					translate([bearingInsetRightPos,xPlateBearingMargin,-1])
					cube(size=[bearingInsetWidth,bearingInsetHeight,mdfDepth+2]);

					translate([bearingInsetLeftPos,xPlateHeight-bearingInsetHeight-xPlateBearingMargin,-1])
					cube(size=[bearingInsetWidth,bearingInsetHeight,mdfDepth+2]);
					
					translate([bearingInsetRightPos,xPlateHeight-bearingInsetHeight-xPlateBearingMargin,-1])
					cube(size=[bearingInsetWidth,bearingInsetHeight,mdfDepth+2]);
					
					// and cut room for the zip-ties
					zipTieInsetWidth = 2;
					zipTieInsetHeight = 4;
					zipTieInsetMargin = 5;
					
					/*
					translate([bearingInsetLeftPos+bearingInsetWidth+zipTieInsetMargin,xPlateBearingMargin+zipTieInsetMargin,-1])
					cube(size=[zipTieInsetWidth,zipTieInsetHeight,mdfDepth+2]);

					translate([bearingInsetLeftPos+bearingInsetWidth+zipTieInsetMargin,
					bearingInsetHeight,-1])
					cube(size=[zipTieInsetWidth,zipTieInsetHeight,mdfDepth+2]);

					for(pos1 = [], pos2 = []) {
					
					}
					*/
				}
			}
		}
				
	}			
}

module ZModule() {

	zBackPlateHeightPos = 150;	// position of the zmodule compared to the rest of the CNC
	zBackPlateWidth = 100;		// width of the back plate
	zBackPlateHeight = 250;		// height of the back plate
	zShortHeight = 50;			// height of the short end plates
	zRodMargin = 20;			// margins from the sides for the smooth rod holes
	
	// sliding drill holder variables
	slidingBackPlateLength = 80;
	slidingBottomPlateLength = 60;			
	holderHoleDiameter = 30; // hole for the pen or dremmel
	
	// Position: min = mdfDepth, max = zBackPlateHeight-mdfDepth-slidingBackPlateLength
	slidingPos = 100;
			
	translate([(mdfLength-zBackPlateWidth)/2,500-(mdfHighSideLength/2)-mdfDepth-lm8uuOutDia/2*mm,zBackPlateHeightPos]) 
	{
		color(Oak) 
		{			
			rotate([90,0,0]) cube(size=[zBackPlateWidth,zBackPlateHeight,mdfDepth]);
			echo("ZModule back plate dimensions in mm: ", zBackPlateWidth, zBackPlateHeight, mdfDepth);
			
			// top plate with motor fastener
			translate([0,-(zShortHeight+mdfDepth),zBackPlateHeight-mdfDepth]) {
				difference() {			
					cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
					echo("ZModule short plate dimensions in mm: ", zBackPlateWidth, zShortHeight, mdfDepth);								
					// first hole
					translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=8/2,h=mdfDepth+2);

					// second hole
					translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=8/2,h=mdfDepth+2);

					// middle hole
					translate([zBackPlateWidth/2,zShortHeight/2,-1]) cylinder(r=24/2,h=mdfDepth+2);

					// screw holes
					// "Screw diameter: 3 mm, distance: 31 mm, depth= 4.5 mm"
				}
			}
			
			// bottom plate
			translate([0,-(zShortHeight+mdfDepth),0]) {
				difference() {			
					cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
					
					// first hole
					translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=8/2,h=mdfDepth+2);

					// second hole
					translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=8/2,h=mdfDepth+2);

					// middle hole
					translate([zBackPlateWidth/2,zShortHeight/2,-1]) cylinder(r=22/2,h=mdfDepth+2);																			
				}
			}
		}		
			
		// 608 bearing Z axis
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),mdfDepth/2-608Thickness/2]) bearing(model=608);
						
		// stepper motor at the top with coupling
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),-2+zBackPlateHeight-23]) rotate([180,0,0]) Nema17AndCoupling();	
			
		// sliding drill holder
		color (Pine) { 			
			translate([0,-mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2),slidingPos]) rotate([90,0,0]) cube(size=[zBackPlateWidth,slidingBackPlateLength,mdfDepth]);
			difference() {
				// bottom plate
				translate([0,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-slidingBottomPlateLength,slidingPos]) cube(size=[zBackPlateWidth,slidingBottomPlateLength,mdfDepth]);
				
				// hole for the pen or dremmel
				translate([zBackPlateWidth/2,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-(slidingBottomPlateLength/2),slidingPos-1]) cylinder(r=holderHoleDiameter/2,h=mdfDepth+2);				
			}
		}
		
		// Rods
		zRodLength = zBackPlateHeight; // smoothRodLength;
		color(Steel) {
			// left Z rod
			translate([zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=8/2,h=zRodLength);
			
			// right Z rod
			translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=8/2,h=zRodLength);
		}
		
		color(Stainless) {
			// Z rod
			translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),0]) cylinder(r=8/2,h=zRodLength);
		}

		// LM8UU bearings
		// From min: mdfDepth 
		// To max: 	 zBackPlateHeight-mdfDepth-lm8uuLength
		slidingBearingMargin = 5;
		slidingBearingLowPos = slidingPos+slidingBearingMargin;
		slidingBearingHighPos = slidingBearingLowPos + slidingBackPlateLength - lm8uuLength - 2 *slidingBearingMargin;
		
		// LM8UU on left rod (third parameter is position on the rod)
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");

		// LM8UU on right rod (third parameter is position on the rod)
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");		
		
		// hexagon bolt X axis
		color (Aluminum) translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),slidingPos+(slidingBackPlateLength/2)]) flat_nut(8);
	}
}
