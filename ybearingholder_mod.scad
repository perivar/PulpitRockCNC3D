// LM8UU bushing holder
// Inspired/derived from:
//http://www.thingiverse.com/thing:14942
//Which is derived from:
// http://www.thingiverse.com/thing:14814
//And is a drop-in replacement for:
//http://www.thingiverse.com/thing:10287



// screw/nut dimensions
screw_dia = 3.4;
nut_dia = 6.5;
nut_height=3;

// main body dimensions
body_width = 21;
gap_width = 10;
body_height = 22;
body_length=40;
LM8UU_dia = 15.5;
screw_elevation = body_height-1.5;

//mounting plate dimensions
plate_height = 6;
plate_length=body_length;
plate_width=36;
screw_space_x = 23.5;
screw_space_y=28;
lm8uu_length=23;

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
		mount_plate();

		//translate([-body_width/2,-body_length/2,0])
			//cube([body_width,body_length,body_height]);
		//translate([-body_width/2,(-body_length/2)+8.5,0])
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

	// bushing hole
	translate([0,0,LM8UU_dia/2+2])
		rotate([90,0,0])
			cylinder(r=LM8UU_dia/2, h=body_length+0.1, center=true);

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