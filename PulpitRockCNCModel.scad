
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

module Nema17AndPulley() {          
    motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
	translate ([0, 0, 22-16.2]) GT2Pulley();
	
	// nema 17 inclusive pulley is 65 mm tall
	//translate([0,0,-43]) cylinder(h=65, r=6); // check height
}

module Nema17AndCoupling() {          
    motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
	translate ([0, 0, 15]) FlexibleCoupling();
	
	// nema 17 inclusive coupling is 83 mm tall
	//translate([0,0,-43]) cylinder(h=83, r=6); // check height
}

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
	
	SmoothRods();
	ThreadedRods();
}

// exploded viemdfHighSideLength
module Exploded() {
    expanded = 50;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();    
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 50;
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([0,margin,500+margin]) SideRight();    
}

module SmoothRods() {
	color(Steel) {
	
		// first bottom rod
		rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-500]) cylinder(r=8,h=500);
		
		// second bottom rod
		rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-500]) cylinder(r=8,h=500);
	}
}

module ThreadedRods() {
	color(Stainless) {
		// bottom rod
		rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-500]) cylinder(r=8,h=500);	
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

module Front() {
    color(Pine)
    {	
		difference() {
			cube(size=[mdfLength,mdfDepth,mdfWidth]);
			echo("Front dimensions in mm: ", mdfLength, mdfDepth, mdfWidth);
			
			union() {				
				// first hole
				rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8,h=mdfDepth+2);

				// second hole
				rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8,h=mdfDepth+2);

				// middle hole
				rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-mdfDepth-1]) cylinder(r=20,h=mdfDepth+2);
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
					rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=8,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2,-mdfDepth-1]) cylinder(r=14,h=mdfDepth+2);
					
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
				}
			}
		}
	}   
}

