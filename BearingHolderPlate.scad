

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
bearingClearance = 0.2;	// clearance around the outer dimensions

bearingDiameter = bearingOuterDia + bearingClearance;
wallThickness = 0.6;	// thickness of the wall

baseHeight = 1.7;	// base height
innerHeight = baseHeight * 2;
outerHeight = bearingThickness + baseHeight;

wallAscent = 3;		// mm to add to the bearing diameter for the outer ring
wallDescent = 0.5;	// mm to add to the bearing diameter for the inner ring

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

clearance = 0.0;

mdfDepth = 12.7;

// screw/nut dimensions
// http://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_dia = 4.5;	// M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 8.2;		// M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 2.5; 	// M3 = 2.3 mm, M4 = 3 mm - orig. 3

// mounting plate dimensions
plate_height = 5;
plate_length = 35;
plate_width = 35;
screw_space_x = 22;
screw_space_y = 22;

module mount_plate(plate_height=plate_height) {
	difference()
	{
		//bottom plate
		translate([-plate_width/2,-plate_length/2,0])
		cube([plate_width,plate_length,plate_height]);

		if (true) {
			// nut traps
			translate([screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
			translate([-screw_space_x/2,screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
			translate([screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);
			translate([-screw_space_x/2,-screw_space_y/2,plate_height-nut_height])
			cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);

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
	}
}


module outer()
{
	difference()
	{
		cylinder(r=bearingDiameter/2+2*wallThickness+clearance,h=outerHeight);
		
		// space for the bearing
		translate([0,0,-epsilon])
		cylinder(r=bearingDiameter/2,h=outerHeight+2*epsilon);
		
		// upper rim
		translate([0,0,bearingThickness])
		cylinder(r=bearingDiameter/2+wallThickness+clearance,h=outerHeight);
	}

	difference()
	{
		cylinder(r=bearingDiameter/2+wallAscent,h=baseHeight);
		
		translate([0,0,-epsilon])
		cylinder(r=bearingDiameter/2-wallDescent,h=baseHeight+2*epsilon);
	}
}

module inner()
{
	// bearing cover
	difference()
	{
		cylinder(r=bearingDiameter/2+wallThickness,h=innerHeight);
		
		translate([0,0,-epsilon]) 
		cylinder(r=bearingDiameter/2,h=innerHeight+2*epsilon);
	}

	// base ring which the bearing will rest on
	difference()
	{
		cylinder(r=bearingDiameter/2+wallAscent,h=baseHeight);
		
		translate([0,0,-epsilon]) 
		cylinder(r=bearingDiameter/2-wallDescent,h=baseHeight+2*epsilon);
	}
}

/*
inner();
translate([29,0,0])
outer();
*/

module bearingHolePlate() {
	difference()
	{
		mount_plate();
		translate([0,0,-epsilon]) 
		cylinder(r=bearingDiameter/2,h=bearingThickness+2*epsilon);	
	}
}

module BearingFastenerOutside() {   

    difference() 
    {
        union() {
            translate([0,0,plate_height]) rotate([0,180,0]) mount_plate(plate_height);	
            cylinder(r=bearingDiameter/2,h=plate_height+(mdfDepth-bearingThickness)/2);
        }

        translate([0,0,-epsilon]) 
        cylinder(r=bearingInnerDia/2+1,h=plate_height+bearingThickness+2*epsilon);
    }
}

module BearingFastenerInside() {
    height = 12; // plate_height;
    
    difference() 
    {
        union() {
            translate([0,0,height]) rotate([0,180,0]) mount_plate(height);	            
        }

        translate([0,0,-epsilon]) cylinder(r=bearingInnerDia/2+1,h=height+bearingThickness+2*epsilon);
        
        // enough place for the nut to rotate
        translate([0,0,4]) cylinder(r=8,h=height+bearingThickness+2*epsilon);
        
        // carve out
        //translate([0,0,4+7.5]) cylinder(r=21/2+1,h=height+bearingThickness+2*epsilon);
        
        translate([-12/2,-20,4]) cube([12,50,height+epsilon]);
    }
}

//BearingFastenerInside();
//BearingFastenerOutside();