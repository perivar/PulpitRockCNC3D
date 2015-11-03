
// GT2 timing pulley
// hole = 5 mm
// height = 16.2 mm
// diameter = 16 mm
// height of track = 7.2 mm
// height if base = 7.7 mm
// height of top = 1.5 mm
// 20 teeth
// Arc Teeth Pitch = 2mm

teeth = 20; // Number of teeth
additional_tooth_width = 0; //0.2; // mm
additional_tooth_depth = 0; // mm
pulley_t_ht = 7.2;  // length of toothed part of pulley
pulley_b_ht = 7.5;  // pulley base height
pulley_b_dia = 16;  // pulley base diameter
motor_shaft = 5.2;	// NEMA17 motor shaft exact diameter = 5

retainer_ht = 1.5;	// height of retainer flange over pulley, standard = 1.5
idler_ht = 1.5;		// height of idler flange over pulley, standard = 1.5

GT2_2mm_pulley_dia = tooth_spacing (2, 0.254);

pulley ( "GT2 2mm", GT2_2mm_pulley_dia, 0.764, 1.494 );

function tooth_spacing(tooth_pitch,pitch_line_offset)
	= (2*((teeth*tooth_pitch)/(3.14159265*2)-pitch_line_offset)) ;

module pulley( belt_type , pulley_OD , tooth_depth , tooth_width )
{
	echo (str("Belt type = ",belt_type,"; Number of teeth = ",teeth,"; Pulley Outside Diameter = ",pulley_OD,"mm "));
	tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
	tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
	tooth_depth_scale = (tooth_depth + additional_tooth_depth ) / tooth_depth;
    echo (str("tooth_distance_from_centre = ", tooth_distance_from_centre));
    
	difference()
	{
        // base
        cylinder(r=pulley_b_dia/2, h=pulley_b_ht, $fn=teeth*4);

		// hole for motor shaft
        translate([0,0,-1]) 
		cylinder(r=motor_shaft/2, h=pulley_b_ht+2, $fn=motor_shaft*4);        
    }
    
	difference()
	{
        // shaft - diameter is outside diameter of pulley
        translate([0,0,pulley_b_ht]) 
        //rotate ([0,0,360/(teeth*4)]) 
		cylinder(r=pulley_OD/2, h=pulley_t_ht, $fn=teeth*4);
	
		// teeth - cut out of shaft
		for(i=[1:teeth]) 
            rotate([0,0,i*(360/teeth)])
            translate([0,-tooth_distance_from_centre,pulley_b_ht -1]) 
            //scale ([ tooth_width_scale , tooth_depth_scale , 1 ]) 
            GT2_2mm();
                
		// hole for motor shaft
		translate([0,0,-1]) cylinder(r=motor_shaft/2, h=pulley_b_ht + pulley_t_ht + retainer_ht + 2, $fn=motor_shaft*4);        
	}    
    
        // belt retainer / idler
        translate ([0,0,pulley_b_ht + pulley_t_ht])
        cylinder(r=pulley_b_dia/2, h=retainer_ht, $fn=teeth*4);        
}

module GT2_2mm()
	{
	linear_extrude(height=pulley_t_ht+2) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
	}