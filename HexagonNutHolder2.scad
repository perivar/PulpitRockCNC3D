// Hexagon Nut Holder
// Inspired/derived from:
// http://www.thingiverse.com/thing:22065

// Which is derived from:
// http://www.thingiverse.com/thing:14942
// http://www.thingiverse.com/thing:14814
// And is a drop-in replacement for:
// http://www.thingiverse.com/thing:10287


// screw/nut dimensions
// http://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_dia = 4.5;	// M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 8.2;		// M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.2; 	// M3 = 2.3 mm, M4 = 3 mm - orig. 3

// main body dimensions
body_width = 21;
gap_width = 10;
body_height = 23;	// original height: 22 mm
body_length = 40;
epsilon = 0.1; // small tolerance used for CSG subtraction/addition

screw_elevation = body_height-1.5;

// mounting plate dimensions
plate_height = 6;
plate_length = body_length+10;
plate_width = 38;
screw_space_x = 26;
screw_space_y = 29;
lm8uu_length = plate_length;

HexagonNutHolder();

module HexagonNutHole() {
	couplingNutWidth = 13;	// distance from flat to flat = 13mm
	couplingNutLength = 35 + 1; // length of the coupling nut = 35mm + 1 mm margin
	extramargin = 0.3; // margin when printing (0.3). TODO: can be even smaller. 0.2?
	
	Num_Sides = 6;			// Hexagon = 6
	Nut_Flats = couplingNutWidth+extramargin; 	// Measure across the flats including margin
	Flats_Rad = Nut_Flats/2;
	Nut_Rad = Flats_Rad / cos(180/Num_Sides);

	// height from bottom of plate
	// 6 mm from top flat to plate
	plateMargin = 6; // originally 2 mm
	
	// hex nut hole	
	translate([0,0,Nut_Flats/2+plateMargin]) rotate([90,0,0]) cylinder(r=Nut_Rad,h=body_length+2*epsilon,$fn=Num_Sides, center=true);
}

module nut_traps(nut_height=nut_height) {
    // nut traps
    translate([screw_space_x/2,screw_space_y/2,plate_height-nut_height])
    cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
    translate([-screw_space_x/2,screw_space_y/2,plate_height-nut_height])
    cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
    translate([screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
    cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
    translate([-screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
    cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
}

module screw_holes() {
    // screw holes
    translate([screw_space_x/2,screw_space_y/2,-epsilon])
    cylinder(r=screw_dia/2, h=plate_height+epsilon, $fn=20);
    translate([-screw_space_x/2,screw_space_y/2,-epsilon])
    cylinder(r=screw_dia/2, h=plate_height+epsilon, $fn=20);
    translate([screw_space_x/2,-screw_space_y/2,-epsilon])
    cylinder(r=screw_dia/2, h=plate_height+epsilon, $fn=20);
    translate([-screw_space_x/2,-screw_space_y/2,-epsilon])
    cylinder(r=screw_dia/2, h=plate_height+epsilon, $fn=20);        
}

module mount_plate() {
	difference()
	{
		//bottom plate
		translate([-plate_width/2,-plate_length/2,0])
		cube([plate_width,plate_length,plate_height]);

		if (true) {
            nut_traps();
            screw_holes();
		}		
	}
}

module HexagonNutHolder() {
	// main body
	difference()
	{
		union()
		{
			// bottom mount plate
			mount_plate();

			// main trap
			translate([-body_width/2,-(lm8uu_length/2),0])
			cube([body_width,lm8uu_length,body_height]);
		}
		
		// hole for the coupling or hexagon bolt
		HexagonNutHole();
		
		// top gap
		translate([0,0,2.65])
		cube([15.4,body_length,20],center=true);
        
        translate([0,0,body_height-nut_height])
        nut_traps(nut_height=body_height);
	}
}

//!HexagonNutHole();