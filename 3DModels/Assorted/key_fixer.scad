$fn=20;
thickness = 1.6;
epsilon = 0.1;

key_thickness = 6.65;
key_width = 26;
key_height = 31;

key_metal_base_width = 12;
key_metal_base_length = 13;
key_metal_thickness = 2.85;
key_metal_width = 9.2;
key_metal_length = 40;

/*translate([-((key_width-key_metal_width)/2),-key_height,0]) { 
        cube([key_width,key_height,key_thickness]);
    }
    */
    
    translate([0,0,2.5])
difference() {
  translate([-((key_width+5-key_metal_width)/2),-key_height-6,-2.5]) { 
        cube([key_width+5,key_height-0.5+6,12]);
  }
      key();
  
  translate([4.5,-31,0]) cylinder(h = 20, r=3, center = true);
}   
  
  
module key() {
color("darkblue") {

translate([30.5,34,0]) resize([key_width+1,key_height+1,key_thickness]) rotate([0,0,180]) linear_extrude(height = key_thickness, center = false)
   import (file = "Key_Head.dxf");    
}

translate([0,0,((key_thickness-key_metal_thickness)/2)])
color("gray") {
cube([key_metal_width, key_metal_length, key_metal_thickness]);

translate([-((key_metal_base_width-key_metal_width)/2),0,0]) cube([key_metal_base_width, key_metal_base_length, key_metal_thickness]);
}
}