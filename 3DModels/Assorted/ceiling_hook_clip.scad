
// variables (mm)
$fa = 1;
$fs = 0.4;

clip_length = 35;
clip_radius = 7.5 / 2; // 18 mm outer diameter

// the length to the inside of the hook is 22 mm - 8 for cover box thickness
clip_depth = 22 - 8;

opening_margin = 4;
opening_depth = 4;
epsilon = 0.1;


difference() {
    
// rounded cube
union() {
cube([clip_radius*2,clip_depth-clip_radius,clip_length]);
    
translate([clip_radius, 0, 0]) cylinder(h=clip_length, r1=clip_radius, r2=clip_radius, center=false);
}
  
// cut out
translate([-epsilon,clip_depth-clip_radius-opening_depth+epsilon,opening_margin]) cube([clip_radius*2+2*epsilon,clip_depth-clip_radius-opening_depth+epsilon,clip_length-2*opening_margin]);

}