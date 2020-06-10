	// variables (mm)
    $fa = 1;
    $fs = 0.4;

	centerHoleD = 5;
    screwHeadD = 10;
    screwHeadDepth = 8;
	supportOD = 32;
	supportID = 22;
    boltOD = 16;

    // groves
    wheel_radius = 9;
    tube_diameter = 3;

	support_height = 11;
	lip_thickness = 4;

	// flip and move up
	translate([0,0,support_height+lip_thickness]) rotate(a=[0,180,0]) { 
    
	difference() {
		union() {
			translate([0,0,support_height]) cylinder(r=supportOD/2, h=lip_thickness);
			cylinder(r1=supportID/2, r2=supportOD/2, h=support_height);
		}

		// the center whole small screw straight through
		translate([0,0,-1]) cylinder(r=centerHoleD/2, h=lip_thickness*2+support_height*2);
		
		// thicker place for the small screw head
		translate([0,0,screwHeadDepth-1+0.1]) cylinder(r=screwHeadD/2, h=screwHeadDepth);

		// small grove for the hexagon screw head
		translate([0,0,-0.1]) cylinder(r=boltOD/2, h=2);        

		// tube grove
		rotate_extrude(angle=360) {
			translate([wheel_radius - tube_diameter/2 + 2, support_height + tube_diameter]) circle(d=tube_diameter);    
		}        

		// the spherical groves
		for ( i = [0 : 7] ){
			rotate( i * 45, [0, 0, 1])
			translate([0, tube_diameter+7, support_height + tube_diameter]) scale([1,3,1]) sphere(r = tube_diameter/2);
		}
	}
}

