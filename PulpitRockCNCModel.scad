
include <MCAD/bearing.scad>
include <MCAD/materials.scad>
include <stepper.scad>
use <LM8UUHolder.scad>

use <linear_bearing.scad>
use <flexible_coupling.scad>
use <20-GT2-6 Timing Pulley.scad>
use <HexagonNutHolder.scad>

// use $fa=1 and $fs=1.5 during design phase
// and 0.5 when done
$fa=0.5;   	// default minimum facet angle
$fs=0.5; 	// default minimum facet size

epsilon = 0.1*mm; // small tolerance used for CSG subtraction/addition
	
// Linear Bearing LM8UU
// 24x15mm, Inside diameter: 8mm
//linearBearing(model="LM8UU");
lm8uuLength = 24*mm;
lm8uuOutDia = 15*mm;
lm8uuInDia = 8*mm;

// 608ZZ Ball Bearing
//bearing(model=608);
608InDia = 8*mm;
608OutDia = 22*mm;
608Thickness = 7*mm;

// 23 x 48 mm wood
woodDepth = 23*mm;
woodWidth = 48*mm;
woodLength = 500*mm;

// mdf plate
mdfHeight = 500*mm;
mdfLength = 500*mm;
mdfDepth = 12.7*mm;
mdfWidth = 80*mm;
mdfHighSideLength = 200*mm;
mdfHighSideRodPos = 140*mm; // mdfHighSideLength/2

// rods
smoothRodLength = 500*mm;
threadRodLength = 500*mm;
smoothRodDia = 8*mm;
threadRodDia = 8*mm;

// Y plate dimensions
yPlateMargin = 12.3*mm;	// margin on the left and right side of the plate
yPlateMarginFrontBack = 1.15*mm;	// margin on the front and back side of the plate
yPlateWidth = mdfLength-2*mdfDepth-2*yPlateMargin;
yPlateHeight = (mdfLength-(2*mdfDepth))/2-2*yPlateMarginFrontBack; // the height of the yPlate (width in Y direction)
yPlatePos = mdfLength-mdfDepth-yPlateHeight; // from mdfDepth to mdfLength-mdfDepth-yPlateHeight

// sliding drill holder variables
slidingBackPlateLength = 76*mm;
slidingBottomPlateLength = 60*mm;			
holderHoleDiameter = 30*mm; // hole for the pen or dremmel

// Z axis and back plate
zBackPlateHeightPos = 215*mm;	// position of the zmodule compared to the rest of the CNC
zBackPlateWidth = 80*mm;		// width of the back plate
zBackPlateHeight = 220*mm;		// height of the back plate
zShortHeight = 70*mm;			// height of the short end plates
zRodMargin = 12.5*mm;				// margins from the sides for the smooth rod holes

// Z Position: min = mdfDepth, max = zBackPlateHeight-mdfDepth-slidingBackPlateLength
zPos = mdfDepth+15;

// X axis
xYCarriagePos = (mdfLength-zBackPlateWidth)/2; 	// position on the X axis. 
						// Min = mdfDepth. Middle = (mdfLength-zBackPlateWidth)/2
xRodLowPos = 250*mm;
xRodHighPos = 400*mm;
xRodMidPos = xRodLowPos + (xRodHighPos-xRodLowPos)/2;

// LM8UU bearings
yPlateBearingMargin = 10*mm;	// margin from end of plate in to bearing
yPlateBearingInset = -lm8uuOutDia/2;
yPlateBearingLowPos = yPlatePos+ lm8uuLength + yPlateBearingMargin;
yPlateBearingHighPos = yPlatePos + yPlateHeight - yPlateBearingMargin;

// LM8UU bearing parameters for the small sliding plate
slidingBearingMargin = 14*mm;	// smaller margins than yPlateBearingMargin 
								// since the sliding plate is smaller
slidingBearingLowPos = zPos+slidingBearingMargin;
slidingBearingHighPos = slidingBearingLowPos + slidingBackPlateLength - lm8uuLength - 2 *slidingBearingMargin;


// Nema17 "Screw diameter: 3 mm, distance: 31 mm, depth= 4.5 mm"
nema17HoleDist = 31.00*mm * 0.5;	// standard spec length = 31 +/- 0.1 mm  
nema17HoleRadius = 3*mm * 0.5;		// M3 screws
nema17HoleDepth = mdfDepth+1; 		// M3 screw depth
nema17Side = 42.30*mm;				// max length = 42.3 mm
nema17Mid = (nema17Side / 2);
nema17BaseHoleDia = 22*mm;			// hole big enough for nema 17 base diameter (22 mm)

stepperExtraMargin = 5*mm; 			// an additional margin to allow place for the flexible coupling

// zip-tie holes
zipTieHoleRadius = 3*mm * 0.5;	// M3 is enough for the zip-tie hole
zipTieHoleDepth = mdfDepth+1;	// M3 screw depth

// coupling nut fastener holes
couplingNutFastenerHoleRadius = 4*mm * 0.5;	// M4 is enough for the zip-tie hole
couplingNutFastenerHoleDepth = mdfDepth+1;	// M4 screw depth
couplingNutWidth = 13.2;//13*mm;	// distance from flat to flat
couplingNutLength = 36;//35*mm; 	// length of the coupling nut
couplingNutHoleDia = 8*mm;	// coupling nut hole (M8)

// z Slider information
zSliderExtraMargin = 1.5;
zSliderThickness =26;// orig: 22.5 lm8uuOutDia*zSliderExtraMargin;


// --------------------------------
// Choose view
// --------------------------------
Assembled();
//Exploded();
//Parts();
//YPlateLayout();

// full model view
module Assembled() {
    
