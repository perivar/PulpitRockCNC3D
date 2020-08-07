

/*
Abbrev.	Inner D.	Outer D.	Thickness	Notes
608		8 mm		22 mm		7 mm	A common roller skate bearing used extensively in RepRaps.
626		6 mm		19 mm		6 mm	 
625		5 mm		16 mm		5 mm	 
624		4 mm		13 mm		5 mm	 
623		3 mm		10 mm		4 mm	 
603		3 mm		9 mm		5 mm	 
*/

bearingInnerDia = 8; 		
bearingOuterDia = 22;	// outer dimensions
bearingThickness = 7;	// thickness
bearingClearance = 0.15;	// clearance around the outer dimensions, mostly 0 or 0.15

bearingDiameter = bearingOuterDia + bearingClearance;

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

mdfDepth = 12.7;

margin= 2;
thickness = bearingThickness/2 + margin;
width = 50;
height= bearingDiameter+2*margin;

module base_plate() {

//translate([0,0,0]) cube([width,height,thickness]);
  
hull() {  
translate([width/2,height/2,0]) cylinder(r=bearingDiameter/2+2,h=thickness, $fn=33);
    
// left
translate([4,height/2,0]) cylinder(r=4,h=thickness, $fn=33);

// right
translate([width-4,height/2,0]) cylinder(r=4,h=thickness, $fn=33);
}
}

module long_hole(dist=2, r=2, h=4, $fn=33) {
    
    hull() {
    translate([-dist/2,0,0]) cylinder(r=r, h=h, $fn=$fn);
    
    translate([dist/2,0,0]) cylinder(r=r, h=h, $fn=$fn);
    }      
}

module BearingFastener() {
difference() {
    base_plate();

// bearing
translate([width/2,height/2,margin]) cylinder(r=bearingDiameter/2,h=thickness, $fn=33);

// center hole (ensure it allows the small bearing circle to move freely, it's 12 mm + margin
translate([width/2,height/2,-epsilon]) cylinder(r=13/2,h=thickness+2*epsilon, $fn=33);
    
    // screw holes
    for (i = [margin*3+1, width-margin*3-1]) {
translate([i,height/2,-epsilon]) long_hole(dist= margin*2, r=2,h=thickness+2*epsilon, $fn=33);
    }    
}
}

//BearingFastener();
