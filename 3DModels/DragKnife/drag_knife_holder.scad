$fa=0.1;
$fs=0.1;
epsilon = 0.1;

/*
Abbrev.	Inner D.	Outer D.	Thickness	Notes
608		8 mm		22 mm		7 mm	A common roller skate bearing used extensively in RepRaps.
*/
bearingInnerDia = 8; 		
bearingOuterDia = 22;	// outer dimensions
bearingThickness = 7;	// thickness
bearingClearance = 0.2;	// clearance around the outer dimensions

bearingOD = bearingOuterDia + (bearingClearance*2);

height = 32;
thickness = bearingOD + 2*4;
bearingOR = bearingOD / 2;
bearingTh = bearingThickness + 1;

rscrewhole = 3 / 2;
hscrew_hole = 35;

base_diameter=19.2; // dremel holder hole opening

extramargin = 0;
Num_Sides = 6;			// Hexagon = 6
Nut_Flats = thickness+extramargin; 	// Measure across the flats including margin
Flats_Rad = Nut_Flats/2;
Nut_Rad = Flats_Rad / cos(180/Num_Sides);

width = Nut_Rad*2;

module holder() {
    opening_length = height+epsilon*2-2;
    opening_rad = 16/2;

difference() {
    union() {
    //cube([width, height, thickness]);
    
    // outer hexagon box    
    translate([width/2,height,Nut_Flats/2]) rotate([90,0,0]) cylinder(r=Nut_Rad,h=height,center = false,$fn=6);
    
            // screw holders
    for (i = [8, -8], j = [-bearingOR-2, bearingOR+2]){
    translate([width/2+j,height/2+i,thickness/2-7]) rotate([0,0,90]) cylinder(h = 14, r = rscrewhole+2, center = false,$fn=6);     
    }
     
            // base to fit in dremel holder
            translate([width/2,height,thickness/2]) rotate([-90,0,0]) cylinder(h = 16, r = base_diameter/2, center = false);         
    }
            
        // bottom hole
    translate([width/2,-epsilon,thickness/2]) rotate([-90,0,0]) cylinder(h = opening_length, r = opening_rad, center = false);
    
        // bearing 1
    
    translate([width/2,-epsilon*2+5,thickness/2]) rotate([-90,0,0]) cylinder(h = bearingTh, r = bearingOR, center = false);    
    
        // bearing 2    
    translate([width/2,-epsilon*2+5+7+bearingTh,thickness/2]) rotate([-90,0,0]) cylinder(h = bearingTh, r = bearingOR, center = false);     

            // screw holders upper
    for (i = [8, -8], j = [-bearingOR-2, bearingOR+2], k = [7, -20-7]){
    translate([width/2+j,height/2+i,thickness/2+k]) rotate([0,0,90]) cylinder(h = 20, r = rscrewhole+2, center = false,$fn=6);     
    }


        // screw holes
    for (i = [8, -8], j = [-bearingOR-2, bearingOR+2]){
    translate([width/2+j,height/2+i,0]) rotate([0,0,0]) cylinder(h = hscrew_hole, r = rscrewhole, center = false);     
    }
    
// remove everything higher than than z = top_height
translate([-epsilon,-epsilon,thickness/2]) cube([100,100,thickness/2+epsilon]);
    
}

}

holder();