	Front();
    Back();
    SideLeft();
    SideRight();
	Bottom();
	YPlate();
	SmoothRods();
	ThreadedRods();
	StepperMotors();
	Bearings();
	Fasteners();
	ZModule2();		
}

// exploded view
module Exploded() {
    expanded = 100;  
    translate([0, -expanded, 0]) Front();
    translate([0, expanded, 0]) Back();
    translate([-expanded, 0, 0]) SideLeft();
    translate([expanded, 0, 0]) SideRight();   
	translate([0, 0, -expanded]) Bottom();		
	translate([0, 0, expanded]) YPlate();
	
	SmoothRods();
	ThreadedRods();
	Bearings();
	Fasteners();	
	
	StepperMotors(exploded = expanded);
	
	ZModule2(exploded = expanded);
}

// stacked for laser cutting and to make dxfs
module Parts() {
    margin = 50;
	
    projection() rotate([90, 0, 0]) translate([0,0,margin]) Front();
    projection() rotate([-90, 0, 0]) translate([0,0,margin]) Back();
    projection() rotate([0, -90, 0]) translate([0,margin,margin]) SideLeft();
    projection() rotate([0,90,0]) translate([0,margin,500+margin]) SideRight();  
	projection() rotate([0,0,0]) translate([0,500+margin*2,margin]) Bottom();	
	projection() rotate([0,0,0]) translate([0,-700+margin,margin]) YPlate();
	
    /*
	projection() translate([-150,600,0]) ZModuleTop();
	projection() translate([-150,700,0]) ZModuleBack();
	projection() translate([-150,1000,0]) ZModuleBottom();	
	projection() translate([-300,700,0]) ZModuleSlidingBack();			
	projection() translate([-300,1000,0]) ZModuleSlidingBottom();
    */

    projection() translate([-150,600,0]) ZModuleBack();

}

// originally from metric_fastners.scad
// modified the flat_nut module to make it right length
// M8 * 35 mm (13mm dia)
module CouplingNut(dia=couplingNutHoleDia, width=couplingNutWidth, height=couplingNutLength) {
	
	// When you make a hexagon, the radius is the distance from the center to the corners. 
	// To get a hexagon with a specified dimension from the center to the flats (called the apothem),
	// divide your radius by cos(180/6). 
	// This works for other polygons too if you change the 6 to whatever $fn value you're using. 
	Num_Sides = 6;		// Hexagon = 6
	Nut_Flats = width; 	// Measure across the flats
	Flats_Rad = Nut_Flats/2;
	Nut_Rad = Flats_Rad / cos(180/Num_Sides);
	center = true;	
		
	// center 
	rotate([0,0,180/Num_Sides]) 
		difference()
		{
			cylinder(r=Nut_Rad,h=height,$fn=Num_Sides,center=center);
			translate([0,0,0]) cylinder(r=dia/2,h=height+2*epsilon,center=center);
		}
}

module Nema17AndPulley() {   

	// set zero at pulley start
	translate([0,0,0]) {
		motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
		translate ([0, 0, 22-16.2]) GT2Pulley();
		
		// nema 17 inclusive pulley is 65 mm tall
		//translate([0,0,-43]) cylinder(h=65, r=6); // check height
	}
}

module Nema17AndCoupling() {          

	// set zero at coupling start
	translate([0,0,-23]) 
	{
		motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);
		translate ([0, 0, 15]) FlexibleCoupling();
				
		// check that the nema 17 inclusive coupling is 83 mm tall
		//translate([0,0,-43]) cylinder(h=83, r=6); // check height
	}
	
	// check that the 8mm hole depth is correct = 17 mm
	//cylinder(h=17, r=6);
}

module SmoothRods() {
	color(Steel) {
	
		// left bottom Y rod
		rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-500]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
		
		// right bottom Y rod
		rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-500]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
				
		// low X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0, 90, 0]) cylinder(r=smoothRodDia/2,h=smoothRodLength);
		
		// high X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0, 90, 0]) cylinder(r=smoothRodDia/2,h=smoothRodLength);		
	}
}

module ThreadedRods() {
	color(Stainless) {
	
		// Y rod
		rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-threadRodLength]) 
		cylinder(r=threadRodDia/2,h=threadRodLength);	

		// X rod
		translate([0,500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0, 90, 0]) 
		cylinder(r=threadRodDia/2,h=threadRodLength);
	}
}

module Fasteners() {

