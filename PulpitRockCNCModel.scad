
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

// Bearing 624zz
// diameter: 13,05 
// hole = 4 mm

// GT2 timing pulley
// hole = 5 mm
// height = 16.2 mm
// diameter = 16 mm
// height of track = 7.2 mm
// height if base = 7.7 mm
// height of top = 1.5 mm
// 20 teeth
// Arc Teeth Pitch = 2mm

// Flexible Coupling
// height = 249
// diameter = 189
// 8mm hole = 8,02 (17 mm depth)
// 5mm hole = 5,05


// 23 x 48 mm mdf
mdfDepth = 23*mm;
mdfWidth = 48*mm;
mdfLength = 500*mm;

mdfHeight = 500*mm;
mdfLength = 500*mm;
mdfDepth = 20*mm;
mdfWidth = 80*mm;
mdfHighSideLength = 150*mm;
//mdf

//Nema17AndCoupling();
//Nema17AndPulley();

//bearing(model=608);
//linearBearing(model="LM8UU");

//csk_bolt(3,14);
//mdfHighSideLengthasher(3);
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
	
	SmoothRods();
	ThreadedRods();
	
	StepperMotors();
	Bearings();
}

// exploded viemdfHighSideLength
module Exploded() {
    expanded = 50;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();   
	translate([0, 0, -expanded]) Bottom();	

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
	translate([0,0,-23]) {
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
	
		// first bottom X rod
		rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-500]) cylinder(r=8/2,h=500);
		
		// second bottom X rod
		rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-500]) cylinder(r=8/2,h=500);
				
		// low Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0, 90, 0]) cylinder(r=8/2,h=500);
		
		// high Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0, 90, 0]) cylinder(r=8/2,h=500);
		
	}
}

module ThreadedRods() {
	color(Stainless) {
	
		// X rod
		rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-500]) cylinder(r=8/2,h=500);	

		// Y rod
		translate([0,500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0, 90, 0]) cylinder(r=8/2,h=500);

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
	translate([mdfLength/2,mdfLength-23-2,mdfWidth/2]) rotate([90,90,0]) Nema17AndCoupling();	
	// check that the base is 41 mm heigh
	//translate([mdfLength/2,500+41,mdfWidth/2]) rotate([90,90,0]) cylinder(r=10, h=41);
	
	// Y axis
	translate([23+2,500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0,90,0]) Nema17AndCoupling();	
}

module Bearings() {
	color (Aluminum) {
		
		// 608 bearing X axis
		translate([mdfLength*1/2,mdfDepth/2,mdfWidth/2]) rotate([90,0,0]) bearing(model=608);
		
		// 608 bearing Y axis
		translate([500-(mdfDepth/2),500-(mdfHighSideLength/2)-mdfDepth,350]) rotate([0,90,0]) bearing(model=608);
		
		// lm8uu X axis
		translate([mdfLength*1/3,200,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,200,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*1/3,300,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");
		translate([mdfLength*2/3,300,mdfWidth/2]) rotate([90,0,0]) linearBearing(model="LM8UU");

		// lm8uu Y axis
		translate([200,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([300,500-(mdfHighSideLength/2)-mdfDepth,300]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([200,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0,90,0]) linearBearing(model="LM8UU");
		translate([300,500-(mdfHighSideLength/2)-mdfDepth,400]) rotate([0,90,0]) linearBearing(model="LM8UU");

	}	
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
		translate([0,0,-mdfDepth]) cube(size=[mdfLength,mdfHeight,mdfDepth]);
		echo("Bottom dimensions in mm: ", mdfLength, mdfHeight, mdfDepth);
	}
}
