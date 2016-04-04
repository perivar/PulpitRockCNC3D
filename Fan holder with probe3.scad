
epsilon = 0.1; // small tolerance used for CSG subtraction/addition

$fn=30;

// 18 mm hole for the inductive sensor
// LJ18A3-8-Z/BX   
probe_extra_margin = 0.8;
probe_dia = 18.0 + probe_extra_margin;

// flat screw is 24 mm across
// i.e. 27.7128 dia
probe_realdia = flatsdia2realdia(dia=24);


// screw/nut dimensions
//chttp://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_margin = 0.6;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm - orig. 3


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

// triangle support
triangle_thickness = 2;

//probe_margin = 5; 
//probe_holder_width = probe_dia+2*probe_margin;
probe_holder_width = probe_realdia + back_thickness + triangle_thickness + probe_extra_margin*2;

//probe_holder_length = probe_dia+2*probe_margin;
probe_holder_length = probe_holder_width;


/**
 * Standard right-angled triangle
 * from MCAD
 * @param number o_len Lenght of the opposite side
 * @param number a_len Lenght of the adjacent side
 * @param number depth How wide/deep the triangle is in the 3rd dimension
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


// **********
// FUNCTIONS
// **********

// calculate the real diameter from measuring a non circle from flat to flat
function flatsdia2realdia(dia=10, sides=6) 
 = ( dia / cos(180/sides) );

// calculate the flats diameter (measure from flat to flat) from the real diameter
function realdia2flatsdia(dia=11.547, sides=6) 
 = ( dia * cos(180/sides) );



// figure that can be used to make an inside circular cut
// dia = diameter
// thickness = thickness of the cube
// w = width
// h = height
module inside_cut(dia=10, thickness=2, w=20, h=20) {
    
    radius = dia/2;
    
    // cut-out big circle
    translate([radius,-epsilon,radius]) rotate([-90,0,0]) cylinder(h=thickness+2*epsilon, r=radius);
              
    // cut-out box at the top            
    translate([0,-epsilon,radius]) cube([w+epsilon, thickness+2*epsilon, h-radius+epsilon]);
                
    // cut-out box at the right
    translate([radius,-epsilon,0]) cube([w-radius+epsilon, thickness+2*epsilon, h+epsilon]);       
}

// figure that can be used to make an outside circular cut
// dia = diameter
// thickness = thickness of the cube
module outside_cut(dia=10, thickness=2, direction="right") {

    radius = dia/2;
    
    if (direction == "right") {        
        translate([-radius,-epsilon,-radius]) difference() {
            cube([radius+epsilon,thickness+2*epsilon,radius+epsilon]);
            translate([0,-epsilon,0]) rotate([-90,0,0]) cylinder(h=thickness+4*epsilon, r=radius);
        }   
    } else if (direction == "left") {
        translate([-epsilon,-epsilon,-radius]) difference() {
            cube([radius+epsilon,thickness+2*epsilon,radius+epsilon]);
            translate([radius,-epsilon,0]) rotate([-90,0,0]) cylinder(h=thickness+4*epsilon, r=radius);
        }          
    } 
}

module nut_trap(sides=6, margin=0) {
    
    screw_hole_height = bottom_thickness+2*epsilon;
    nut_margin = bottom_thickness/2;
    
    // nut trap
    translate([0,margin,nut_margin-epsilon]) cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=sides);        

    // screw hole
    translate([0,margin,-epsilon]) cylinder(r=screw_dia/2, h=screw_hole_height+2*epsilon, $fn=20);	    
}

module nut_traps(sides=6, left_margin=0, right_margin=0, length=38) {
                  
    side_margin = realdia2flatsdia(dia=nut_dia)/2;
    
    //left margin: 1.31 mm
    //right margin: 1.51 mm
    nut_trap(margin=side_margin+left_margin); 
    nut_trap(margin=length-side_margin-right_margin); 
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

module back() {
       
    translate([0,bottom_width-back_thickness,0]) {
        difference() {
            cube([back_width, back_thickness, back_height]);
            
            union() {
            //translate([back_thin_width,-epsilon,back_thin_height]) cube([back_width-back_thin_width+epsilon, back_thickness+2*epsilon, back_height-back_thin_height+epsilon]);
                
    // inside cut-out
    translate([back_thin_width,0,back_thin_height]) inside_cut(dia=20, thickness=back_thickness, w = back_width-back_thin_width, h = back_height-back_thin_height);            
          
    // outside cut-out at the bottom right 
    translate([back_width,0,back_thin_height]) outside_cut(dia=10, thickness=back_thickness);             

    // outside cut-out at the top right 
    translate([back_thin_width,0,back_height]) outside_cut(dia=4, thickness=back_thickness, direction="right");

    // outside cut-out at the top left 
    //translate([0,0,back_height]) outside_cut(dia=4, thickness=back_thickness, direction="left");
                
    // screw holes
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

module back_probe() {
       
    width = probe_holder_width; 
    
    translate([-width,bottom_width-back_thickness,0]) {
        difference() {
            cube([width, back_thickness, back_height]);
            
    // outside cut-out at the top left 
    translate([0,0,back_height]) outside_cut(dia=10, thickness=back_thickness, direction="left");
            
        }
    }
}

module bottom() {
    translate([0,0,0]) {
        difference() {
            cube([bottom_length, bottom_width, bottom_thickness]);
            
            union() {
            // cut-out for the fan
            translate([bottom_left_margin,bottom_side_margin,-epsilon]) cube([bottom_opening_length,bottom_opening_width,bottom_thickness+2*epsilon]);
                
                // nut traps
                nut_trap_margin_back = 3.85;//3.85;            
             
    // nut openings: 1.51 right, 1.31 left
    // 38 mm width from fan end to right end
                translate([bottom_opening_length+bottom_left_margin,bottom_width-back_thickness-nut_dia/2-nut_trap_margin_back,0]) rotate([0,0,-90]) nut_traps(left_margin=1.31, right_margin=1.51, length=38);
                                               
            }                
        }
    }
}

module bottom_probe() {
    
    width = probe_holder_width; 
    length = probe_holder_length; 
        
    rounded_radius = 6/2; // 4 mm diameter

    translate([-width,-width+bottom_width,0]) {
        difference() {
            rcube([width,length,bottom_thickness],radius=rounded_radius,fn=$fn);            
            //cube([width,length,bottom_thickness]);                    
        rotate([0,0,0]) translate([width/2,length/2,-epsilon]) cylinder(r=probe_dia/2,h=bottom_thickness+2*epsilon);
        }
        
            // large triangle support
            
            trianglesize = 30;
            triangledepth = 2;
            translate([width,width,3.5-epsilon]) rotate([90,0,-90]) triangle(trianglesize,trianglesize,triangledepth);        
        
    }
}

union() {
    back();
    translate([bottom_left_margin,0,0]) back_probe();
    bottom();
    translate([bottom_left_margin,0,0]) bottom_probe();
}

