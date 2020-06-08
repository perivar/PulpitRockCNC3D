/*
Name: RAMPS 1.4 box in OpenSCAD
Author: Jons Collasius from Germany/Hamburg

License: CC BY-NC-SA 4.0
License URL: https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

/* [Global] */
// ######## global variables ########

// what part to print
part = 3; // [1:print just the box,2:print just the lid,3:print the box and the lid] 
// resolution of round object. each line segment is fnr mm long. fnr = 1 crude and good for development (its faster), aim for fnr = 0.4 or smaller for a production render. smaller means more detail (and a lot more time to render).
resolution = 0.4;
// extrusion thicknesses of your nozzle
single_wall 		= 0.6;
// hight of the box (65 is a fair choice, ad some mm if you want to mount the top fan inside the case)
box_hight = 65;
// mount type
mount_type = 1; // [0:without any mount holes,1:4 bottom mounts holes - spaced 30*60 and centered]
// extend the box for the RepRap Discount Full Graphic Smart Controller adapter
smartadapter			= false; // [true:YES box with xtra space for the smart adapter,false:NO without smart adapter]
// add a fan hole and mounts in the lid	
topfan					= true;	// [true:YES with top fan,false:NO without top fan]
// style of the back side, open, closed or with fan mount
backstyle = 1; // [1:open,2:with fan hole and mounts,3:closed]
// make the reset button accessible and add a push button
resetbutton				= true;	//[true:YES with reset button,false:NO without reset button]	
// extra space in front of the board
ramps_xtra_front         = 0;
// extra space behind the board (maybe for a fan, mounted inside the case?)
ramps_xtra_back         = 0;
// extra space left of the board
ramps_xtra_left         = 0;
// extra space right of the board
ramps_xtra_right         = 0;
// extrusion factor of the thickness of the lid (single_wall * X)
factor_lid 			= 3;
// extrusion factor of the thickness of the bottom (single_wall * X)
factor_bottom 		= 3;
// extrusion factor of the thickness of the front wall (single_wall * X)
factor_front 		= 3;
// extrusion factor of the thickness of the back wall (single_wall * X)
factor_back 		= 3;
// extrusion factor of the thickness of the left wall (single_wall * X)
factor_left 		= 3;
// extrusion factor of the thickness of the right wall (single_wall * X)
factor_right 		= 3;
// extrusion factor of the thickness of the corners (single_wall * X)
factor_corners 		= 3;
// extrusion factor of the thickness of the boardmounts (single_wall * X)
factor_boardmounts 	= 3;
// overdepositing of your 3d printer (if prining a hole, how much to enlarge the hole for perfect fit). leave at 0 if you don't know what this means.
compensate 				= 0;		
// hight of the ramps mounts (spacing between the bottom and the board)
ramps_z_spacing 		= 5;
// bridge the front (and back in any) with a Xmm bridge. should match the hight of your lid fan (if selected)
bridgetop				= 20;		
// diameter of the self tapping screws to mount the board and the lid
metallscrew_d			= 2.8;	
// length of the self tapping screws to mount the lid
metallscrew_l 			= 30;	
// diameter of the fan (if any)
fan_d 					= 60;
// diameter the the mounting holes of the fan
fan_screws_d 			= 4.4;
// x/y offset of the screw holes from the center of the fan
fan_offset_screws 		= 25;

/* [Hidden] */

ramps_x = 60.50;	
ramps_y = 101.62;
ramps_z = box_hight;

fan_screws_r 			= fan_screws_d/2;
metallscrew_r 			= metallscrew_d/2;
screw_m3_r				= 1.6;
fan_r 					= fan_d/2;
backfan					= backstyle==2?true:false;
backopening				= backstyle==1?true:false;
thickness_lid 			= factor_lid*single_wall;
thickness_bottom 		= factor_bottom*single_wall;
thickness_front 		= factor_front*single_wall;
thickness_back 		    = factor_back*single_wall;
thickness_left 		    = factor_left*single_wall;
thickness_right 		= factor_right*single_wall;
ticknesss_corners 		= factor_corners*single_wall;
ticknesss_boardmounts 	= factor_boardmounts*single_wall;

