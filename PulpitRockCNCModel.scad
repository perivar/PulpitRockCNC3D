
include <MCAD/stepper.scad>
include <MCAD/bearing.scad>
include <MCAD/metric_fastners.scad> // washer
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
// Arc Teeth Pitch = 2mm

// Flexible Coupling
// height = 249
// diameter = 189
// 8mm hole = 8,02 (17 mm depth)
// 5mm hole = 5,05

module GT2TimingPulley() {          
    rotate([180,0,0]) motor(Nema17);
    color("silver") rotate([0,-90,0]) import("GT2_20tooth.stl");
}

module thread(
    // the thread is extruded with a twisted linear extrusion 
	orad,  // outer diameter of thread 
	tl,    // thread length
	p)     // lead of thread
{

// radius' for the spiral
r = [orad-0/18*p, orad-1/18*p, orad-2/18*p, orad-3/18*p, orad-4/18*p, orad-5/18*p,
     orad-6/18*p, orad-7/18*p, orad-8/18*p, orad-9/18*p, orad-10/18*p, orad-11/18*p,
     orad-12/18*p, orad-13/18*p, orad-14/18*p, orad-15/18*p, orad-16/18*p, orad-17/18*p,
     orad-p];

// extrude 2d shape with twist
translate([0,0,tl/2])
linear_extrude(height = tl, convexity = 10, twist = -360.0*tl/p, center = true)
	// mirrored spiral (2d poly) -> triangular thread when extruded
	polygon([
         [ r[ 0]*cos(  0), r[ 0]*sin(  0)], [r[ 1]*cos( 10), r[ 1]*sin( 10)],
		 [ r[ 2]*cos( 20), r[ 2]*sin( 20)], [r[ 3]*cos( 30), r[ 3]*sin( 30)],
		 [ r[ 4]*cos( 40), r[ 4]*sin( 40)], [r[ 5]*cos( 50), r[ 5]*sin( 50)],
         [ r[ 6]*cos( 60), r[ 6]*sin( 60)], [r[ 7]*cos( 70), r[ 7]*sin( 70)],
		 [ r[ 8]*cos( 80), r[ 8]*sin( 80)], [r[ 9]*cos( 90), r[ 9]*sin( 90)],
		 [ r[10]*cos(100), r[10]*sin(100)], [r[11]*cos(110), r[11]*sin(110)],
		 [ r[12]*cos(120), r[12]*sin(120)], [r[13]*cos(130), r[13]*sin(130)],
		 [ r[14]*cos(140), r[14]*sin(140)], [r[15]*cos(150), r[15]*sin(150)],
		 [ r[16]*cos(160), r[16]*sin(160)], [r[17]*cos(170), r[17]*sin(170)],
		 [ r[18]*cos(180), r[18]*sin(180)], [r[17]*cos(190), r[17]*sin(190)],
		 [ r[16]*cos(200), r[16]*sin(200)], [r[15]*cos(210), r[15]*sin(210)],
		 [ r[14]*cos(220), r[14]*sin(220)], [r[13]*cos(230), r[13]*sin(230)],
		 [ r[12]*cos(240), r[12]*sin(240)], [r[11]*cos(250), r[11]*sin(250)],
		 [ r[10]*cos(260), r[10]*sin(260)], [r[ 9]*cos(270), r[ 9]*sin(270)],
		 [ r[ 8]*cos(280), r[ 8]*sin(280)], [r[ 7]*cos(290), r[ 7]*sin(290)],
		 [ r[ 6]*cos(300), r[ 6]*sin(300)], [r[ 5]*cos(310), r[ 5]*sin(310)],
		 [ r[ 4]*cos(320), r[ 4]*sin(320)], [r[ 3]*cos(330), r[ 3]*sin(330)],
		 [ r[ 2]*cos(340), r[ 2]*sin(340)], [r[ 1]*cos(350), r[ 1]*sin(350)]]);
}

l = 5.0;
orad = 3/2;
lead = 0.5;
//translate([0,0,-l]) thread(orad, l, lead);

//GT2TimingPulley();
//coupling();

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

