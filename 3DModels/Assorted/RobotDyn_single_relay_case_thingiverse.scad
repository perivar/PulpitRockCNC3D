// 5V relay case
// GNU GPL v3
// version : 2.0
// Author : Zerkin
// date : 07/09/2019

// Changed by Per Ivar Nerseth: 08.06.2020
// Changed the settings to fit a RobotDyn single relay and one suger cube connector


// --------------
/*[General parameters]*/
// the number of facets used to generate an arc
$fn = 36 ;

// Tolerance for assembling part in mm
Margin=0.1 ;

// --------------
// Adjustable variables

/*[Box size]*/
// inner length (X axis) in mm
Length=48 + 20;
// inner width (Y axis) in mm
Width=29 ;
// inner base height (Z axis) in mm
Base_height=16 + 2;
// Inner top height in mm
Top_height=5 ;

// Wall thickness in mm
Thickness=2 ;


/*[Supports]*/
// alignment mode : centered | align on right side | align on left side
Align = 1 ; // [0:center, 1:right, 2:left]
// Space between the center of first support and the front side
Space_x = 4 ;
// Space between the center of support and the side (for left ot right alignment)
Space_y = 4 ;

//
// Distance between holes in X axis
Support_x=28 + 16; // 44
// Distance between holes in Y axis
Support_y=21;
// Height of the support
Support_z=3;

// Type of support : 0=simple, 1=with column, 2=M3x6 Bolt from above in hexagonal nut, 3=M3 Bolt from bottom in column
Support_type = [1, 3, 1, 3] ;

// diameter of the support plot (need to be wide enough if using nut)
Support_r = 4.5 ;
// diameter of the column above the plot
Column_r = 2.7 + 0.1;
// length of the Bolt (for type 3 support)
Bolt_length = 12;


/*[Pin Hole]*/
// Y center position (from center of board)
Pin_y=-2.5 + 2.5;
// Z lower position (from bottom of board)
Pin_z=3;

// Y size
Pin_size_y=10 + 2;
// Z size
Pin_size_z=6; 

// Text centered below the hole
Text="V G N SG"; 
// Text size
Text_size = 2;   


/*[Power Cord hole]*/
// X position for the center of the power cord hole (from outside)
Hole_x=43 + 20;
// Z position for the center of the power cord hole
Hole_z=9;
//Diameter in mm (-1 to remove completly)
Hole_r=3;


/* [Hidden] */
// M3 Bolt parameters
Bolt_hole_d = 2.5 ;
Bolt_passage_d = 3.1 ;
Bolt_head_h = 2.1 ; // 2 + 0.1 mm
Bolt_head_d = 6.4 ; // 5.4 + 1 mm
Nut_h = 2.5 ; // 2.3 + 0.2 mm
Nut_d = 6.6 ; // 6.4 + 0.2 mm
Screwing_length = 6 ;

// Pcb size
Pcb_height = 1.7 ;

// Translation for the center of the support
Y_translation = ( Align==0 ? Width/2 : (Align==1 ? Space_y+Support_y/2 : Width - (Space_y+ Support_y/2) ) ) ;

// --------------
// modules definition

// Cube with rounded vertical ridge
module roundedCube(size, radius) {
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
    }
}

// triangular prism for holding the top part
module prism(e,w){
   translate([-w/2, 0, -e]) polyhedron(
       points=[[0,0,0], [w,0,0], [w,e,e], [0,e,e], [0,0,2*e], [w,0,2*e]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
   ) ;
}


module plot(type)
{
   translate([0,0,Thickness - Margin]) {
      cylinder(r=Support_r, h=Support_z + Margin);
      cylinder(d=Bolt_hole_d, h=Support_z + 2*Pcb_height + Margin);
   }
}

module plot_hole(type)
{
   if (type==2) {
      translate([0,0,-Margin]) cylinder (h=Nut_h+Margin, d=Nut_d, $fn=6 ) ;
      cylinder (h=Thickness+Support_z+2*Pcb_height+3*Margin, d=Bolt_passage_d );
   }
   if (type==3) {
      translate([0,0,-Margin]) cylinder (h=Thickness+Support_z+2*Pcb_height+3*Margin, d=Bolt_passage_d );
      translate([0,0,-Margin]) cylinder(h=Bolt_head_h + Margin, d = Bolt_head_d) ;
   }
}

module plot_top(type)
{
   Column_height = Base_height + Top_height + 2*Thickness - (Support_z + Pcb_height + 2*Margin) -2 ; // PIN: added -2 to make the lid fit
   Column_Bolt_hole_height = Bolt_length + Bolt_head_h - (Support_z + Pcb_height + Margin) ;
   Screw_length = min(Screwing_length, Column_Bolt_hole_height) ;
   
   hole_length = (type==1 ? Pcb_height + 2*Margin : Column_Bolt_hole_height+Margin) ;
   diameter = (type==1 ? Bolt_hole_d+2*Margin : Bolt_hole_d) ;
 