ramps_calc_y = smartadapter?ramps_y+9:ramps_y;
backopening_bottomwall = smartadapter?27:14;

// legacy
knight_extrusion_width	= 20;		// width of the aluminium extrusions used by MetaStasis.DE jCollasius Knight 3D Printer
knight_extrusion_screw_r	= 2.1;	// radius of the used screws for the aluminium extrusions
knightmount				= false;	// add mounting holes for MetaStasis.DE jCollasius Knight 3D Printer
factor_knightmount 	= 3;
thickness_knightmount 	= factor_knightmount*single_wall;

print_part();

module print_part() {
	if (part == 1) {
		rampsbox();
	} else if (part == 2) {
		rampslid();
	} else if (part == 3) {
		rampsbox();
		translate([-(ramps_xtra_left+ramps_x+single_wall*2+ramps_xtra_right+ticknesss_corners*4+metallscrew_d*2),0,0]) rampslid();
	}
}
// #####################################################################################################################################
module cnccube(x=10, y=10, z=10, r=1.5, w=2) {
	difference() {
		union() {
			for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate(i1) fncylinder(r=r, h=z);
			translate([x/2,y/2,0]) {
				centercube([x+r*4,y+r*2,z],x=true,y=true);
				centercube([x+r*2,y+r*4,z],x=true,y=true);
			}
		}
		difference() {
			translate([-r*2+thickness_left,-r*2+thickness_front,w]) cube([x+r*4-thickness_left-thickness_right,y+r*4-thickness_front-thickness_back,z]);
			for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate(i1) fncylinder(r=r, h=z,enlarge=1);
		}
		for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate([i1[0],i1[1],z]) rotate([180,0,0])
            fncylinder(r=metallscrew_r, h=metallscrew_l-thickness_lid,enlarge=2);
	}
}


