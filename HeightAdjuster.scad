include <MCAD/units.scad>

// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
$fa=0.5;   	// default minimum facet angle
$fs=0.5; 	// default minimum facet size

epsilon = 0.1*mm; // small tolerance used for CSG subtraction/addition
	
// mdf plate
mdfDepth = 12.7*mm;
thickness = mdfDepth + 0.5;

sideMargin = 2*mm;
bottomMargin = 2.5*mm;
height = 5 + bottomMargin;
length = 10*mm;

module HeightAdjuster() {
    
    difference() {
        translate([0,-sideMargin,-bottomMargin]) cube(size=[length,thickness+2*sideMargin,height]);	
        translate([-epsilon,0,0]) cube(size=[length+2*epsilon,thickness,height]);	
		
    }
}

HeightAdjuster();
