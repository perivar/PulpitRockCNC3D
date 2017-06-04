
pen_diameter = 12;

$fn = 120;

bracket();

module bracket() {
	difference() {
		union() {
			cube([32, 15, 10], center=true);
			cylinder(h = 10, r=9.5, center=true);
			translate([0, 0, 5]) loop();
			}
            
		// Slots to catch elastic
		translate([-14, 3.5, 0]) color([1, 0, 0])cube([5, 3, 13], center=true);
		translate([ 14, 3.5, 0]) color([1, 0, 0])cube([5, 3, 13], center=true);
		translate([-14,-3.5, 0]) color([1, 0, 0])cube([5, 3, 13], center=true);
		translate([ 14,-3.5, 0]) color([1, 0, 0])cube([5, 3, 13], center=true);

		// hole for pen
		translate([0, 0, -2.6])cylinder(h=5, r= pen_diameter/2, center=true);
		translate([0, 0, 1.4])cylinder(h=3, r2=1, r1= pen_diameter/2, center=true);

		// round chamfer on top
		translate([-11.05, 0, 0.05]) color([0, 0.5, 0])curve();
		translate([11.05, 0, 0.05]) color([0, 0.5, 0])mirror() curve();

	}
}

module loop() {
	difference() {
		rotate([0, 90, 0]) cylinder(r= 6, h=5, center=true);
		translate([-0.5, 0, 0]) rotate([0, 90, 0]) cylinder(r= 3.5, h=7, center=true);
		translate([0, 0, -3 ])cube([6, 10, 6], center = true);
	}
}

module curve(rad=10, height = 20) {
	difference() {
		translate([-rad/4, 0,  rad/4])cube([rad/2, height, rad/2], center = true);
		rotate([90, 0, 0])cylinder(r=rad/2, h=height + 1, center=true);
	}
}