	// hexagon bolt X axis
	color (Aluminum) translate([xYCarriagePos+(zBackPlateWidth/2),500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([90,0,0]) rotate([0,90,0]) CouplingNut();
	
	// X axis hex nut coupler fastener
	// 12.5 mm from center of coupling to plate
	// 6 mm from top flat to plate
	color ("White") translate([mdfLength/2,yPlatePos+(yPlateHeight/2),mdfWidth/2-stepperExtraMargin+12.5]) rotate([0,180,0]) HexagonNutHolder();
	
	// hexagon bolt Y axis
	color (Aluminum) translate([mdfLength/2,yPlatePos+(yPlateHeight/2),mdfWidth/2-stepperExtraMargin]) rotate([90,90,0]) CouplingNut();		
		
}

module LM8UUAndHolder(flip=false) {
    linearBearing(model="LM8UU");

    if (flip) {         
        rotate([0,0,180]) translate([9.8,-12.0,26.3]) rotate([0,90,90]) LM8UUHolder();
    } else {
        translate([9.8,-12.0,26.3]) rotate([0,90,90]) LM8UUHolder();
    }
        
}

module Bearings() {
	color (Aluminum) {
		
		// 608 bearing Y axis
		translate([mdfLength*1/2,mdfDepth/2,mdfWidth/2-stepperExtraMargin]) rotate([90,0,0]) bearing(model=608);
		
		// 608 bearing X axis
		translate([mdfLength-(mdfDepth/2),mdfLength-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0,90,0]) bearing(model=608);
		
								
		
		// LM8UU Y axis (second parameter is position on the rod)        
		translate([mdfLength*1/3,yPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) LM8UUAndHolder();
        
		translate([mdfLength*2/3,yPlateBearingLowPos,mdfWidth/2]) rotate([90,0,0]) LM8UUAndHolder();
        
		translate([mdfLength*1/3,yPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) LM8UUAndHolder();   
        
		translate([mdfLength*2/3,yPlateBearingHighPos,mdfWidth/2]) rotate([90,0,0]) LM8UUAndHolder();	
	}	
}

module SideChamfered(height, depth, mdfHighSideLengthidth) {
	difference() {
		cube([height,depth,mdfHighSideLengthidth]);
		
		union() {
			// first corner
			rotate([0, 0, 45]) translate([0,0,-1]) cube([mdfHighSideLengthidth*2, mdfHighSideLengthidth, mdfHighSideLengthidth+2]);

			// second corner
			translate([height,0,0]) rotate([0, 0, 45]) translate([0,0,-1]) cube([mdfHighSideLengthidth, mdfHighSideLengthidth*2, mdfHighSideLengthidth+2]);
		}
	}
}

module StepperMotors(exploded = 0) {

	// Y axis
	translate([mdfLength/2,mdfLength-23+exploded*2,mdfWidth/2-stepperExtraMargin]) rotate([90,90,0]) Nema17AndCoupling();	
	// check that the base is 41 mm heigh
	//translate([mdfLength/2,500+41,mdfWidth/2]) rotate([90,90,0]) cylinder(r=10, h=41);
	
	// X axis
	translate([23-exploded*2,500-(mdfHighSideRodPos)-mdfDepth+stepperExtraMargin,xRodMidPos]) rotate([0,90,0]) Nema17AndCoupling();	
}

module Nema17ScrewHoles() {
	translate([nema17Mid+nema17HoleDist,nema17Mid+nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid-nema17HoleDist,nema17Mid+nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid+nema17HoleDist,nema17Mid-nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
	translate([nema17Mid-nema17HoleDist,nema17Mid-nema17HoleDist,-1*mm]) cylinder(h=nema17HoleDepth+1*mm, r=nema17HoleRadius);
}

module ZipTieBearingHoles() {
    
    screw_margin = 0; //0.6;
    screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4

    translate([-7.25,3.85,-1*mm])
    cylinder(h=zipTieHoleDepth+1*mm, r=screw_dia/2);

    translate([22.35,3.85,-1*mm])
    cylinder(h=zipTieHoleDepth+1*mm, r=screw_dia/2);

    translate([-7.25,20.06,-1*mm])
    cylinder(h=zipTieHoleDepth+1*mm, r=screw_dia/2);

    translate([22.35,20.06,-1*mm])
    cylinder(h=zipTieHoleDepth+1*mm, r=screw_dia/2);
    
    /*
	zipTieMarginSide = zipTieHoleRadius;		// margin in the bearing width direction (diameter)
	zipTieMarginLength = zipTieHoleRadius+2;	// margin in the bearing length direction

	translate([-zipTieMarginSide,zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
	
	translate([lm8uuOutDia+zipTieMarginSide,zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
	
	translate([-zipTieMarginSide,lm8uuLength-zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);

	translate([lm8uuOutDia+zipTieMarginSide,lm8uuLength-zipTieMarginLength,-1*mm]) cylinder(h=zipTieHoleDepth+1*mm, r=zipTieHoleRadius);
    */
}

module CouplingNutFastenerHoles() {

	screw_dia = 4*mm;	
	screw_space_x = 26;
	screw_space_y = 29;
		
	// screw holes
	translate([screw_space_x/2,screw_space_y/2,-epsilon])
	cylinder(r=screw_dia/2, h=mdfDepth+2*epsilon, $fn=20);
	translate([-screw_space_x/2,screw_space_y/2,-epsilon])
	cylinder(r=screw_dia/2, h=mdfDepth+2*epsilon, $fn=20);
	translate([screw_space_x/2,-screw_space_y/2,-epsilon])
	cylinder(r=screw_dia/2, h=mdfDepth+2*epsilon, $fn=20);
	translate([-screw_space_x/2,-screw_space_y/2,-epsilon])
	cylinder(r=screw_dia/2, h=mdfDepth+2*epsilon, $fn=20);
}

module Front() {
    color(Pine)
    {	
		difference() {
			cube(size=[mdfLength,mdfDepth,mdfWidth]);
			echo("Front dimensions in mm: ", mdfLength, mdfDepth, mdfWidth);
			
			union() {				
				// first hole
				rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

				// second hole
				rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

				// middle hole
				rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-mdfDepth-1]) cylinder(r=608OutDia/2,h=mdfDepth+2);				
			}
		}
    }	
}

module Back() {
    color(Pine)
    {
		translate([0,mdfLength-mdfDepth,0]) {
			difference() {
				cube(size=[mdfLength,mdfDepth,mdfHeight]);
				echo("Back dimensions in mm: ", mdfLength, mdfDepth, mdfHeight);

				union() {				
					// first hole
					rotate([90, 0, 0]) translate([mdfLength*1/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfLength*2/3,mdfWidth/2,-mdfDepth-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfLength*1/2,mdfWidth/2-stepperExtraMargin,-mdfDepth-1]) cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);
					
					// screw holes
					translate([mdfLength/2-nema17Mid,mdfDepth,mdfWidth/2-nema17Mid-stepperExtraMargin]) rotate([90,0,0]) Nema17ScrewHoles(); 		
										
					// window
					rotate([90, 0, 0]) translate([150,250,-mdfDepth-1]) cube([200,150,mdfDepth+2]);
				}					
			}
		}
    }
}

module SideLeft() {
    color(Oak)
	{
		// mdf side
		rotate([0,0,-90]) translate([-mdfLength+mdfDepth,0,0]) 
		{
			difference() {
				cube(size=[mdfLength-(mdfDepth*2),mdfDepth,mdfHeight]);
				echo("Left Side dimensions in mm: ", mdfLength-(mdfDepth*2), mdfDepth, mdfHeight, mdfWidth);
				
				union() {
					// cut out a rounded cube
					translate([mdfHighSideLength,mdfDepth+1,mdfWidth]) rotate([90,0,0]) rbox(size=[mdfHeight, mdfLength, mdfDepth+2], radius=50, fn=30); 
					
					// first hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodLowPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodHighPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos-stepperExtraMargin,xRodMidPos,-mdfDepth-1]) 
					cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);			

					// screw holes
					translate([mdfHighSideRodPos-nema17Mid-stepperExtraMargin,mdfDepth,xRodMidPos-nema17Mid]) rotate([90,0,0]) Nema17ScrewHoles(); 		

				}
			}
		}
	}
}

module SideRight() {
    color(Oak)
	{	
		// mdf side
		rotate([0,0,-90]) translate([-mdfLength+mdfDepth,mdfLength-mdfDepth,0]) 
		{
			difference() {
				cube(size=[mdfLength-(2*mdfDepth),mdfDepth,mdfHeight]);
				echo("Right Side dimensions in mm: ", mdfLength-(mdfDepth*2), mdfDepth, mdfHeight, mdfWidth);

				union() {
					// cut out a rounded cube
					translate([mdfHighSideLength,mdfDepth+1,mdfWidth]) rotate([90,0,0]) rbox(size=[mdfHeight, mdfLength, mdfDepth+2], radius=50, fn=30); 
					
					// first hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodLowPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// second hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos,xRodHighPos,-mdfDepth-1])  cylinder(r=smoothRodDia/2,h=mdfDepth+2);

					// middle hole
					rotate([90, 0, 0]) translate([mdfHighSideRodPos-stepperExtraMargin,xRodMidPos,-mdfDepth-1]) 
					cylinder(r=608OutDia/2,h=mdfDepth+2);										
				}
			}
		}
	}   
}

module Bottom() {
    color(Birch)
    {
		translate([0,0,-mdfDepth]) cube(size=[mdfLength,mdfHeight,mdfDepth]);
		echo("Bottom dimensions in mm: ", mdfLength, mdfHeight, mdfDepth);
	}
}

module YPlate() {
		
	translate([mdfDepth+yPlateMargin,yPlatePos,(mdfWidth/2)+(lm8uuOutDia/2*mm)]) 
	{ 
		// debug pointer to find middle position on Y plate
		//translate([xYCarriagePos+8, 0, 0]) cylinder(r=10, h=300); // mid position
	
		// store the mid position for the threaded rod
		threadedRodMidPos = (mdfLength*1/2)-(mdfDepth+yPlateMargin);
		
		// plate
		color(Pine) {
			difference() {
				cube(size=[yPlateWidth,yPlateHeight,mdfDepth]);
				echo("YPlate dimensions in mm: ", yPlateWidth, yPlateHeight, mdfDepth);					
				
				union() {				
					// bearing positions
					bearingLeftPos = (mdfLength*1/3)-(mdfDepth+yPlateMargin)
					-( lm8uuOutDia / 2);
					bearingRightPos = (mdfLength*2/3)-(mdfDepth+yPlateMargin)
					-( lm8uuOutDia / 2);				
														
					// cut out room for the zip-ties
					// top bearings zip-tie holes
					translate([bearingLeftPos,yPlateBearingMargin,0]) ZipTieBearingHoles();
					
					translate([bearingRightPos,yPlateBearingMargin,0]) ZipTieBearingHoles();

					// bottom bearings zip-tie holes
					translate([bearingLeftPos,yPlateHeight-yPlateBearingMargin-lm8uuLength,0]) ZipTieBearingHoles();
					
					translate([bearingRightPos,yPlateHeight-yPlateBearingMargin-lm8uuLength,0]) ZipTieBearingHoles();
			
					// cut out room for the Coupling Nut fastener screw
					translate([threadedRodMidPos,yPlateHeight/2, 0]) CouplingNutFastenerHoles();
                    
                    
                    // cut out room for M8 screws
                    m8Margin = 15*mm;
                    m8screwRadius = (8*mm + 0.6) * 0.5;	// M8 screw    
                    
                    // bottom left
                    translate([m8Margin,m8Margin,-epsilon]) cylinder(h=mdfDepth+2*epsilon, r=m8screwRadius);
                    
                    // bottom right
                    translate([yPlateWidth-m8Margin,m8Margin,-epsilon]) cylinder(h=mdfDepth+2*epsilon, r=m8screwRadius);

                    // top left
                    translate([m8Margin,yPlateHeight-m8Margin,-epsilon]) cylinder(h=mdfDepth+2*epsilon, r=m8screwRadius);                    
                    // top right
                    translate([yPlateWidth-m8Margin,yPlateHeight-m8Margin,-epsilon]) cylinder(h=mdfDepth+2*epsilon, r=m8screwRadius);                    
				}
			}
		}		
	}			
}

module ZModuleBackHoles() {
	
    // top bearings zip-tie holes
    translate([yPlateBearingMargin+lm8uuLength,xRodLowPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();
		
	translate([yPlateBearingMargin+lm8uuLength,xRodHighPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();

	// bottom bearings zip-tie holes
	translate([zBackPlateWidth-yPlateBearingMargin,xRodLowPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();
			
	translate([zBackPlateWidth-yPlateBearingMargin,xRodHighPos-zBackPlateHeightPos-(lm8uuOutDia/2),0]) rotate([0,0,90]) ZipTieBearingHoles();    
}

module ZModuleBack() {

	color(Oak) 
	{
		difference() {	
			// back plate
			cube(size=[zBackPlateWidth,zBackPlateHeight,mdfDepth]);
			echo("ZModule back plate dimensions in mm: ", zBackPlateWidth, zBackPlateHeight, mdfDepth);
			
			// cut out room for the zip-ties
            ZModuleBackHoles();

			// cut out room for the Coupling Nut fastener screw
			translate([zBackPlateWidth/2,xRodMidPos-zBackPlateHeightPos,0]) rotate([0,0,90]) CouplingNutFastenerHoles();
		}
	}
	
	// z axis hex nut coupler fastener
	// 12.5 mm from center of coupling to plate
	// 6 mm from top flat to plate
	color ("White") translate([zBackPlateWidth/2,xRodMidPos-zBackPlateHeightPos,0]) rotate([0,180,90]) HexagonNutHolder();	
}

// top plate with motor fastener
module ZModuleTop() {
	color(Oak) 
	{
		difference() {			
			cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
			echo("ZModule short plate dimensions in mm: ", zBackPlateWidth, zShortHeight, mdfDepth);								
			// first hole
			translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

			// second hole
			translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

			// middle hole
			translate([zBackPlateWidth/2,zShortHeight/2+stepperExtraMargin,-1]) cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);

			// screw holes
			translate([zBackPlateWidth/2-nema17Mid,zShortHeight/2-nema17Mid+stepperExtraMargin,0]) Nema17ScrewHoles(); 		
		}
	}
}

module ZModuleBottom() {
	color(Oak) 
	{
		difference() {			
			cube(size=[zBackPlateWidth,zShortHeight,mdfDepth]);
			
			// first hole
			translate([zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

			// second hole
			translate([zBackPlateWidth-zRodMargin,zShortHeight/2,-1]) cylinder(r=smoothRodDia/2,h=mdfDepth+2);

			// middle hole
			translate([zBackPlateWidth/2,zShortHeight/2+stepperExtraMargin,-1]) cylinder(r=608OutDia/2,h=mdfDepth+2);																			
		}
	}
}

// sliding back plate
module ZModuleSlidingBack() {
	difference() {
		cube(size=[zBackPlateWidth,slidingBackPlateLength,mdfDepth]);
		
		// cut out room for the zip-ties
		// top bearings zip-tie holes
		translate([zRodMargin-lm8uuOutDia/2,slidingBackPlateLength-lm8uuLength-slidingBearingMargin,0]) ZipTieBearingHoles();
	
		translate([zBackPlateWidth-zRodMargin-lm8uuOutDia/2,slidingBackPlateLength-lm8uuLength-slidingBearingMargin,0]) ZipTieBearingHoles();

		// bottom bearings zip-tie holes
		translate([zRodMargin-lm8uuOutDia/2,slidingBearingMargin,0]) ZipTieBearingHoles();
	
		translate([zBackPlateWidth-zRodMargin-lm8uuOutDia/2,slidingBearingMargin,0]) ZipTieBearingHoles();

		// cut out room for the Coupling Nut fastener screw
		translate([zBackPlateWidth/2,slidingBackPlateLength/2,0]) CouplingNutFastenerHoles();
	}
}

module ZModuleSlidingBottom() {
	difference() {					
		// bottom plate
		translate([0,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-slidingBottomPlateLength,zPos]) 
		cube(size=[zBackPlateWidth,slidingBottomPlateLength,mdfDepth]);
		
		// hole for the pen or dremmel
		translate([zBackPlateWidth/2,-2*mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-(slidingBottomPlateLength/2),zPos-1]) cylinder(r=holderHoleDiameter/2,h=mdfDepth+2);
	}
}

module ZModuleBackBearings() {

		// LM8UU X axis (first parameter is position on the rod, last parameter is height)
		translate([xYCarriagePos+yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0,90,0]) LM8UUAndHolder(true);
		translate([xYCarriagePos+yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0,90,0]) LM8UUAndHolder(true);       
		translate([xYCarriagePos+zBackPlateWidth-lm8uuLength-yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodLowPos]) rotate([0,90,0]) LM8UUAndHolder(true);       
		translate([xYCarriagePos+zBackPlateWidth-lm8uuLength-yPlateBearingMargin,500-(mdfHighSideRodPos)-mdfDepth,xRodHighPos]) rotate([0,90,0]) LM8UUAndHolder(true);       
}

module ZModule(exploded = 0) {
	
    ZModuleBackBearings();
    
	translate([xYCarriagePos,500-(mdfHighSideRodPos)-mdfDepth-lm8uuOutDia/2*mm-exploded,zBackPlateHeightPos]) 
	{					
		// back plate
		rotate([90,0,0]) ZModuleBack();
		
		// top plate with motor fastener
		translate([0,-(zShortHeight+mdfDepth)-exploded,zBackPlateHeight-mdfDepth]) ZModuleTop();
		
		// bottom plate
		translate([0,-(zShortHeight+mdfDepth)-exploded,0]) ZModuleBottom();
			
		// 608 bearing Z axis
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,mdfDepth/2-608Thickness/2]) bearing(model=608);
						
		// stepper motor at the top with coupling
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)-exploded+stepperExtraMargin,-2+zBackPlateHeight-23+exploded]) rotate([180,0,0]) Nema17AndCoupling();	
			
		// sliding drill holder
		color (Pine) { 			
			// back plate
			translate([0,-mdfDepth-(zShortHeight/2)-(lm8uuOutDia/2)-exploded*2,zPos+exploded]) 
			rotate([90,0,0]) 
			ZModuleSlidingBack();
			
			translate([0,-exploded*2,0]) ZModuleSlidingBottom();
		}
		
		// Rods
		zRodLength = zBackPlateHeight; // smoothRodLength;
		color(Steel) {
			// left Z rod
			translate([zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
			
			// right Z rod
			translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
		}
		
		color(Stainless) {
			// Z threaded rod
			translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,0]) cylinder(r=threadRodDia/2,h=zRodLength);
		}

		// LM8UU bearings
		// From min: mdfDepth 
		// To max: 	 zBackPlateHeight-mdfDepth-lm8uuLength
		
		// LM8UU on left rod (third parameter is position on the rod)
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");

		// LM8UU on right rod (third parameter is position on the rod)
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");		
		
		// hexagon bolt Y axis
		color (Aluminum) translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,zPos+(slidingBackPlateLength/2)]) rotate([0,0,90]) CouplingNut();
		
		// Y axis hex nut coupler fastener
		// 12.5 mm from center of coupling to plate
		// 6 mm from top flat to plate
		color ("White") translate([zBackPlateWidth/2,-12.5-mdfDepth-(zShortHeight/2)+stepperExtraMargin,zPos+(slidingBackPlateLength/2)]) rotate([-90,0,0]) HexagonNutHolder();				
	}
}

module ZModule2(exploded = 0) {
        
    ZModuleBackBearings();
    
	translate([xYCarriagePos,500-(mdfHighSideRodPos)-mdfDepth-lm8uuOutDia/2*mm-exploded,zBackPlateHeightPos]) 
	{					
		// back plate
		rotate([90,0,0]) ZModuleBack();
		        
        // plate holders
        translate([zBackPlateWidth/2,-mdfDepth-exploded,zBackPlateHeight]) rotate([-90,0,180]) YCarriage();
        

    // sliding drill holder back
    translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) rotate([90,0,0]) 
        {   
            translate([0,0,exploded]) ZSliderTop();
            translate([0,0,-exploded/5]) ZSliderBottom();
        }
        
    // extension to get the drill holder lower
    translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) DremelExtension();
            
    translate([11.5,-60.70-2*exploded-20,zPos-66]) rotate([90,0,0]) Dremel395Mount();	   
			
		// 608 bearing Z axis
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,mdfDepth/2-608Thickness/2]) bearing(model=608);
						
		// stepper motor at the top with coupling
		translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)-exploded+stepperExtraMargin,-2+zBackPlateHeight-23+exploded]) rotate([180,0,0]) Nema17AndCoupling();	
					
		// Rods
		zRodLength = zBackPlateHeight; // smoothRodLength;
		color(Steel) {
			// left Z rod
            translate([zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
			
			// right Z rod
			translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),0]) cylinder(r=smoothRodDia/2,h=zRodLength);
		}
		
		color(Stainless) {
			// Z threaded rod
			translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,0]) cylinder(r=threadRodDia/2,h=zRodLength);
		}

		// LM8UU bearings
		// From min: mdfDepth 
		// To max: 	 zBackPlateHeight-mdfDepth-lm8uuLength
		
		// LM8UU on left rod (third parameter is position on the rod)
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");

		// LM8UU on right rod (third parameter is position on the rod)
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingLowPos]) linearBearing(model="LM8UU");
		translate([zBackPlateWidth-zRodMargin,-mdfDepth-(zShortHeight/2),slidingBearingHighPos]) linearBearing(model="LM8UU");		
		
		// hexagon bolt Y axis
		color (Aluminum) translate([zBackPlateWidth/2,-mdfDepth-(zShortHeight/2)+stepperExtraMargin,zPos+(slidingBackPlateLength/2)]) rotate([0,0,0]) CouplingNut();

	}
}

