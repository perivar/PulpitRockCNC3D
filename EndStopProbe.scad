//$fn=100; // comment out to avoid unresponive models
epsilon=0.1;

// distance switch opening
opening_w = 14;
opening_h = 12;

// hole distance
hole_distance = 19;
hole_dia = 3.5;

plate_thickness = 6; 
switch_holder_width = 28;
switch_holder_height = 50;

// pen holder
pen_diameter = 13;//9.6;
plate_l=34.5;
plate_w=18;
plate_h=5;
base_diameter=19.2; // dremel holder hole opening
base_h=10; // dremel holder base thickness
thickness=2; 
height=30; //

module EndStopHolder(holes = true, extramargin = 0) {
    
    switch_holder_width = switch_holder_width + extramargin;
    plate_thickness = plate_thickness + extramargin;
    
    difference() {
        cube([switch_holder_height, switch_holder_width, plate_thickness]);
        
        union() {
            translate([-epsilon,(switch_holder_width-opening_w)/2,-epsilon])
            cube([opening_h, opening_w, plate_thickness + 2*epsilon]);
            
            // screw holes
            translate([hole_dia,(switch_holder_width-hole_distance)/2,-epsilon])
            cylinder(h = plate_thickness + 2*epsilon, d = hole_dia);
        
            translate([hole_dia,(switch_holder_width-hole_distance)/2+hole_distance,-epsilon])
            cylinder(h = plate_thickness + 2*epsilon, d = hole_dia);   
            
            // extra holes
            if (holes) {

            translate([40,5,-epsilon])
            cylinder(h = plate_thickness + 2*epsilon, d = hole_dia);   
            
            translate([40,switch_holder_width-5,-epsilon])
            cylinder(h = plate_thickness + 2*epsilon, d = hole_dia); 
            }
        }
    }

    // used to check the distance between the holes
    //translate([0,(switch_holder_width-hole_distance)/2,0])
    //color("white") cube([8, hole_distance, plate_thickness]);
}


module PenHolderBottom() {
   // top holder
   top_dia = 35;
   top_height = 25;
   top_thickness = plate_thickness+2;
   top_margin = 10;
    
	difference() {
		union() {
            // base to fit in dremel holder
            cylinder(d=base_diameter, h=height);
            
            // bottom plate
			//cylinder(d=plate_l, h=plate_h);
            
            // top holder
            translate([0,0,top_margin])
            cylinder(d=top_dia, h=top_height);
		}
   
        // side cut offs
        translate([top_thickness,-top_dia/2,top_margin-epsilon])
        cube([top_dia/2-top_thickness,top_dia,top_height+2*epsilon]);
   
        // side cut offs
        translate([-top_dia/2,-top_dia/2,top_margin-epsilon])
        cube([top_dia/2-top_thickness,top_dia,top_height+2*epsilon]);
   
        // extra holes
        translate([-plate_thickness/2-top_thickness,-switch_holder_width/2,switch_holder_height+height-15]) rotate([0,90,0]) {
            
        translate([40,5,-epsilon])
        cylinder(h = top_thickness*2 + plate_thickness + 2*epsilon, d = hole_dia);          
        translate([40,switch_holder_width-5,-epsilon])
        cylinder(h = top_thickness*2 + plate_thickness + 2*epsilon, d = hole_dia);
        } 
        
        translate([10,10,10]) rotate([0,45,90]) cube([10,20,15]);
        translate([10,-27.6,13.5]) rotate([0,45,90]) cube([15,20,10]);
        
	}
}

module EndStopProbe() {
    
    difference() {
        PenHolderBottom();
        
        extramargin = 1;
       translate([-(plate_thickness+extramargin)/2,-(switch_holder_width+extramargin)/2,switch_holder_height+height-15]) rotate([0,90,0]) EndStopHolder(false, extramargin);

    } 
}

EndStopProbe();
//EndStopHolder();