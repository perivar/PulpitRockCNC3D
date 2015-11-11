
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

module GT2TimingPulley() {          
    motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
	translate ([0, 0, 22-16.2]) GT2Pulley();
	//translate ([0, 0, 22-8]) FlexibleCoupling();
}

GT2TimingPulley();
//FlexibleCoupling();

//bearing(model=608);
//linearBearing(model="LM8UU");

//csk_bolt(3,14);
//washer(3);
//flat_nut(3);
//bolt(4,14);
//cylinder_chamfer(8,2);
//chamfer(15,4);

//Exploded();
//Assembled();
//Parts();

// full model view
module Assembled() {
    Front();
    Back();
    SideLeft();
    SideRight();
}

// exploded view
module Exploded() {
    expanded = 30;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();    
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 5;
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([-100,margin,100+margin]) SideRight();    
}

module Front() {
    color("blue")
    {
        cube([100,10,100]);
        rotate([90, 0, 0]) translate([50,50,0]) cylinder(r=20,h=20);
    }
}

module Back() {
    color("green")
    {
        translate([0,100,0]) cube([100,10,100]);
        translate([50,100+20+10,50]) rotate([90, 0, 0]) cylinder(r=20,h=20);
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