   if (type==1 || type==3)
      difference () {
         cylinder(h=Column_height, r=Column_r) ;

         translate ([0,0,Column_height-hole_length-2*Margin]) cylinder (h=hole_length + 3*Margin, d=diameter) ;
         if (type==3) 
            translate ([0,0,Column_height-hole_length+Screwing_length]) cylinder (h=hole_length + 3*Margin, d=Bolt_passage_d) ;
      }
}


// --------------
// Objects definition


module base(){
    difference () {
        // Base unit
        roundedCube( [Length+2*Thickness, Width+2*Thickness, Base_height+Thickness], Thickness) ;

        // hollowing the box
        translate([Thickness,Thickness,Thickness]) cube ([Length, Width, Base_height+Thickness], false);
        translate([Thickness/2, Thickness/2, Base_height]) cube ([Length + Thickness, Width + Thickness, 2*Thickness]);
        
        
        // Recess for lid
        translate([Thickness+(Length/2), 1.5*Thickness + Width - 0.1, Base_height + Thickness/2]) prism(Thickness/4+0.1, 10) ;
        translate([Thickness+(Length/2), 0.5*Thickness + 0.1, Base_height + Thickness/2]) rotate([0,0,180]) prism(Thickness/4+0.1, 10) ;
        

        // Pin opening
        translate([-Thickness, Thickness + Y_translation + Pin_y - Pin_size_y/2, Thickness + Support_z + Pin_z]) cube([3*Thickness, Pin_size_y, Pin_size_z], false) ;
        translate([1-Margin, Thickness + Y_translation + Pin_y , Thickness + Support_z + Pin_z - Text_size - 1 ]) rotate([90,0,-90]) linear_extrude(height = 1+Margin)
            text(Text, size=Text_size, font="Arial:style=bold", halign="center");
        
       
        // Outside opening for power cord
        translate([Hole_x, -Thickness, Hole_z]) {
            rotate([-90, 0,0]) cylinder(r = Hole_r, h = Width+4*Thickness);
        }
        translate([Hole_x-Hole_r, -Thickness, Hole_z]) cube([2*Hole_r, Width+4*Thickness, Base_height-Hole_z+2*Thickness ], false) ;

        // Inside shape for power cord 
        translate([Hole_x-Hole_r-Thickness/2, Thickness/2, Hole_z]) cube([2*Hole_r+Thickness, Width+Thickness, Base_height-Hole_z+2*Thickness ], false) ;
    }
    
    // Supports
    translate([Thickness + Space_x, Thickness + Y_translation]) union () {
      translate([0, -Support_y/2])           plot(Support_type[0]);
      translate([0,  Support_y/2])           plot(Support_type[1]);
      translate([Support_x,  Support_y/2])   plot(Support_type[2]);
      translate([Support_x, -Support_y/2])   plot(Support_type[3]);
    }

}

translate([0, 0, 0]) difference()
{
   base() ;

   translate([Thickness + Space_x, Thickness + Y_translation, -Margin]) union () {
      translate([0, -Support_y/2])           plot_hole(Support_type[0]);
      translate([0,  Support_y/2])           plot_hole(Support_type[1]);
      translate([Support_x,  Support_y/2])   plot_hole(Support_type[2]);
      translate([Support_x, -Support_y/2])   plot_hole(Support_type[3]);
   }
}

// lid
translate([0, Width+2*Thickness + 10, 0]) {
   difference(){
      union() {
         // Base unit
         roundedCube( [Length+2*Thickness, Width+2*Thickness, Top_height+Thickness], Thickness) ;
         // inside wall
         translate([Thickness/2+Margin, Thickness/2+Margin, Top_height+Thickness]) roundedCube( [Length+Thickness-2*Margin, Width+Thickness-2*Margin, Thickness-Margin], Thickness/2-Margin) ;


         // closing recess
         translate([Thickness+(Length/2), 1.5*Thickness + Width - Margin, Top_height+ 1.5*Thickness]) prism(Thickness/4, 10) ;
         translate([Thickness+(Length/2), Thickness/2 + Margin, Top_height+ 1.5*Thickness]) rotate([0,0,180]) prism(Thickness/4, 10) ;


         // Wall for closing power cord hole
         // extern wall
         translate([Hole_x-Hole_r+Margin, 0, Top_height+Thickness]) cube([2*(Hole_r-Margin), Width+2*Thickness, Base_height-Hole_z+Thickness ], false) ;
         // inside wall (bigger) 
         translate([Hole_x-Hole_r-Thickness/2+Margin, Thickness/2+Margin, Top_height+Thickness]) cube([2*(Hole_r-Margin)+Thickness, Width+Thickness-2*Margin, Base_height-Hole_z+Thickness ], false) ;

      }

      // hollowing the lid
      translate([Thickness,Thickness,Thickness]) cube ([Length, Width, Top_height+Base_height], false);

      // Hole for power Cord
      translate([Hole_x, -Thickness, Top_height+Base_height-Hole_z+2*Thickness ]) 
         rotate([-90, 0,0]) cylinder(r = Hole_r, h = Width+4*Thickness);
   } ;
   
   
   // Column above the support plots
   translate([Thickness + Space_x, Thickness + Width - Y_translation]) union () {
      translate([0,  Support_y/2])           plot_top(Support_type[0]);
      translate([0, -Support_y/2])           plot_top(Support_type[1]);
      translate([Support_x, -Support_y/2])   plot_top(Support_type[2]);
      translate([Support_x,  Support_y/2])   plot_top(Support_type[3]);
   }
}