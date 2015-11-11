//
// Flexible Coupling by Per Ivar Nerseth
// originally based on a scad file I cannot locate again
// 2015

include <MCAD/materials.scad>
use <roundedcylinder.scad>
use <threads.scad>

// Flexible Coupling:
// height = 249
// diameter = 189
// 8mm hole = 8,02 
// 8mm hole depth = 17.1 mm
// 5mm hole = 5,05

$fn = 100;

tol = 0.05; // used for CSG (Constructive Solid Geometry operations) subtraction/ addition

no_of_nuts = 2;		// number of captive nuts required, standard = 1
nut_angle = 90;		// angle between nuts, standard = 90
nut_height = 9.5;
nut_margin = 3.0;
m3_dia = 3.2;		// 3mm screw hole diameter
8mm_depth = 17.0;	// 8mm hole depth

// https://en.wikipedia.org/wiki/Countersink
// https://en.wikipedia.org/wiki/Counterbore
// Openscad : how to do a chamfered hole https://www.youtube.com/watch?v=EuzOxNo2fe0
chamfer_ht = 0.2; 		// chamfered hole depth, standard = 0.2
chamfer_cone_ht = 1.5; 	// depth of cone used to countersink the screw holes (chamfer)

module FlexibleCoupling() {
	color(Aluminum) coupling();
}

module coupling(height=25, dia=19)
{
	5mm_depth = height - 8mm_depth;

	echo (str("Flexible coupling. Height = ",height,"; Diameter = ",dia,"; 8mm depth = ",8mm_depth," mm; 5mm depth = ", 5mm_depth));
	
	difference()
	{
		// the coupling body
		rcylinder(h=height, r1=dia/2, r2=dia/2, rt=0.2);
		
		// m5 motor shaft
		translate([0,0,-tol]) cylinder(h=height, r=5/2);
		
		// motor shaft taper bottom (chamfered hole)
		translate([0,0, -chamfer_cone_ht + chamfer_ht])
		color("red") cylinder(h=chamfer_cone_ht, r1=(5/2)+2, r2=5/2);
		
		// m8 threaded rod
		translate([0,0,height-8mm_depth]) cylinder(h=8mm_depth+tol, r=8/2);                      
		// m8 threaded rod taper top (chamfered hole)
		translate([0,0,height-chamfer_ht])
		color("red") cylinder(h=chamfer_cone_ht, r1=8/2, r2=(8/2)+2);
		
		// cuts in the coupling
		translate([0,0,height*0.3]) rotate([0,0,0]) {
			linear_extrude(height = height*0.4, convexity = 10, twist = -1750)
			square(size=dia);
		}
		
		// grub screw holes
		for(j=[1:no_of_nuts]) {		

			// bottom			
			rotate([0,90,j*nut_angle]) translate([-nut_margin,0,0]) 
			//metric_thread(diameter=m3_dia, pitch=1, length=nut_height+tol);
			cylinder(r=m3_dia/2,h=nut_height+tol);

			// bottom grub screw taper (chamfered hole)
			// NOTE! This is not perfect since the cylinder isn't bent properly			
			rotate([0,90,j*nut_angle]) translate([-nut_margin,0,9.2]) color("red") 
			cylinder(h=chamfer_cone_ht, r1=m3_dia/2, r2=(m3_dia/2)+2);				

			// top
			rotate([0,90,j*nut_angle]) translate([-height+nut_margin,0,0]) 
			//metric_thread(diameter=m3_dia, pitch=1, length=nut_height+tol);
			cylinder(r=m3_dia/2,h=nut_height+tol);

			// top grub screw taper (chamfered hole)
			// NOTE! This is not perfect since the cylinder isn't bent properly			
			rotate([0,90,j*nut_angle]) translate([-height+nut_margin,0,9.2]) color("red") 
			cylinder(h=chamfer_cone_ht, r1=m3_dia/2, r2=(m3_dia/2)+2);				
			
			// black grub screw?
		}														
	}
}

FlexibleCoupling();
