
include <MCAD/stepper.scad>
include <MCAD/bearing.scad>
include <MCAD/metric_fastners.scad>
include <MCAD/nuts_and_bolts.scad>
include <MCAD/materials.scad>

use <linear_bearing.scad>
use <flexible_coupling.scad>

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

// Flexible Coupling
// height = 249
// diameter = 189
// 8mm hole = 8,02 (17 mm depth)
// 5mm hole = 5,05

module GT2TimingPulley() {          
    rotate([180,0,0]) motor(Nema17);
    color("silver") rotate([0,-90,0]) import("GT2_20tooth.stl");
}

//GT2TimingPulley();
coupling();

//bearing(model=608);
//linearBearing(model="LM8UU");
//color_demo();

//csk_bolt(3,14);
//washer(3);
//flat_nut(3);
//bolt(4,14);
//cylinder_chamfer(8,1);
//chamfer(10,2);

//Exploded();
//Assembled();
//Parts();
//test_ball_groove2();

//test_auger();
//test_ball_groove();
//test_ball_groove2();
//test_ball_screw();

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