module SmallNut()
{
    // m4
    // orig height = 3
	cylinder(h=6,r=8/2+epsilon,$fn=6);
}

module Triangle(width,height,thick)
{
    linear_extrude(height = thick, center = false, convexity = 10, twist = 0)
		polygon(points=[[0,0],[height,0],[0,width]], paths=[[0,1,2]]);
}

// a common base that both the left and right half are derived from
module YSupportCommon()
{  
    baseThickness = 10*mm;
    baseHeight = zBackPlateWidth;
    baseLength = 56;
    supportThickness = 8*mm;
    marginY = zBackPlateWidth/2-zRodMargin;
    extraRodMargin = 1.5; // 40% bigger     
    rodsize = smoothRodDia;
    rodHolderHeight = 20;
    supportLength = baseLength-baseThickness-8;
    
	difference()
	{
		union()
		{
            // side
			translate([-baseHeight/2,0,0])
            cube([baseHeight,baseThickness,baseLength]);

            // back that connects to the wood plate
			translate([-baseHeight/2,0,0])			
				cube([baseHeight,baseLength,baseThickness]);

            // left rod holder
			translate([-marginY,0,zShortHeight/2])		
				rotate([-90,0,0]) 
					cylinder(h=rodHolderHeight,r=(rodsize*extraRodMargin)/2);

			// right rod holder
            translate([marginY,0,zShortHeight/2])		
				rotate([-90,0,0]) 
					cylinder(h=rodHolderHeight,r=(rodsize*extraRodMargin)/2);

			
			// left support 
			translate([baseHeight/2,baseThickness-epsilon,baseThickness-epsilon])
				rotate([0,-90,0]) 
					Triangle(supportLength,supportLength,supportThickness);

			// right support
			translate([-baseHeight/2+supportThickness,baseThickness-epsilon,baseThickness-epsilon])			    
				rotate([0,-90,0]) 
					Triangle(supportLength,supportLength,supportThickness);

		}
        
        // small hole to keep the rods in place
        smallHoleDepth = marginY-6;
        
		// left
        translate([marginY,baseThickness/2,baseLength-smallHoleDepth])		
				SmallNut();
        translate([marginY,baseThickness/2,baseLength-smallHoleDepth+epsilon])		
				cylinder(h=smallHoleDepth+2*epsilon,r=3/2,$fn=33);

		// right
		translate([-marginY,baseThickness/2,baseLength-smallHoleDepth])		
				SmallNut();
		translate([-marginY,baseThickness/2,baseLength-smallHoleDepth+epsilon])		
				cylinder(h=smallHoleDepth+2*epsilon,r=3/2,$fn=33);

		// take out the place for the holes
		translate([yPlateBearingMargin+lm8uuLength-4.1,baseHeight-52.6,0]) rotate([0,0,90]) ZipTieBearingHoles();
        translate([yPlateBearingMargin+lm8uuLength-40.1,baseHeight-52.6,0]) rotate([0,0,90]) ZipTieBearingHoles();


		// hollow out the rod holders
		// left rod	
			translate([-marginY,-epsilon,zShortHeight/2]) 		
				rotate([-90,0,0]) 
					cylinder(h=30,r=(rodsize)/2);

        // right rod
		translate([marginY,-epsilon,zShortHeight/2]) 		
			rotate([-90,0,0]) 
				cylinder(h=30,r=(rodsize)/2);

	}
}

