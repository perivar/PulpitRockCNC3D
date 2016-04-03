
epsilon = 0.1; // small tolerance used for CSG subtraction/addition

// 18 mm hole for the inductive sensor
// LJ18A3-8-Z/BX   
probe_extra_margin = 0.6;
probediameter = 18.0 + probe_extra_margin;
probemargin = 5; 
probe_holder_width = probediameter+2*probemargin;

$fn=30;

// screw/nut dimensions
//chttp://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_margin = 0.6;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm - orig. 3

/**
 * Standard right-angled triangle
 * from MCAD
 * @param number o_len Lenght of the opposite side
 * @param number a_len Lenght of the adjacent side
 * @param number depth How wide/deep the triangle is in the 3rd dimension
 * @todo a better way ?
 */
module triangle(o_len, a_len, depth)
{
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

module rcube(size = [1, 1, 1], center = false, radius = 1.5, fn = 8) {
	
	translate = (center == true) ?
	[0, 0, 0] :
	[
	(size[0] / 2),
	(size[1] / 2),
	(size[2] / 2)
	];

	translate(v = translate){
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
        
		for (x = [radius-size[0]/2, -radius+size[0]/2],
		y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true, $fn=fn);
		}
	}
}

module z_probe_holder() {

    width = probe_holder_width; // original 20.3
    depth = 3.5; // 3.5
    length = probediameter+2*probemargin;
    rounded_radius = 4/2; // 4 mm diameter
    
	difference()
	{
        union() {
            translate([0,depth,0]) rotate([90,0,0]) rcube([width,length,depth],radius=rounded_radius,fn=$fn);
                       
            // large triangle support
            trianglesize = 26;
            triangledepth = 2;
            rotate([0,0,0]) translate([0,3.5,0]) triangle(trianglesize,trianglesize,triangledepth);
        }

        rotate([-90,0,0]) translate([width/2,-length/2,-epsilon]) cylinder(r=probediameter/2,h=depth+2*epsilon);
    }
}

module fan_duct_with_support() {    
    thickness = 2.5;
    length = 38;
    translate([0,probe_holder_width,0]) rotate([90,0,0]) {
        
        //fan_duct();

        union() {
       translate([0,-thickness,-length+38]) cube([18,thickness,length]);
    
        // large triangle support
        trianglesize = 12;
        triangledepth = 6.5;
        rotate([180,90,0]) translate([-38,0,-triangledepth]) triangle(trianglesize,trianglesize,triangledepth);
        }
    }
}

module main_parts() {
    hole_height = 6;
    hole_margin = 5;
    nut_margin = 3.5/2;
    difference() {
        translate([0,59.5,3]) fan_duct_with_support();
        
        // screw holes
        union() {
            // nut traps
            translate([10.5,50+hole_margin,nut_margin-epsilon]) cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);        

            // nut traps
            translate([10.5,50+38-hole_margin,nut_margin-epsilon]) cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);        

            // screw holes
            translate([10.5,50+hole_margin,-2.5-epsilon]) cylinder(r=screw_dia/2, h=hole_height+2*epsilon, $fn=20);	
                
            // screw holes
            translate([10.5,50+38-hole_margin,-2.5-epsilon]) cylinder(r=screw_dia/2, h=hole_height+2*epsilon, $fn=20);	
        }
    }
}
//color("green") translate([-posx,probe_holder_width+posz,-posy]) rotate([90,0,0]) holder();

//z_probe_holder();
//main_parts();
//translate([0,-posy-7,0]) rotate([0,180,0]) main_parts();


// flat screw is 24 mm across



back_thickness = 2.5;
back_height = 52; // 51.5;
back_width = 61.5;
back_thin_width = 15;
back_thin_height = 23.5;

bottom_thickness = 3.5;
bottom_length = 61.5;
bottom_width = 20.3;//20.3;

bottom_left_margin = 2;
bottom_side_margin = 1;

bottom_opening_length = 21.5;
bottom_opening_width = bottom_width-bottom_side_margin-back_thickness;//16.80


module back() {
    translate([0,bottom_width-back_thickness,0]) {
        difference() {
            cube([back_width, back_thickness, back_height]);
            
            union() {
            translate([back_thin_width,-epsilon,back_thin_height]) cube([back_width-back_thin_width, back_thickness+2*epsilon, back_height-back_thin_height]);
                
    // screw hole
    screw_dia = 3.5;
    screw_length = 6.5;
    screw_top_margin = 1.5;//1.5;
    screw_left_margin = 6.3;//6.25;
                
    translate([screw_left_margin,0,back_height-screw_top_margin]) long_cylinder(dia=screw_dia, width=screw_length, thickness = back_thickness);
         
    screw2_right_margin = 7;//6.96;
    screw2_top_margin = 12.25;
    screw2_pos_z = back_thin_height-screw2_top_margin;                
    translate([back_width-screw_length-screw2_right_margin,0,screw2_pos_z]) long_cylinder(dia=screw_dia, width=screw_length, thickness = back_thickness);
                                
            }
        }
    }
}

module long_cylinder(dia=3.5, width=6.5, thickness=5) {

    rad = dia/2;
    
    if (width <= dia) { 
        // only one cylinder
        translate([rad,-epsilon,-rad]) rotate([-90,0,0]) cylinder(r=rad, h=thickness+2*epsilon);
        
        } else {

        // first cylinder
        translate([rad,-epsilon,-rad]) rotate([-90,0,0]) cylinder(r=rad, h=thickness+2*epsilon);
        
        // cube to cover the middle
        translate([rad,-epsilon,-2*rad]) cube([width-dia,thickness+2*epsilon,dia]);
    
        // second cylinder
        translate([rad+width-dia,-epsilon,-rad]) rotate([-90,0,0]) cylinder(r=rad, h=thickness+2*epsilon);
        }
}

module bottom() {
    translate([0,0,0]) {
        difference() {
            cube([bottom_length, bottom_width, bottom_thickness]);
            
            union() {
            // cut-out to fan
            translate([bottom_left_margin,bottom_side_margin,-epsilon]) cube([bottom_opening_length,bottom_opening_width,bottom_thickness+2*epsilon]);
                
            // screw holes
                // 1.31
                #translate([bottom_opening_length+bottom_left_margin-1.405+1.31,10,0]) rotate([0,0,-90]) screws();
            }
                
        }
    }
}

module screws() {
    
 	// Find Nut_Flats = Measure across the flats    
    Num_Sides = 6; // Hexagon = 6
    Flats_Rad = nut_dia/2 * cos(180/Num_Sides);
    Nut_Flats = 2 * Flats_Rad;
    echo (Flats_Rad);
 
    hole_height = 6;
    hole_margin = 5;
    nut_margin = 3.5/2;

    // nut traps
    translate([0,hole_margin,nut_margin-epsilon]) cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=Num_Sides);        

    // nut traps
    translate([0,38-hole_margin,nut_margin-epsilon]) cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=Num_Sides);        

    // screw holes
    translate([0,hole_margin,-2.5-epsilon]) cylinder(r=screw_dia/2, h=hole_height+2*epsilon, $fn=20);	
        
    // screw holes
    translate([0,38-hole_margin,-2.5-epsilon]) cylinder(r=screw_dia/2, h=hole_height+2*epsilon, $fn=20);	
}


back();
bottom();

// wall 6.51
// 4.03
// opening 21.5


// nut openings: 1.51 right, 1.31 left
// 38 mm width from fan end to right end