// #####################################################################################################################################
module rampsbox() {
	difference() {
		union() {
			cnccube(x=ramps_x+ramps_xtra_left+ramps_xtra_right,
                    y=ramps_calc_y+ramps_xtra_front+ramps_xtra_back,
                    z=ramps_z, r=metallscrew_r+ticknesss_corners, w=thickness_bottom);
            translate([ramps_xtra_left,ramps_xtra_front,0]) rampsmount(r=metallscrew_r+ticknesss_boardmounts, h=ramps_z_spacing+thickness_bottom);
			*if(knightmount) { //thickness_left
				translate([-(metallscrew_r+ticknesss_corners)*2,-ticknesss_corners,ramps_z-knight_extrusion_width]) hull() {
					cube([thickness_knightmount,ramps_calc_y+ramps_xtra_front+ramps_xtra_back+ticknesss_corners*2,knight_extrusion_width]); 
					translate([0,0,-thickness_knightmount*1.5]) cube([thickness_left,ramps_calc_y++ramps_xtra_front+ramps_xtra_back+ticknesss_corners*2,knight_extrusion_width]); 
				}
				translate([-(metallscrew_r+normal_wall)*2,ramps_xtra+ramps_calc_y/2,0]) for(i1=[-1,1]) for(i2=[-1,1])
					translate([0,i1*(ramps_calc_y/3.5)+i2*(knight_extrusion_width/2),0]) centercube([metallscrew_r*2+normal_wall,stable_wall,ramps_z],y=true);
			}
			if(resetbutton) translate([ramps_xtra_left+ramps_x+ramps_xtra_right+ticknesss_corners*2+metallscrew_d+5-compensate*2+ticknesss_corners+single_wall*2,-metallscrew_d-ticknesss_corners*2+5-compensate*2+ticknesss_corners,0]) rampsbutton();
		}
		*if(knightmount) {
			translate([-(metallscrew_r+normal_wall)*2,ramps_xtra_front+ramps_calc_y/2,0]) for(i1=[-1,1])
				translate([0,i1*(ramps_calc_y/3.5),ramps_z-knight_extrusion_width/2]) rotate([0,90,0])
					fncylinder(r=knight_extrusion_screw_r,h=thickness_knightmount,enlarge=1);
		}
		translate([ramps_xtra_left,ramps_xtra_front,thickness_bottom]) rampsmount(r=metallscrew_r, h=ramps_z_spacing+thickness_bottom);
		if(backfan) {
			translate([ramps_x/2+ramps_xtra_left,ramps_calc_y+ramps_xtra_front+ramps_xtra_back+(metallscrew_r+ticknesss_corners)*2+1,ramps_z/2]) rotate([90,0,0])
				fancuts(r_fan=fan_r, r_screws=fan_screws_r, offset_screws=fan_offset_screws, h=thickness_back+2);
		}
		translate([ramps_xtra_left,ramps_xtra_front,ramps_z_spacing+thickness_bottom]) {
			cube([ramps_x,ramps_calc_y,ramps_z]);
			translate([8.26,-metallscrew_r*2-ticknesss_corners*2-1,0.5])
				cube([14.11,thickness_front+2,ramps_z-ramps_z_spacing-thickness_bottom-bridgetop]);
			translate([1.35,-metallscrew_r*2-ticknesss_corners*2-1,14])
				cube([ramps_x-1.35*2,thickness_front+2,ramps_z-14-ramps_z_spacing-bridgetop]);
			if(resetbutton) {
				translate([ramps_x+ramps_xtra_front+(metallscrew_r+ticknesss_corners)*2,35.44,18.07]) rotate([0,-90,0]) fncylinder(r=5,h=(metallscrew_r+ticknesss_corners)*2,enlarge=1);
			}
			if (backopening) {
				translate([1.35,ramps_xtra_front+ramps_calc_y+ramps_xtra_back,backopening_bottomwall])
					cube([ramps_x-1.35*2,metallscrew_r*2+ticknesss_corners*2+2,ramps_z-backopening_bottomwall-ramps_z_spacing-bridgetop]);
			}
		}
		if(mount_type==1) {
			translate([ramps_xtra_left+ramps_x/2,ramps_xtra_front+ramps_calc_y/2,0]) for(i1=[-1,1]) for(i2=[-1,1])
				translate([i1*15,i2*30,0]) fncylinder(r=screw_m3_r,h=thickness_bottom,enlarge=1); 
		}
	}
}


// #####################################################################################################################################
module rampsmount(r=1.6, h=10) {
	for(i1=[[2.64,15.16,0],[50.85,13.92,0],[17.73,65.9,0],[45.64,65.9,0],[2.5,90.07,0],[50.85,96.39,0]])
		translate(i1) fncylinder(r=r, h=h);
}


// #####################################################################################################################################
module rampsbutton() {
	union()  {
		fncylinder(r=5-compensate*2,h=ramps_xtra_right+(metallscrew_r+ticknesss_corners)*2-1);
		fncylinder(r=5-compensate*2+ticknesss_corners,h=ramps_xtra_right+(metallscrew_r+ticknesss_corners)*2-1.5-thickness_right);
		translate([0,0,ramps_xtra_right+(metallscrew_r+ticknesss_corners)*2-1]) resize([(5-compensate*2)*2,(5-compensate*2)*2,(5-compensate*2)]) fnsphere(r=5-compensate*2);
	}
}