// The section with the stepper motor
// this is going to be somewhat low-profile and kind of hefty
module YSupportTop()
{
	difference()
	{
		YSupportCommon();
        
		// take out a place for the stepper mount
		translate([0,12,zBackPlateWidth/2-10])
			rotate([90,0,0]) 
				StepperMount();
	}
}

// The section with the idler bearing
module YSupportBottom()
{    
    pos = 10;
    
	difference()
	{
		YSupportCommon();

		// space for a 608 bearing
		translate([0,pos+epsilon,zBackPlateWidth/2-10])
			rotate([90,0,0]) 
				cylinder(h=608Thickness+2*epsilon,r=608OutDia/2);

		// and a hole for the center threaded rod
		translate([0,pos+epsilon,zBackPlateWidth/2-10])
			rotate([90,0,0]) 
				cylinder(h=10+2*epsilon,r=(threadRodDia+3)/2);
	}
}

module StepperMount(cx=0,cy=0,cz=0)
{

	// make a hole for the stepper
	translate(v=[cx,cy,cz])
	{
		cylinder(r=nema17BaseHoleDia/2,h=mdfDepth+2);            		

		// screw holes
		translate([-nema17Mid,-nema17Mid,0])  Nema17ScrewHoles(); 		
	}         
}

module YCarriage()
{
	translate([0,0,0])
		YSupportTop();
    
