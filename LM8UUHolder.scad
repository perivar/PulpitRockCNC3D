use <linear_bearing.scad>

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

$fn=30;

// screw/nut dimensions
//chttp://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_margin = 0.6;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm - orig. 3

// Linear Bearing LM8UU dimensions
// 24x15mm, Inside diameter: 8mm
lm8uu_margin = 0.5; // 0.5 is very tight
lm8uuLength = 24 + lm8uu_margin; // 24
lm8uuOutDia = 15 + lm8uu_margin; // 15
lm8uuInDia = 8 + 2.5; // 8
lm8uu_sidemargin = 0.5; // how much should we add to the sides on top of the lm8uu to keep the bearing inside (1.0 mm is a bit tight)

// holder dimensions
margin = 2.0;
length = lm8uuLength + 2*margin; // 31.10;
width = lm8uuOutDia + 2*margin; // 22.10;
height = lm8uuOutDia + 2*margin; // 22.46;

// cut out dimensions
cutout_height = height-2*margin;//11.78;
cutout_width = 1.5;//length/5;//5.95;
cutout_margin = nut_dia+margin;//length/5;//6.4;

// base that holds the nut and screw trap
base_height = nut_height+margin;
base_width = cutout_margin;
base_length = cutout_margin;

module LM8UUHolder() {

    difference() {
        cube([length, width, height]);
    
        union() {
            // smooth rod
            rotate([0,90,0]) translate([-height+lm8uuOutDia/2,width/2,-epsilon]) cylinder(r=lm8uuInDia/2, h=length+2*epsilon);
    
            // cutout for smooth rod    
            translate([-epsilon,(width-lm8uuInDia)/2,height-lm8uuOutDia/2]) cube([length+2*epsilon,lm8uuInDia,lm8uuOutDia/2+epsilon]);
        
            // lm8uu    
            rotate([0,90,0]) translate([-height+lm8uuOutDia/2,width/2,(length-lm8uuLength)/2]) cylinder(r=lm8uuOutDia/2, h=lm8uuLength);
     
            // cutout for lm8uu   
            topmargin = lm8uuOutDia/2-2*epsilon;
            translate([(length-lm8uuLength)/2,(width-lm8uuOutDia)/2+lm8uu_sidemargin/2,height-topmargin]) cube([lm8uuLength,lm8uuOutDia-lm8uu_sidemargin,topmargin+epsilon]);
        
            //cutouts();                     
        }               
    }
    
    nut_traps2();
}

module cutouts() {
    // cutouts
    translate([cutout_margin, -epsilon, height-cutout_height+epsilon]) cube([cutout_width, width+2*epsilon, cutout_height+2*epsilon]);
        
    // cutouts
    translate([length-cutout_margin-cutout_width, -epsilon, height-cutout_height+epsilon]) cube([cutout_width, width+2*epsilon, cutout_height+2*epsilon]);  
}

module nut_trap2() {
    union() {
        // nut traps
        cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);

        // screw holes
        cylinder(r=screw_dia/2, h=base_height+2*epsilon, $fn=20);		         
    }    
}

module nut_traps2() {
    
    translate([0,-base_width+epsilon,height-base_height]) 
    difference() {
        cube([length,base_width,base_height]);

        translate([margin+nut_dia/2,base_width/2,-epsilon]) nut_trap2();

        translate([length-margin-nut_dia/2,base_width/2,-epsilon]) nut_trap2();
    }

    translate([0,width-epsilon,height-base_height]) 
    difference() {    
        cube([length,base_width,base_height]);        
        translate([margin+nut_dia/2,base_width/2,-epsilon]) nut_trap2();

        translate([length-margin-nut_dia/2,base_width/2,-epsilon]) nut_trap2();
    }
}

module nut_traps() {
      
    translate([0,-base_width+epsilon,height-base_height]) 
    nut_trap();  
    
    translate([length-base_width,-base_width+epsilon,height-base_height]) 
    nut_trap();  

    translate([0,width-epsilon,height-base_height]) 
    nut_trap();  

    translate([length-base_width,width-epsilon,height-base_height]) 
    nut_trap();  
}

module nut_trap() {
    
    difference() {
        cube([base_length,base_width,base_height]);

    // nut traps
    translate([cutout_margin/2,base_width/2,-epsilon])
    union() {
	cylinder(r=nut_dia/2, h=nut_height+epsilon, $fn=6);

	// screw holes
    translate([0,0,0])
	cylinder(r=screw_dia/2, h=base_height+2*epsilon, $fn=20);		 
        }
    }            
}

translate([0,width+base_width-epsilon,height]) rotate([180,0,0]) LM8UUHolder();
