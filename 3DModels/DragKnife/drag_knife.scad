$fa=0.1;
$fs=0.1;
epsilon = 0.1;

use<StanleyBlade.scad>;

//#translate([-72.3,-44.16,0]) import("DragKnife_Rotor.stl");

//translate([-11.53,-16.214,-53.785]) import("DragKnife_Rotor2.stl");


blade_rot_deg = -51.34; // rotate blade degrees

/*
Abbrev.	Inner D.	Outer D.	Thickness	Notes
608		8 mm		22 mm		7 mm	A common roller skate bearing used extensively in RepRaps.
*/

bearingInnerDia = 8; 	 // 608 bearing 	
bearingClearance = 0.1;	// clearance around the outer dimensions

top_height = bearingInnerDia-bearingClearance; // thickness of top cylinder (

bottom_rad = 5.7; // radius of the bottom support
bottom_height = 4.3; // thickness of the bottom
bottom_length = 34.8; // length of the bottom

base_rad=10/2;
fasten_rad=top_height/2;

rscrewhole = 3 / 2;
hscrew_hole = 10;

module support_bottom_holder() {
difference() {
hull() {
    // left cylinder
translate([bottom_rad,bottom_rad,0]) cylinder(h = bottom_height, r = bottom_rad, center = false);

// right cylinder
translate([bottom_length,bottom_rad,0]) cylinder(h = bottom_height, r = bottom_rad, center = false);
}

// right screw hole
translate([bottom_length,bottom_rad,-epsilon]) cylinder(h = hscrew_hole, r = rscrewhole, center = false);

// left screw hole
translate([bottom_rad,bottom_rad,-epsilon]) cylinder(h = hscrew_hole, r = rscrewhole, center = false);

}
}

module support_bottom() {

support_bottom_holder();

// side support bar
translate([bottom_rad,bottom_rad*2-2,0]) cube([6,37-5,bottom_height]);

// cross support bar
translate([bottom_rad,bottom_rad*2+5,0]) rotate([0,0,blade_rot_deg]) cube([8,30,bottom_height]);

// upper support bar
translate([10,40,0]) rotate([0,0,blade_rot_deg*2]) cube([6,25.9,bottom_height]);

// bottom support
translate([bottom_rad,bottom_rad*2-1,0]) cube([16,10,bottom_height]);

// top cube
translate([bottom_rad,bottom_rad*2+25,0]) cube([(base_rad+1.4)*2,10-5,top_height]);
}

module support_top() {
    offset_x = 12.1;
    offset_y = bottom_rad*2+25+10-5;
    base_length = 9-5;
    fasten_length = 30-5;
    
    // short top fasten cylinder
    translate([offset_x,offset_y,fasten_rad]) rotate([-90,0,0]) cylinder(h = base_length, r = base_rad, center = false);
    
    // long top fasten cylinder
    translate([offset_x,offset_y,fasten_rad]) rotate([-90,0,0]) cylinder(h = fasten_length, r = fasten_rad, center = false);   
}

module drag_knife() {
    
difference() {
    
    union() {
        support_top();
        support_bottom();
    }
    
// stanley blade
translate([56.5,29.6,4.2]) rotate([0,0,blade_rot_deg+180]) blade(true); 

// bottom remove 
    //translate([15,-epsilon,3.7]) cube([30,20,2]);
    
    // remove excess (blade hole)
    //translate([22,10,3.7]) cube([5,10,2]);

// remove everything less than z = 0
translate([-epsilon,-epsilon,-4]) cube([100,100,4]);

// remove everything higher than than z = top_height
translate([-epsilon,-epsilon,top_height]) cube([100,100,4]);
}
}


// use this to render the main holder
drag_knife();

// test to show where the center of the main cylinder is 
// related to the blade edge
//color("blue") translate([-epsilon+12.1,0,fasten_rad]) cube([fasten_rad,80,4]);

// test to show the offset from blade and center = 3,9 mm
//color("green") translate([8.1,0,fasten_rad]) cube([3.90,fasten_rad,4]);

// use this to render the holder clip
//support_bottom_holder();

// use this to render the holder clip view
//translate([0,0,bottom_height+10]) support_bottom_holder();

