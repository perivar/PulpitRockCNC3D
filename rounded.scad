// Rounded primitives for openscad
// (c) 2013 Wouter Robers 
// Enhanced by Per Ivar Nerseth

// Syntax example for a rounded block
//translate([-15,0,10]) rcube([20,20,20],2);

// Syntax example for a rounded cylinder
//translate([15,0,10]) rcylinder(r1=15,r2=10,h=20,rt=2);

// Rounder Cube
module rcube(Size=[20,20,20],rt=2)
{
	hull() {
		for(x=[-(Size[0]/2-rt),(Size[0]/2-rt)]) {
			for(y=[-(Size[1]/2-rt),(Size[1]/2-rt)]) {
				for(z=[-(Size[2]/2-rt),(Size[2]/2-rt)]) { 
					translate([x,y,z]) sphere(rt);
				}
			}
		}
	}
}

// Rounded Cylinder
// For rounded cylinders with chamfer use fn=4, 
// or use fn > 10 for properly rounded corners.
module rcylinder(r1=10,r2=10,h=10,rt=2,fn=4)
{
	//translate([0,0,-h/2]) 
	hull() {
		rotate_extrude() translate([r1-rt,rt,0]) circle(r = rt, $fn=fn); 
		rotate_extrude() translate([r2-rt, h-rt, 0]) circle(r = rt, $fn=fn);
	}
}