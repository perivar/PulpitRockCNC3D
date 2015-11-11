// Most of this is based on the 
// Parametric Pulley with multiple belt profiles
// by droftarts January 2012
// Changed into a standard 20 tooth timing pulley
// by Per Ivar Nerseth, Nov 2015

include <MCAD/materials.scad>
use <roundedcylinder.scad>

// GT2 timing pulley
// hole = 5 mm
// height = 16.2 mm
// diameter = 16 mm
// thread diameter: 12.12 mm
// height of track = 7.23 (7.23) mm
// height if base = 7.7 (7.62) mm
// height of top = 1.35 mm
// 20 teeth
// Arc Teeth Pitch = 2mm
// 2.35 width inner circle 

$fn = 100;

tol = 0.05; // used for CSG (Constructive Solid Geometry operations) subtraction/ addition

teeth = 20; // Number of teeth
additional_tooth_width = 0.2; // mm
additional_tooth_depth = 0; // mm
pulley_t_ht = 7.23;  // length of toothed part of pulley
pulley_b_ht = 7.62;  // pulley base height
pulley_b_dia = 16;  // pulley base diameter
motor_shaft = 5.2;	// NEMA17 motor shaft exact diameter = 5
retainer_ht = 1.35;	// height of retainer flange over pulley, standard = 1.5
m3_dia = 3.2;		// 3mm hole diameter
no_of_nuts = 2;		// number of captive nuts required, standard = 1
nut_angle = 90;		// angle between nuts, standard = 90
ridge_ht = 0.2;		// small ridge at the top and bottom, height in mm
ridge_w = 0.2;		// small ridge at the top and botom, width in mm
ridge_dia = 5;		// small ridge at the top and botom, diameter in mm

// https://en.wikipedia.org/wiki/Countersink
// https://en.wikipedia.org/wiki/Counterbore
// Openscad : how to do a chamfered hole https://www.youtube.com/watch?v=EuzOxNo2fe0
chamfer_ht = 0.2; 		// chamfered hole depth, standard = 0.2
chamfer_cone_ht = 1.5; 	// depth of cone used to countersink the screw holes (chamfer)

// Calculated values
nut_elevation = pulley_b_ht/2;
GT2_2mm_pulley_dia = tooth_spacing(2, 0.254);

function tooth_spacing(tooth_pitch,pitch_line_offset)
= (2*((teeth*tooth_pitch)/(3.14159265*2)-pitch_line_offset)) ;


module GT2Pulley() {
	color(Aluminum) pulley("GT2 2mm", GT2_2mm_pulley_dia, 0.764, 1.494);
}

module pulley( belt_type , pulley_OD , tooth_depth , tooth_width )
{
	echo (str("Pulley: Belt type = ",belt_type,"; Number of teeth = ",teeth,"; Pulley Outside Diameter = ",pulley_OD," mm "));
	tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
	//echo (str("tooth_distance_from_centre = ", tooth_distance_from_centre));
	
	difference()
	{
		union()
		{			
			// base
			rcylinder(r1=pulley_b_dia/2, r2=pulley_b_dia/2, h=pulley_b_ht, rt=chamfer_ht);
			
			difference()
			{
				// shaft - diameter is outside diameter of pulley
				translate([0,0,pulley_b_ht]) 
				cylinder(r=pulley_OD/2, h=pulley_t_ht); // , $fn=teeth*4
				
				// teeth - cut out of shaft
				for(i=[1:teeth])
				{				
					rotate([0,0,i*(360/teeth)])
					translate([0,-tooth_distance_from_centre,pulley_b_ht-1]) 
					GT2_2mm();		
				}
			}

			// belt retainer / idler
			translate ([0,0,pulley_b_ht + pulley_t_ht])
			rcylinder(r1=pulley_b_dia/2, r2=pulley_b_dia/2, h=retainer_ht, rt=chamfer_ht);
		}

		// hole for motor shaft
		translate([0,0,-tol])
		cylinder(r=motor_shaft/2, h=pulley_b_ht + pulley_t_ht + retainer_ht + 2*tol);

		// motor shaft taper top (chamfered hole)
		translate([0,0,pulley_b_ht + pulley_t_ht + retainer_ht - chamfer_ht])
		color("red") cylinder(h=chamfer_cone_ht, r1=motor_shaft/2, r2=(motor_shaft/2)+2);

		// motor shaft taper bottom (chamfered hole)
		translate([0,0, -chamfer_cone_ht + chamfer_ht])
		color("red") cylinder(h=chamfer_cone_ht, r1=(motor_shaft/2)+2, r2=motor_shaft/2);
		
		// small ridge at the top
		color ("green") rotate_extrude()
		translate([ridge_dia, pulley_b_ht + pulley_t_ht + retainer_ht - 2*tol - ridge_ht, 0])
        square([ridge_w,2*ridge_ht]);

		// small ridge at the bottom
		color ("green") rotate_extrude()
		translate([ridge_dia, -ridge_ht - 2*tol, 0])
        square([ridge_w,2*ridge_ht]);
		
		// grub screw holes
		for(j=[1:no_of_nuts]) {
			rotate([0,0,j*nut_angle]) translate([0,0,nut_elevation]) rotate([0,90,0])
			//metric_thread(diameter=m3_dia, pitch=1, length=pulley_b_dia/2+tol);
			cylinder(r=m3_dia/2,h=pulley_b_dia/2+tol);
						
			// grub screw taper (chamfered hole)
			// NOTE! This is not perfect since the cylinder isn't bent properly
			rotate([0,0,j*nut_angle]) translate([pulley_b_ht,0,nut_elevation]) rotate([0,90,0]) 
			color("red") cylinder(h=chamfer_cone_ht, r1=m3_dia/2, r2=(m3_dia/2)+2);
		}			
	}	
}

module GT2_2mm()
{
	linear_extrude(height=pulley_t_ht+2) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
}

GT2Pulley();

