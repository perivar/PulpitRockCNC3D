 epsilon = 0.1;
 //DrillMotorMountBack();

// x is width
// d is hole dimension
// z is height
// wall_w is mount wall width
// wall_t is mount wall thickness
module DrillMotorMountBack(x = 40, d = 30, z = 20, wall_w = 70, wall_t = 5)
{
	difference()
	{
		union()
		{
			// body mount
			translate([0,x/4,z/2])
				cube([x,x/2,z],center=true);
			
            hull() 
            {
                translate([0,0,z/2])
				cylinder(r=x/2,h=z, center=true, $fn=100);

			// mounting tab
			translate([0,x/2+wall_t/2,z/2])
				cube([wall_w,wall_t,z],center=true);
  
                }
		}

		// through hole
		translate([0,0,z/2])
			cylinder(r=d/2,h=z+2*epsilon, center=true, $fn=100);


		// mounting holes on tabs
		translate([x/2+(wall_w-x)/4,x/2+wall_t/2,(z-wall_t)/2+wall_t]) rotate([90,0,0])
			cylinder(r=3,h=wall_t+2*epsilon, center=true);
		
        translate([-x/2-(wall_w-x)/4,x/2+wall_t/2,(z-wall_t)/2+wall_t]) rotate([90,0,0])
			cylinder(r=3,h=wall_t+2*epsilon, center=true);

        
        // cut away excess to make corners
        translate([x/2,-x/2,wall_t]) 
        cube([(wall_w-x)/2, x, z]);


        translate([-x/2-(wall_w-x)/2,-x/2,wall_t]) 
        cube([(wall_w-x)/2, x, z]);

	}
}
