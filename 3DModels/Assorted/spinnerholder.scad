
// Original
//!translate([0,0,1.5]) import("spinnerHub.stl");

outer_d = 22;
outer_h = 3;

base_d = 10;
base_h = 3; // orig 1 for a 7 mm thick bearing

hub_d = 8.1; // orig 8. OR 4.1 x 2 ?
hub_h = 4.5; // orig 4.5, perfect when the total height is 7
// 7 + 2 / 2 = 4.5
// 10 + 2 / 2 = 6
hub_gap = 0.30; // orig 0.5

//Default values
$fn=80;

difference() {
    union() {
cylinder(d = outer_d, h = outer_h);

translate([0,0,outer_h])
cylinder(d = base_d, h = base_h);

translate([0,0,outer_h+base_h])
cylinder(d = hub_d, h = hub_h);

    }

// cut away a half
translate([-hub_d/2-1,-hub_gap,outer_h+base_h+hub_h/2]) cube([hub_d+2,hub_d+2,hub_h]);

}
