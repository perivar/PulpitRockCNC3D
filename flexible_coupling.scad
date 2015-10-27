
include <MCAD/materials.scad>

$fn = 100;

// Flexible Coupling:
// height = 249
// diameter = 189
// 8mm hole = 8,02 
// 8mm hole depth = 17 mm
// 5mm hole = 5,05

module coupling(height=25, dia=19)
{
    color(Aluminum) {
	difference()
	{
		// the coupling body
		cylinder(h=height, r=dia/2);
        
		// m5 motor shaft
		translate([0,0,-height*0.1]) cylinder(h=height, r=5/2);
        
        // m8 threaded rod
		translate([0,0,height-17]) cylinder(h=17.1, r=8/2);                      
        
        // cuts in the coupling
		translate([0,0,height*0.3]) rotate([0,0,90]) {
			linear_extrude(height = height*0.4, convexity = 10, twist = -1750)
			square(size=dia);
        }
        
        // skrew holes
        // bottom 1
        translate([-5,0,3]) rotate([0,90,0]) cylinder(r=2,h=9.5,center=true);

        // bottom 2
        translate([0,-5,3]) rotate([-90,90,0]) cylinder(r=2,h=9.5,center=true);
        
        // top 1
        translate([-5,0,height-3]) rotate([0,90,0]) cylinder(r=2,h=9.5,center=true);       			       
        // top 2
        translate([0,-5,height-3]) rotate([-90,90,0]) cylinder(r=2,h=9.5,center=true);
        
        // black screw?
        
	}
    }
}

coupling();
