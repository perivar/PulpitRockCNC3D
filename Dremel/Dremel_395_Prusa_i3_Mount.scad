// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
//$fa=0.5;   	// default minimum facet angle
//$fs=0.5; 	// default minimum facet size
//$fn = 24;

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

Dremel395Mount();


module Dremel395Mount() {
    width = 56.85; 
    height = 68; 
    platethickness = 9; // bottom plate
    thickness=11; // 11
    screwmountslit=3;
    bigextra=7; // extra at bottom of big ring

    // outer dia for rings
    extramargin=6; // extra margin up
    d1=width;
    d4=46.85; //10
    
    d2=29.58;
    d3=19.58; //19.33 = 10.25
    
    difference() {
        union() {
    //#translate([-71.575,-66,0]) import("Dremel_395_Prusa_i3_Mount.stl", convexity=5);

    // bottom plate
    cube([width,height,platethickness]);
            
            // big holder
            translate([d1/2,height,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d1/2, h=thickness+bigextra, center=false, $fn = 24);

            // big holder extend downwards
            translate([0,height-thickness-bigextra,0]) cube([d1,thickness+bigextra,d1/2+platethickness]);

            // big holder screw hole
            translate([d1/2,height-thickness,d1+platethickness-5])
        ScrewHolder();


            // small holder
            translate([d1/2,thickness,d1/2+extramargin]) rotate([90,5.3,0]) cylinder(r=d2/2, h=thickness, center=false, $fn = 24);
            
            // small holder extend downwards
            translate([(width-d2)/2,0,0]) cube([d2,thickness,d1/2+extramargin]);
            
            // small holder screw hole
            translate([d1/2,0,d1/2+extramargin+d2/2-2.177])
        ScrewHolder();

            // small holder support
            //translate([width/2,-10,platethickness]) rotate([0,0,45]) cylinder(width/4,40,20,$fn=4);
            
            //translate([width/2,-3.3,platethickness]) rotate([0,0,45]) cylinder(width/4,30.8,20,$fn=4);
m=18;
translate([m,0,platethickness]) rotate([0,0,90]) linear_extrude(height = 14, scale = 11/m) square(m, center = false);

/*
   hull() 
   {
    translate([14,thickness,platethickness]) rotate([90,-90,0]) Triangle(14,14,thickness);

    translate([width-14,thickness,platethickness]) rotate([90,0,0]) Triangle(14,14,thickness);
    
    translate([14,thickness,platethickness]) rotate([90,0,90]) Triangle(14,7.5,29);
   }
 */
        }
        
        // the bottom plate screw holes
        translate([28.5,33.8,-10]) ZSliderHolePattern();
        
        
        // the small hole
    translate([d1/2,thickness+3,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d3/2, h=thickness+4, center=false, $fn = 24);
        
        // the small slit
        translate([width/2-screwmountslit/2,-1,d1/2+extramargin]) cube([screwmountslit,thickness+4,100]);
        
        // the small support slit
        //gap=15;
        //translate([(width-gap)/2,11,platethickness]) cube([gap,thickness,100]);
   

        // the big hole
        translate([d1/2,height+2,d1/2+extramargin]) rotate([90,0,0]) cylinder(r=d4/2, h=thickness+10, center=false, $fn = 24);

        // the big slit
        translate([d1/2-screwmountslit/2,height-thickness-1,d1/2+extramargin]) cube([screwmountslit,thickness+2,100]);

        // big cut off top
        translate([-1,height-2*thickness,platethickness+14]) cube([d1+2,thickness,d1]);
        
        
        
    }
}

module ScrewHolder() {
    
    thickness=11;
    screwmountthickness=6;
    screwmountslit=3;
    screwmountheight=thickness;//14.18;
    //holdermarg=5.10; // and 4.96, probably 5mm
    
    difference() {
        union() {
            // screw holder left
            translate([-screwmountthickness-screwmountslit/2,0,0]) cube([screwmountthickness,thickness,screwmountheight]);

            // screw holder right
            translate([screwmountslit/2,0,0]) cube([screwmountthickness,thickness,screwmountheight]);
        }

        // screw hole
        translate([-6-1.5-epsilon,5.5,thickness/2]) rotate([90,0,0]) rotate([0,90,0]) FakeBolt();
    }
    
}

module ZSliderHolePattern(screw_length = 40)
{
    screw_margin = 0.6;
    screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
    
    //boltsize = 6; // assume 6 mm bolts to hold this to the base
    
	holeXOffset = 12;
	holeYOffset = 12;
   
    translate([holeXOffset,holeYOffset,0])			
			FakeBolt(screw_length);   
    translate([-holeXOffset,holeYOffset,0])			
			FakeBolt(screw_length);
	translate([holeXOffset,-holeYOffset,0])			
			FakeBolt(screw_length);
	translate([-holeXOffset,-holeYOffset,0])			
			FakeBolt(screw_length);
}

module FakeBolt(screw_length = 40)
{
    screw_margin = 0.7;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm - orig. 3
    
	union()
	{
		cylinder(h=screw_length,r=screw_dia/2,$fn=100);
		cylinder(h=nut_height+epsilon,r= nut_dia/2, $fn=6);
	}
}

module Triangle(width,height,thick)
{
    linear_extrude(height = thick, center = false, convexity = 10, twist = 0)
		polygon(points=[[0,0],[height,0],[0,width]], paths=[[0,1,2]]);
}

