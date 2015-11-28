
include <MCAD/bearing.scad>
include <MCAD/metric_fastners.scad> // washer
include <MCAD/materials.scad>
include <stepper.scad>

use <linear_bearing.scad>
use <flexible_coupling.scad>
use <20-GT2-6 Timing Pulley.scad>

// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
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

// 23 x 48 mm wood
woodDepth = 23*mm;
woodWidth = 48*mm;
woodHeight = 500*mm;


//Nema17AndCoupling();
//Nema17AndPulley();

//bearing(model=608);
//linearBearing(model="LM8UU");

//csk_bolt(3,14);
//washer(3);
//flat_nut(3);
//bolt(4,14);
//cylinder_chamfer(8,2);
//chamfer(15,4);

// Normal Views
Assembled();
//Exploded();
//Parts();

// full model view
module Assembled() {
    Front();
    Back();
    //SideLeft();
    //SideRight();
}

// exploded view
module Exploded() {
    expanded = 50;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();    
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 10;
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([-100,margin,100+margin]) SideRight();    
}

module WoodElement(height, depth, width) {
	//color(Pine)
	{
		difference() {
			cube([height,depth,width]);
			
			union() {
				// first corner
				rotate([0, 0, 45]) translate([0,0,-1]) cube([width*2, width, width+2]);

				// second corner
				translate([height,0,0]) rotate([0, 0, 45]) translate([0,0,-1]) cube([width, width*2, width+2]);
			}
		}
	}
}

module Front() {
    color(Pine)
    {
		difference() {
			WoodElement(woodHeight,woodDepth,woodWidth);
			
			union() {				
				// first hole
				rotate([90, 0, 0]) translate([woodHeight*1/3,woodWidth/2,-woodDepth-1]) cylinder(r=8,h=woodDepth+2);

				// second hole
				rotate([90, 0, 0]) translate([woodHeight*2/3,woodWidth/2,-woodDepth-1]) cylinder(r=8,h=woodDepth+2);

				// middle hole
				//rotate([90, 0, 0]) translate([woodHeight*1/2,woodWidth/2,-woodDepth-1]) cylinder(r=14,h=woodDepth+2);
			}
		}
    }
}

module Back() {
    color(Pine)
    {
		translate([0,woodDepth+500,woodWidth]) rotate([180,0,0]) {
			difference() {
				WoodElement(woodHeight,woodDepth,woodWidth);

				union() {				
					// first hole
					rotate([90, 0, 0]) translate([woodHeight*1/3,woodWidth/2,-woodDepth-1]) cylinder(r=8,h=woodDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([woodHeight*2/3,woodWidth/2,-woodDepth-1]) cylinder(r=8,h=woodDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([woodHeight*1/2,woodWidth/2,-woodDepth-1]) cylinder(r=14,h=woodDepth+2);
				}					
			}
		}
    }
}

module SideLeft() {
    color("grey") { 
        difference() {
            translate([-10,0,0]) cube([10,110,100]);
            translate([-11,50,50]) cube([20,10,10]);
        }
    }
}

module SideRight() {
    color("pink") translate([100,0,0]) cube([10,110,100]);
    
}

