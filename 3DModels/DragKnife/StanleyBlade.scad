// Stanley Knife Blade
// (units mm)
// 
//
//

lenCE=62;    	// Length of the cutting edge
lenBE=31.6;		// Length of back edge 
width=19;		// Width (cutting edge to back edge)
mid=lenCE/2;		// Midpoint 
rb=3.6/2;    	// Radius of recess
rdepth=3;		// Recess depth;
rfm=3/2 + rb; // Distance of middle of the recess from mid len  
bladethickness=1; // really 0.6
cut=bladethickness+4;

// optional hole in the middle for screws
holerad = 7.0/2;
holedepth = 13; // from top of blade

// Outline of the blade
module bladeOL() {
	linear_extrude(height=bladethickness)
	  polygon(points=[[0,0],[0,lenCE],[width,mid+(lenBE/2)],[width,mid-(lenBE/2)]]);
}

// Outline and Cutouts
module bladeCU(useAsDifference) {
local_rb = useAsDifference ? rb-0.3 : rb;
local_rfm = useAsDifference ? rfm : rfm;
local_holerad = useAsDifference ? holerad-0.3 : holerad;

	difference () {

		bladeOL();

    // blade holder hole 1
		translate([width-(rdepth-local_rb),mid+local_rfm,-1]) cylinder(r=local_rb,h=cut,$fn=50);
       // blade holder depth hole 1
		translate([width-(rdepth-local_rb),mid+local_rfm-local_rb,-1]) cube([width,local_rb*2,cut]);

    // blade holder hole 2
		translate([width-(rdepth-local_rb),mid-local_rfm,-1]) cylinder(r=local_rb,h=cut,$fn=50);
        // blade holder depth hole 2
		translate([width-(rdepth-local_rb),mid-local_rfm-local_rb,-1]) cube([width,local_rb*2,cut]);

    // middle hole
		translate([width-(holedepth-local_holerad),mid,-1]) cylinder(r=local_holerad,h=cut,$fn=50);
	}
}

// A sharp blade
module blade(useAsDifference) {
    
     sharpness_degrees = useAsDifference ? 14 : 10;
    
	difference() {
		translate([0,0,-bladethickness/2]) bladeCU(useAsDifference);
		rotate([0,-sharpness_degrees,0]) cube([width/2,lenCE+2,10]);
		rotate([0,sharpness_degrees,0]) translate([0,0,-10]) cube([width/2,lenCE+2,10]);
	}
}


blade(true);

// check gradient manually
//color("white") rotate([0,0,-51.34]) translate([0,0,-bladethickness/2]) cube([50,50,bladethickness]);
