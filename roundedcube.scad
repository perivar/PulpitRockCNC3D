// Rounded cube for openscad
// by Daniel Upshaw and OpenSCAD (shapes.scad)
// Enhanced by Per Ivar Nerseth, 2015


// Usage:
// A single integer creates a cube with the specified wall distance. Default [1, 1, 1]
// size = 5;

// An [x, y, z] vector specifies distance on each axis. Default [1, 1, 1]
// size = [2, 3, 5];

// Whether or not to place the object centered on the origin. Default false
// center = true|false;

// rcube(size, center);


// Examples:

/*
color("Yellow")
rcube(3, true, 0.9);

translate(v = [1, 0, 2])
color("Pink")
rcube([4, 2, 2], false, 0.2);

translate(v = [-4, -1, 2])
color("Lightblue")
rcube(2, false);

translate(v = [0, 0, 6])
color("Orange")
rcube([3, 2, 2], true);

translate(v = [2.5, -0.5, 5])
color("Green")
rcube([3, 2, 2], false, 0.09);

translate(v = [5, -0.5, 0])
color("Blue")
rbox([3, 2, 2], false, 0.5, 40);

translate(v = [-5, 0.5, 0])
color("Gray")
rbox([3, 4, 2], false, 0.5, 4);
*/

module rcube(size = [1, 1, 1], center = false, radius = 0.5) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
	[radius, radius, radius] :
	[
	radius - (size[0] / 2),
	radius - (size[1] / 2),
	radius - (size[2] / 2)
	];

	translate(v = translate)
	minkowski() {
		cube(size = [
		size[0] - (radius * 2),
		size[1] - (radius * 2),
		size[2] - (radius * 2)
		]);
		sphere(r = radius);
	}
}

// Rounded Box
// For rounded boxes with chamfer use fn=4, 
// or use fn > 10 for properly rounded corners.
// size is a vector [w, h, d]
module rbox(size = [1, 1, 1], center = true, radius = 0.5, fn=4) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
	[radius, radius, radius] :
	[
	(size[0] / 2),
	(size[1] / 2),
	(size[2] / 2)
	];

	translate(v = translate) {
		
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
		for (x = [radius-size[0]/2, -radius+size[0]/2],
		y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true, $fn=fn);
		}
	}
}