	translate([0,zBackPlateHeight,0])
		rotate([0,0,180])
			YSupportBottom();
}

module CouplerNutHolder()
{
    size = couplingNutLength;
    
	difference()
	{
		union()
		{
			cube(size=[size,size,5],center = true);
		}
	}
}

module FakeBolt(screw_length = 40)
{
    screw_margin = 0.6;
screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 7.7 + screw_margin; // M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 3.0 + screw_margin; // M3 = 2.3 mm, M4 = 3 mm - orig. 3
    
	union()
	{
		cylinder(h=screw_length,r= screw_dia/2);
		cylinder(h=nut_height+epsilon,r= nut_dia/2, $fn=6);
	}
}

module Dremel395Mount() {
    width = 56.85; // 55
    height = 68; // 60
    thickness = 9;
    
    difference() {
        union() {
    translate([-71.575,-66,0]) import("Dremel/Dremel_395_Prusa_i3_Mount.stl", convexity=5);

    cube([width,height,thickness]);
        }
        
        // the screw holes
        translate([28.5,33.8,-10]) ZSliderHolePattern();
    }
}

module DremelExtension() {
    // extension to get the drill holder lower
    extHeight = 60;
    extWidth = 55;
    extThickness = 20;
    
    
    translate([-extWidth/2,-extThickness-13,-extHeight+30]) {
       difference() { 
            cube([extWidth,extThickness,extHeight]);
           
        // the screw holes
        translate([27.5,extThickness+20-epsilon,30]) rotate([90,0,0]) ZSliderHolePattern();
           
        }         
    }
    
