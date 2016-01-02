// Hexagon Nut Holder
// Inspired/derived from:
//http://www.thingiverse.com/thing:22065
//Which is derived from:
// http://www.thingiverse.com/thing:14942
// http://www.thingiverse.com/thing:14814
//And is a drop-in replacement for:
//http://www.thingiverse.com/thing:10287


// screw/nut dimensions
// http://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_dia = 4.5;	// M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 8.0;		// M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.2; 	// M3 = 2.3 mm, M4 = 3 mm - orig. 3

// main body dimensions
body_width = 21;
gap_width = 10;
body_height = 22;
body_length = 40;

// Linear Bearing LM8UU
// 24x15mm, Inside diameter: 8mm
//linearBearing(model="LM8UU");
LM8UU_dia = 15.5; // including 0.5 margin
screw_elevation = body_height-1.5;

//mounting plate dimensions
plate_height = 6;
plate_length = body_length;
plate_width = 38;
screw_space_x = 26;
screw_space_y = 29;
lm8uu_length = 23;

module hole() {
    couplingNutWidth = 13;	// distance from flat to flat = 13mm
	couplingNutLength = 35; // length of the coupling nut = 35mm
    margin = 0.5; // margin when printing
	
    Num_Sides = 6;			// Hexagon = 6
	Nut_Flats = couplingNutWidth+margin; 	// Measure across the flats including margin
	Flats_Rad = Nut_Flats/2;
	Nut_Rad = Flats_Rad / cos(180/Num_Sides);

    // height from bottom of plate
    // 6 mm from top flat to plate
    plateMargin = 6; // originally 2 mm

  	// bushing hole	
    //translate([0,0,LM8UU_dia/2+plateMargin]) rotate([90,0,0]) cylinder(r=LM8UU_dia/2, h=body_length+0.1, center=true);
     
    // hex nut hole	
    translate([0,0,Nut_Flats/2+plateMargin]) rotate([90,0,0]) cylinder(r=Nut_Rad,h=body_length+0.1,$fn=Num_Sides, center=true);
}

module mount_plate()
{
	difference()
	{
		//bottom plate
		translate([-plate_width/2,-plate_length/2,0])
			cube([plate_width,plate_length,plate_height]);
			
	if (false) {
		//screw holes
		translate([screw_space_x/2,screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([-screw_space_x/2,screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([screw_space_x/2,-screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([-screw_space_x/2,-screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);

		//nut traps
		translate([screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height+1, $fn=6);
		translate([-screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height+1, $fn=6);
		translate([screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height+1, $fn=6);
		translate([-screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height+1, $fn=6);
	}
	}
}

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

		// nut trap surround
		translate([gap_width/2,0,screw_elevation])
			rotate([0,90,0])
				cylinder(r=nut_dia/2+2, h=body_width/2 - gap_width/2, $fn=6);

		// Screw hole surround
		translate([-gap_width/2,0,screw_elevation])
			rotate([0,-90,0])
				cylinder(r=nut_dia/2+2, h=(body_width-gap_width)/2 - nut_height, $fn=20);
	}
    
    // hole for the coupling or hexagon bolt
    hole();
    
	// top gap
	translate([0,0,20])
		cube([gap_width,body_length+0.1,20],center=true);

	// screw hole (one all the way through)
	translate([0,0,screw_elevation])
		rotate([0,90,0])
			cylinder(r=screw_dia/2, h=30, center=true, $fn=20);

	// nut trap
	translate([body_width/2-nut_height,0,screw_elevation])
		rotate([0,90,0])
			cylinder(r=nut_dia/2, h=nut_height+.01,$fn=6);

	// Screw hole
	translate([-(body_width/2-nut_height),0,screw_elevation])
		rotate([0,-90,0])
			cylinder(r=nut_dia/2, h=nut_height+.01,$fn=20);

if (true) {
		//nut traps
		translate([screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height-2, $fn=6);
		translate([-screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height+1, $fn=6);
		translate([screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height-2, $fn=6);
		translate([-screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=plate_height-2, $fn=6);

		//screw holes
		translate([screw_space_x/2,screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([-screw_space_x/2,screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([screw_space_x/2,-screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
		translate([-screw_space_x/2,-screw_space_y/2,-0.1])
			cylinder(r=screw_dia/2, h=plate_height+1, $fn=20);
}

}