	// variables (mm)
    $fa = 1;
    $fs = 0.4;
    epsilon = 0.1;

	centerHoleD = 5;
    screwHeadD = 10;
    screwHeadDepth = 8;
	supportOD = 32;
	supportID = 21;
    boltOD = 16;
    boltGroveDepth = 2;

    // groves
    wheel_radius = 9;
    tube_diameter = 3;

	support_height = 10;
	lip_thickness = 4;

	// flip and move up
	translate([0,0,support_height+lip_thickness]) rotate(a=[0,180,0]) { 
    
	difference() {
		union() {
            // lip
			translate([0,0,support_height]) cylinder(r=supportOD/2, h=lip_thickness);
            // cone
			cylinder(r1=supportID/2, r2=supportOD/2, h=support_height);
		}

		// the center whole small screw straight through
		translate([0,0,-epsilon]) cylinder(r=centerHoleD/2, h=lip_thickness+support_height+2*epsilon);
		
		// thicker place for the small screw head
		translate([0,0,support_height+lip_thickness-screwHeadDepth+epsilon]) cylinder(r=screwHeadD/2, h=screwHeadDepth);

		// small grove for the hexagon screw head
		translate([0,0,-epsilon]) cylinder(r=boltOD/2, h=boltGroveDepth);        

		// tube grove
		rotate_extrude(angle=360) {
			translate([wheel_radius - tube_diameter/2 + 3, support_height + tube_diameter]) circle(d=tube_diameter);    
		}        

		// the spherical groves
		for ( i = [0 : 7] ){
			rotate( i * 45, [0, 0, 1])
			translate([0, tube_diameter+7.5, support_height + tube_diameter]) scale([1,3,1]) sphere(r = tube_diameter/2);
		}
	}
}