    // support
    translate([-extWidth/2,-extThickness-3,-extHeight+30]) {
        rotate([0,90,0]) Triangle(10,20,55);
    }
    
    translate([-extWidth/2,-extThickness-13,-extHeight-40]) {
       difference() { 
            cube([extWidth,10,extHeight+20]);
           
        // the screw holes
        translate([27.5,extThickness+epsilon,30]) rotate([90,0,0]) ZSliderHolePattern();
           
        }         
    }
     
}

module ZSliderHolePattern(screw_length = 40)
{
    screw_margin = 0.6;
    screw_dia = 4.0 + screw_margin; // M3 = 3 mm, M4 = 4 mm - orig. 3.4
    
    //boltsize = 6; // assume 6 mm bolts to hold this to the base
    
	holeXOffset = 12;
	holeYOffset = 12;
   
    translate([holeXOffset,holeYOffset,0])			
			FakeBolt(screw_length);   
    translate([-holeXOffset,holeYOffset,0])			
			FakeBolt(screw_length);
	translate([holeXOffset,-holeYOffset,0])			
			FakeBolt(screw_length);
	translate([-holeXOffset,-holeYOffset,0])			
			FakeBolt(screw_length);
}

module ZSliderLockHoles() {

    boltZPos = zSliderThickness/2+epsilon;
    boltHeadDia = 8;
    boltHeadHeight = 3.5;

