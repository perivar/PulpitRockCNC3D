$fn=100;
epsilon=0.1;
pen_diameter = 13;//9.6;
pen_diameter_point1=pen_diameter;
pen_diameter_point2=5;
plate_l=34.5;
plate_w=18;
plate_h=5;
base_diameter=19.2; // dremel holder hole opening
base_h=10; // dremel holder base thickness
thickness=2; 
pointHeight=6;
height=50; // was 40, height - pointHeight = 34

PenHolderBottom();

module PenHolderBottom() {
	difference() {
		union() {
            // main cylinder pen body
			cylinder(d=pen_diameter+2*thickness, h=height-pointHeight);
            
            // base to fit in dremel holder
            cylinder(d=base_diameter, h=plate_h+base_h);
            
            // pointed end
			translate([0, 0, height-pointHeight-epsilon]) cylinder(d1=pen_diameter+2*thickness, d2=pen_diameter_point2+2*thickness, h=pointHeight+epsilon);
            // bottom plate
			cylinder(d=plate_l, h=plate_h);
		}
        
        // pen opening chamfer
		translate([0, 0, height-pointHeight-epsilon])cylinder(d1=pen_diameter_point1, d2=pen_diameter_point2, h=pointHeight-1+2*epsilon);
        // pen outer opening
		translate([0, 0, -epsilon])cylinder(d=pen_diameter_point2, h=height+2*epsilon);
        // pen body
		translate([0, 0, -1])cylinder(d=pen_diameter, h=height-pointHeight+1);
        // chamfer
		translate([0, 0, -epsilon])cylinder(d1=pen_diameter+1,d2=pen_diameter, h=0.5);
		

//writeConnector();
//rotate([0,0,180]) writeConnector();
    
    // cut away edges  
        /*
    translate([ -20, (plate_w/2), -0.5])cube([40, 20, 7]);
	translate([ -20, -20-(plate_w/2), -0.5])cube([40, 20, 7]);
     */
        
     // circular opening   
     hull() {   
       translate([ 0, plate_w, plate_h+base_h+4]) rotate([90,0,0]) cylinder(d=pen_diameter/2, h=plate_w*2);
       translate([ 0, plate_w, height-10]) rotate([90,0,0]) cylinder(d=pen_diameter/2, h=plate_w*2);
     }
	}
	
	// support
//	translate([0, 0, 38]) cylinder(r=4.5, h=0.4);
}


module writeConnector() {
    
     translate([-13, 0, 6-0.5]) cylinder(r=3.6, h=20,$fn=40);

    for(r=[0:66]) {
hull() {
    rotate([0,0,-r]) translate([-13, 0, -0.5]) cylinder(r=2, h=20,$fn=20);
    rotate([0,0,-r-1]) translate([-13, 0, -0.5]) cylinder(r=2, h=20,$fn=20);
    }
}
   for(s=[0:22]) {
       hull() {
    rotate([0,0,-20-(s*3)]) translate([-13-1, 3, 6-(0.25*s)+5]) cube([10,6,10],center=true);
    rotate([0,0,-20-((s+1)*3)]) translate([-13-1, 3, 6-(0.25*(s+1))+5]) cube([10,6,10],center=true);
       }
   }
}
