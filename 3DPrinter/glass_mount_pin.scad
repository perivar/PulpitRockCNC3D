// 15 mm
// 8 mm 
// 7 mm opening
// 1.5 mm thick

/*
difference() {
    cube([15,15,1.5]);
    
    translate([-epsilon,-epsilon,-epsilon]) cube([7+epsilon,7+epsilon,1.5+2*epsilon]);
}

translate([7,0,0]) cube([8,1.5,11.1]);

translate([1.5,7,0]) rotate([0,0,90]) cube([8,1.5,11.1]);
*/

$fn=20;
margin = 0.2;

washer_dia = 14.2+0.3;
thickness = 1.5;

width = washer_dia+2*thickness;
mirror_bed_thickness = 8;
height = mirror_bed_thickness+2*thickness+margin; // 11.1
edge_wall = 8;
screw_width = 6.35; // really 6.25
epsilon = 0.1;

difference() {
    cube([width,width,height]);
    
    union() {
        // remove center
        translate([-epsilon,-epsilon,thickness]) cube([width-thickness+epsilon,width-thickness+epsilon,height-2*thickness]);
    
        // remove corner edge
        //translate([edge_wall,edge_wall,-epsilon]) cube([width-edge_wall+epsilon, width-edge_wall+epsilon, height+2*epsilon]);
        
        // slot in the top
        rotate([0,0,-45]) translate([-screw_width/2,0,height-thickness-epsilon]) cube([screw_width, 30, thickness+2*epsilon]); 
        
        // iron ring
        translate([washer_dia/2+thickness,washer_dia/2+thickness,-epsilon]) cylinder(d=washer_dia, h=thickness+2*epsilon);

    }
}

// support
translate([5.5,0,0]) cube([1,1,height]);
translate([0,5.5,0]) cube([1,1,height]);