	holeXOffset = 15;
	holeYOffset = 23;
   
    translate([holeXOffset,holeYOffset,-boltZPos]){			
		FakeBolt();   
        translate([0,0,zSliderThickness-boltHeadHeight+2*epsilon]) cylinder(h=boltHeadHeight, r=boltHeadDia/2);
    }
    translate([-holeXOffset,holeYOffset,-boltZPos]) {			
			FakeBolt();
        translate([0,0,zSliderThickness-boltHeadHeight+2*epsilon]) cylinder(h=boltHeadHeight, r=boltHeadDia/2);
    }
	translate([holeXOffset,-holeYOffset,-boltZPos]) {			
			FakeBolt();
        translate([0,0,zSliderThickness-boltHeadHeight+2*epsilon]) cylinder(h=boltHeadHeight, r=boltHeadDia/2);
    }
	translate([-holeXOffset,-holeYOffset,-boltZPos]) {			
			FakeBolt();
        translate([0,0,zSliderThickness-boltHeadHeight+2*epsilon]) cylinder(h=boltHeadHeight, r=boltHeadDia/2);
    }
}

module ZSlider()
{
    sliderHeight = 60;
    sliderWidth = 55;
    
    doubleBearingHeight = lm8uuLength*2 + 3;    
    // lm8uuLength = 24*mm;
    bearingDia = lm8uuOutDia;
    
    // added to the diameter for margin
    rodMargin = 2;
    
    echo ("ZSlider thickness: ", zSliderThickness);
    
	difference()
	{
		union()
		{

			translate([0,0,0])
				cube(size=[sliderWidth,sliderHeight,zSliderThickness],center = true);

			// the round holder parts for the bushings
			translate([-sliderWidth/2,sliderHeight/2,0])
				rotate([90,0,0])
					cylinder(h=sliderHeight,r=zSliderThickness/2,$fn=33);
			
            translate([sliderWidth/2,sliderHeight/2,0])
				rotate([90,0,0])
					cylinder(h=sliderHeight,r=zSliderThickness/2,$fn=33);

            //translate([0,0,-13]) CouplerNutHolder();
		
            // add z-end stop holder
            translate([20,25,-13]) cube([30-epsilon,5,zSliderThickness]);
		}

        // add holes to lock the two parts of the slider together
        ZSliderLockHoles();

        // this was way to tight!
        // therefore increased the coupling nut dia and height
		translate([0,0,-5])
			rotate([90,0,0])
                CouplingNut();
        
		// the OD cutouts of the bushings inside the bushing holders

        translate([-sliderWidth/2,doubleBearingHeight/2,0])
			rotate([90,0,0])
				cylinder(h=doubleBearingHeight,r=(bearingDia)/2,$fn=33);
		translate([sliderWidth/2,doubleBearingHeight/2,0])
			rotate([90,0,0])
				cylinder(h=doubleBearingHeight,r=(bearingDia)/2,$fn=33);
			
            // the cutouts for the rails
		translate([-sliderWidth/2,sliderHeight/2+epsilon,0])
			rotate([90,0,0])
				cylinder(h=sliderHeight+2*epsilon,r=(smoothRodDia+rodMargin)/2,$fn=33);
		
        translate([sliderWidth/2,sliderHeight/2+epsilon,0])
			rotate([90,0,0])
				cylinder(h=sliderHeight+2*epsilon,r=(smoothRodDia+rodMargin)/2,$fn=33);
		
        // the threaded rod
		translate([0,100,-5])
			rotate(a=[90,0,0])
				cylinder(h=200,r=(threadRodDia+rodMargin)/2,$fn=33);

    // holes to keep the slider addons in place
    translate([0,0,zSliderThickness/2-30+4-epsilon])
			ZSliderHolePattern(screw_length=30);

	}
}

module ZSliderBottom()
{
    cutAwayThickness = 20;
    
	difference(){
        ZSlider();
        
        translate([0,0,cutAwayThickness/2])
            cube(size=[100,100,20],center= true);
        
        // add another coupling nut and shift it so that we open up enough room to let the nut enter the casing
        translate([0,0,0])
			rotate([90,0,0])
                CouplingNut();

        // add another rod and shift it so that we open up anough room to let the rod enter the casing
        // the threaded rod
        cubeSize = threadRodDia+2;
		translate([-cubeSize/2,-100,-cubeSize/2])
                cube([cubeSize,200,cubeSize]);    
	}    
}

module ZSliderTop()
{
    cutAwayThickness = 20;
    
    difference() {
        ZSlider();
	
        translate([0,0,-cutAwayThickness/2])
            cube(size=[100,100,cutAwayThickness],center= true);
	}
}

module ZSliderTopLayout() {

    translate([0,0,zSliderThickness/2]) 
        rotate([180,0,0]) 
            ZSliderTop();
}

module ZSliderBottomLayout() {
    
    translate([0,0,zSliderThickness/2]) 
        ZSliderBottom();
}

module ZSliderLayout() {
    
    ZSliderTopLayout();
    translate([0,65,0]) ZSliderBottomLayout();
}

module YPlateLayout() {
    //translate([mdfDepth+yPlateMargin,yPlatePos,(mdfWidth/2)+(lm8uuOutDia/2*mm)]) 
    
    // reset the position to zero
    projection() rotate([0,0,0]) translate([-mdfDepth-yPlateMargin,-yPlatePos,0]) YPlate();
}

//!ZSlider();
//!YSupportTop();
//!YSupportBottom();
//!SliderBottom();
//!SliderTop();

//!ZSliderLayout();
//!ZSliderTopLayout();
//!ZSliderBottomLayout();
//!Dremel395Mount();
//!translate([0,0,33]) rotate([90,0,0]) DremelExtension();