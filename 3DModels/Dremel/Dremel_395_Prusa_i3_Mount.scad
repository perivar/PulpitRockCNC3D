// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
$fa=0.5;   	// default minimum facet angle
$fs=0.5; 	// default minimum facet size
//$fn = 100;

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

// screw/nut dimensions
//chttp://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_margin = 0.6;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm

   
Dremel395Mount();


module Dremel395Mount() {
    width = 56.85; 
    height = 68; 
    
    platethickness=10;  // bottom plate thickness, orig. 9 mm
    thickness=14;       // ring thickness, orig. 11 mm
    screwmountslit=3;   // slit width, orig. 3 mm
    extramargin=6;      // distance to move big ring up, orig. 6 mm
    bigextrawidth=4.5;  // extra at bottom of big ring, orig. 7 mm
    bigextraheight=14;  // height of extra bottom support width

    // outer dia for rings
    d1=width;
    d4=46.85; // 10 mm from outer and inner dia
    
    d2=29.58;
    d3=19.58; // 19.33 = originally 10.25 mm from outer to inner dia
    
    difference() {
        union() {
    //#translate([-71.575,-66,0]) import("Dremel_395_Prusa_i3_Mount.stl", convexity=5);

        // bottom plate
        cube([width,height,platethickness]);
                
        // big holder
        translate([d1/2,height,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d1/2, h=thickness+bigextrawidth, center=false);

        // big holder extend downwards
        translate([0,height-thickness-bigextrawidth,0]) cube([d1,thickness+bigextrawidth,d1/2+platethickness]);

        // big holder screw hole
        translate([d1/2,height-thickness,d1+extramargin-1]) ScrewHolder(thickness);

        // small holder
        translate([d1/2,thickness,d1/2+extramargin]) rotate([90,5.3,0]) cylinder(r=d2/2, h=thickness, center=false);
        
        // small holder extend downwards
        translate([(width-d2)/2,0,0]) cube([d2,thickness,d1/2+extramargin]);
        
        // small holder screw hole
        translate([d1/2,0,d1/2+extramargin+d2/2-2]) ScrewHolder(thickness);

        // supports for the small hole
        m=18;
        n=14;
        scale([2,1,1])
    translate([m,0,platethickness]) rotate([0,0,90]) linear_extrude(height = n, scale = 11/m) square(m, center = false);

        translate([width,0,0]) mirror([1,0,0]) 
        scale([2,1,1])
    translate([m,0,platethickness]) rotate([0,0,90]) linear_extrude(height = n, scale = 11/m) square(m, center = false);

        // supports for the big hole
        translate([0,height-thickness-bigextrawidth,platethickness]) rotate([0,-90,180]) Triangle(10,bigextraheight,12);

        translate([width,0,0]) mirror([1,0,0]) 
        translate([0,height-thickness-bigextrawidth,platethickness]) rotate([0,-90,180]) Triangle(10,bigextraheight,12);

        }
        
        // the bottom plate screw holes
        translate([28.5,33.8,-epsilon]) HolePattern(platethickness+2*epsilon);
                
        // the small hole
    translate([d1/2,thickness+3,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d3/2, h=thickness+4, center=false);
        
        // the small slit
        translate([width/2-screwmountslit/2,-2,d1/2+extramargin]) cube([screwmountslit,thickness+4,100]);
        
        // the small support slit
        gap=15;
        translate([(width-gap)/2,thickness,platethickness]) cube([gap,thickness,100]);

        // the big hole
        translate([d1/2,height+2,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d4/2, h=thickness+bigextrawidth+20, center=false);

        // the big slit
        translate([d1/2-screwmountslit/2,height-thickness-1-bigextrawidth,d1/2+extramargin]) cube([screwmountslit,thickness+bigextrawidth+2,100]);

        // big cut off top
        translate([-1,height-2*thickness,platethickness+bigextraheight]) cube([d1+2,thickness,d1]);
        
    }
}

module ScrewHolder(thickness=11) {
    
    screwmountthickness=6;
    screwmountslit=3;
    screwmountheight=11;
    totalthickness=2*screwmountthickness+screwmountslit;
    //rimthickness=5; // 5.10 and 4.96, probably means thickness of 5mm
    
    difference() {
        // screw holder
        union() {
            translate([-screwmountthickness-screwmountslit/2,0,0]) cube([totalthickness,thickness,screwmountheight]);
            
            // support for the screw holder
            //for (i = [1, -1]) {
            translate([-screwmountthickness-screwmountslit/2,thickness,-screwmountheight+6]) rotate([0,-90,90]) Triangle(5,screwmountheight+5,thickness);
            
    translate([-screwmountthickness-screwmountslit/2+15,thickness-thickness,-screwmountheight+6]) rotate([0,-90,-90]) Triangle(5,screwmountheight+5,thickness);            
            //}
        }

        // screw hole
        translate([-screwmountthickness-screwmountslit/2-epsilon,thickness/2,screwmountheight/2]) rotate([90,0,0]) rotate([0,90,0]) HexBolt();
    }
    
}

module HolePattern(screw_length = 40)
{
	holeXOffset = 12;
	holeYOffset = 12;
   
    translate([holeXOffset,holeYOffset,0])			
			HexBolt(screw_length, true);   
    translate([-holeXOffset,holeYOffset,0])			
			HexBolt(screw_length, true);
	translate([holeXOffset,-holeYOffset,0])			
			HexBolt(screw_length, true);
	translate([-holeXOffset,-holeYOffset,0])			
			HexBolt(screw_length, true);
}

module HexBolt(screw_length = 40, flip=false)
{  
    if (flip) { 
        translate([0,0,screw_length]) rotate([180,0,0]) Bolt(screw_length);
    } else {
        Bolt(screw_length);
    }
}

module Bolt(screw_length = 40) {
    union()
	{
		cylinder(h=screw_length,r=screw_dia/2,$fn=100);
        // add 10 to the height so that we can difference a bolt that is partially hidden
		translate([0,0,-20]) cylinder(h=nut_height+epsilon+20,r= nut_dia/2, $fn=6);
	}
}

module Triangle(width,height,thick)
{
    linear_extrude(height = thick, center = false, convexity = 10, twist = 0)
		polygon(points=[[0,0],[height,0],[0,width]], paths=[[0,1,2]]);
}