// #####################################################################################################################################
module rampslid() {
	difference() {
		union() {
			cnccube(x=ramps_x+ramps_xtra_left+ramps_xtra_right, y=ramps_calc_y+ramps_xtra_front+ramps_xtra_back, z=thickness_lid, r=metallscrew_r+ticknesss_corners, w=thickness_lid);
			lidfixture(x=ramps_x+ramps_xtra_left+ramps_xtra_right, y=ramps_calc_y+ramps_xtra_front+ramps_xtra_back, z=thickness_lid, r=metallscrew_r+ticknesss_corners, w=3);
		}	
		if (topfan) {
			translate([ramps_x/2+ramps_xtra_left,ramps_xtra_front+60.45-fan_r/2,-1])
			fancuts(r_fan=fan_r, r_screws=fan_screws_r, offset_screws=fan_offset_screws, h=thickness_lid+2);
		}
	}
}

// #####################################################################################################################################
module lidfixture(x=10, y=10, z=10, r=1.5, w=2) {
	difference() {
		for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate(i1) fncylinder(r=r+compensate*2+ticknesss_corners, h=z+w);
		for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate(i1) fncylinder(r=r+compensate*2, h=z+w,enlarge=1);
		difference() {
			translate([-r*2-w*2,-r*2-w*2,-1]) cube([x+r*4+w*4,y+r*4+w*4,z+w+2]);
			translate([-r,-r,-2]) cube([x+r*2,y+r*2,z+w+4]);
		}
		for(i1=[[-r,-r,0],[-r,y+r,0],[x+r,-r,0],[x+r,y+r,0]]) translate([i1[0],i1[1],z-30]) fncylinder(r=metallscrew_r, h=31);
	}
}

// #####################################################################################################################################
module fancuts(r_fan=60/2, r_screws=4.3/2, offset_screws=50/2, h=20) {
	translate([0,0,0]) fncylinder(r=r_fan, h=h);
	for(i1=[0:3]) rotate([0,0,90*i1]) translate([offset_screws,offset_screws,0]) fncylinder(r=r_screws, h=h);
}

// #####################################################################################################################################
// a rewritten cylinder, with enlarge and dynamic fn
// 2015 cc by nc sa 4.0, Jons Collasius, Hamburg, Germany
module fncylinder(r,r2,d,d2,h,fn,center=false,enlarge=0,pi=3.1415926536){
	translate(center==false?[0,0,-enlarge]:[0,0,-h/2-enlarge]) {
		if (fn==undef) {
			if (r2==undef && d2==undef) {
				cylinder(r=r?r:d?d/2:1,h=h+enlarge*2,$fn=floor(2*(r?r:d?d/2:1)*pi/resolution));
			} else {
				cylinder(r=r?r:d?d/2:1,r2=r2?r2:d2?d2/2:1,h=h+enlarge*2,$fn=floor(2*(r?r:d?d/2:1)*pi/resolution));
			}
		} else {
			if (r2==undef && d2==undef) {
				cylinder(r=r?r:d?d/2:1,h=h+enlarge*2,$fn=fn);
			} else {
				cylinder(r=r?r:d?d/2:1,r2=r2?r2:d2?d2/2:1,h=h+enlarge*2,$fn=fn);
			}
		}
	}
}

// #####################################################################################################################################
// this cube can be centered on any axis
// 2015 cc by nc sa 4.0, Jons Collasius, Hamburg, Germany
module centercube(xyz=[10,10,10],x=false,y=false,z=false) {
	translate([x==true?-xyz[0]/2:0,y==true?-xyz[1]/2:0,z==true?-xyz[2]/2:0]) cube(xyz);
}


// #####################################################################################################################################
// a rewritten sphere, with dynamic fn
// 2015 cc by nc sa 4.0, Jons Collasius, Hamburg, Germany
module fnsphere(r,d,fn,pi=3.1415926536){
	if (fn==undef) {
		sphere(r=r?r:d?d/2:1,$fn=floor(2*(r?r:d?d/2:1)*pi/resolution));
	} else {
		sphere(r=r?r:d?d/2:1,$fn=fn);
	}
}
