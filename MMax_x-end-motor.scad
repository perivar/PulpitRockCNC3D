$fa = 1;
$fs = 2;

pi = 3.141592653589;

module cylr(r = 10, h = 10, rt = 2)
{
	render()
	hull() {
		cylinder(r=r, h=0.01);
		translate([0, 0, h - rt]) rotate_extrude(convexity=5)
		difference() {
			translate([r - rt, 0]) circle(rt);
			translate([rt * -2 + 0.05, -rt]) square([rt * 2, rt * 2]);
		}
	}
}

module nema17() {
	difference() {
		hull()
			for (i=[0:1])
				rotate([0, 0, 45 + 90 * i]) translate([-21 * sqrt(2) + 1, -1.5, -50]) cube([42 * sqrt(2) - 2, 3, 50]);
		for (i=[0:3])
			rotate([0, 0, 90 * i])
			translate([15.5, 15.5, -40])
				translate([0, 0, -1]) cylinder(r=1.5, h=7);
	}
	translate([0, 0, -1]) cylinder(r=11, h=3);
	cylinder(r=2.5, h=24);
}

module nema17_negative() {
	hull()
		for (i=[0:1])
			rotate([0, 0, 45 + 90 * i]) translate([-21.5 * sqrt(2) + 1, -1.5, -70]) cube([43 * sqrt(2) - 2, 3, 70]);
	translate([0, 0, -1]) cylinder(r=11.5, h=13);
	cylinder(r=2.5, h=24);
	for (i=[0:3])
		rotate([0, 0, 90 * i])
		translate([15.5, 15.5, 0])
		{
			translate([0, 0, -1]) cylinder(r=1.5, h=8);
			translate([0, 0, 6]) cylinder(r=4, h=100);
		}

	%nema17();
}

module negatives() {
	translate([0, 0, -10]) cylinder(r=8.05, h=100);
	translate([-30, 0, -10]) cylinder(r=6.5, h=100);
	translate([30, -29.5, 25]) rotate([90, 0, 0]) nema17_negative();

	translate([-30, 0, 7]) cylinder(r=16, h=10);
	for (i=[0:2])
		translate([-30, 0, -8]) 
		rotate([0, 0, 120*i]) translate([11, 0, 0]) {
			translate([0, 0, 2.8]) cylinder(r=3.3/2, h=30);
			translate([0, 0, -1]) rotate([0, 0, 180/6]) cylinder(r=5.5 / 2 / cos(180/6) + 0.05, h=3.6, $fn=6);
		}
	
	for (y=[0:1]) {
		translate([0, -25 + y*50, 0]) {
			hull() {
				rotate([0, -90, 0]) cylinder(r=8 / 2 / cos(180 / 50) + 0.1, h=100, $fn = 50);
				translate([-100, -2 / sqrt(2), -1.6]) cube([100, 4 / sqrt(2), 8 / sqrt(2)]);
			}
			rotate([0, -90, 0]) rotate([0, 0, 180 / 8]) cylinder(r=3 / 2 / cos(180 / 8), h=90, center=true, $fn=8);
			rotate([0,  90, 0]) translate([0, 0, -0.3]) cylinder(r=5.5 / 2 / cos(180 / 6) + 0.05, h=3, $fn=6);
			rotate([0,  90, 0]) translate([0, 0, 20]) cylinder(r=4, h=100);
		}
	}
}

module positives() {
	hull()
	for (x=[0:1])
		for (y=[0:1])
			translate([-40 + x * 95, 30 - y * 62, 0]) cylr(r=4, h=16, rt=3);
	hull() {
		translate([55, -32, 1]) cylr(r=4, h=52.8);
		translate([55, 0, 1]) cylr(r=4, h=15);
	}
	hull() {
		translate([55, -32, 1]) cylr(r=4, h=52.8);
		translate([6, -31, 1]) cylr(r=5, h=52.8);
	}
	hull() {
		translate([6, -31, 1]) cylr(r=5, h=52.8);
		cylinder(r=12, h=53.8);
	}
	hull() {
		translate([6, -31, 1]) cylr(r=5, h=52.8);
		translate([-40, -32, 1]) cylr(r=4, h=15, rt=3);
	}
	cylr(r=12, h=80);

	translate([0, 0, 15]) difference() {
		translate([0, 0, -1]) cylinder(r=17.95, h=7);
		translate([0, 0, 6.9])
		rotate_extrude(convexity=5, $fn=16 * pi / $fs)
			translate([17.95, 0]) circle(6);
	}
}

difference() {
	positives();
	translate([0, 0, 8]) negatives();
}
