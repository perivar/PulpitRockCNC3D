$fn=50;   

ASSEMBLY       = false;  // Compile assembly
FASTENERS      = false;  // Include Fasteners in assembly
STL_HOUSING    = true;  // Compile Housing for STL creation
STL_COVER      = false; // Compile Cover for STL creation
STL_SHAFT      = false; // Compile Shaft for STL creation
STL_PERF_BOARD = false;
shift_cover    = 100;

//
// Input values
//
htop    = 10.0;   // probe top height
hbot    = 20.0;   // probe top height
d6tap   = 4;      // screw diameter on the main body 
d6clear = 3;      // screw diameter on the top lid
d25tap  = 2.85;   // probe top diameter

d10tap    = 5;    // the diameter of the three straight probe "screws"
hex_size  = 7;
shaft_dia = 2*hex_size/cos(30);

shaft_gap = 1.5; 
gap       = 1.5;

// spring
dspring_bot = 20;
dspring_top = 10;
lspring     = 15;

// housing
od     = 55;
id     = od-6;
height = 20;
tbot   = 6;
dhole  = shaft_dia+shaft_gap*2;

hplug         = (height+tbot)/2;
loc_plug_flat = od*2;
dplug_flat    = 10;
dplug_hole    = 6.35;
dplug_back    = 9;

hplug_back = 10;
wplug_back = 14;
t_plug     = 1.27;

// Housing cover
hcover = 3;     // height cover base
dpost1 = 2;     // diameter connector 
hpost1 = 10;    // height connector
dpost2 = 6;     // diameter connector 2
hpost2 = 20;    // height connector 2

// Round head screw
dt  = 3.9;    // diameter head screw pin
lt  = 11;
dh  = 7.9;  // diameter head screw head
hh  = 3;
r   = dh*dh/(8*hh)+hh/2;
dc  = hh-r;

// Screw circle
r_circ=od/2-dh/1.5;
rascrew=d6tap/2; 

// Shoulder screw
dhead     = 5;  // shoulder screw head diameter
hhead     = 0;  // shoulder screw head length
dshoulder = 5;  // shoulder screw shoulder diameter
lshoulder = 8;  // shoulder screw shoulder length
dthd      = 5;  // should base diameter
lthd      = 8;  // should base length

// Calculated values
gapscrew=(dshoulder/2+r)*cos(45); // orig: 45
hss=gapscrew+dc;
rsupports=hex_size+lshoulder-dh/1.492;

// top of shaft part
ts_shaft = tbot+htop;
gap_cover = height-ts_shaft;

if (STL_HOUSING)    probe_housing();
if (STL_COVER)      probe_cover();
if (STL_SHAFT)      rotate([0,180,0]) probe_shaft();
if (STL_PERF_BOARD) rotate([0,180,0]) perf_board();

if (ASSEMBLY)
{
  // Assemble
  union()
  {
    probe_housing();

    // cover shifted by od to move it out of the way
    translate ([shift_cover,0,height]) probe_cover();
    translate ([0,0,0*25.4])color("darksalmon") probe_shaft();
    rotate([0,0,-30]) translate([0,15,10]) rotate([90,0,0]) perf_board();  
      
    if (FASTENERS)
    {
      for (i=[0:120:240])
      {
        rotate ([0,0,i])
        {
          translate([rsupports, gapscrew,tbot])
            rh_screw();
          translate([rsupports,-gapscrew,tbot])
            rh_screw();

          translate([hex_size+lshoulder,0,tbot+hss])
            rotate ([0,90,0])
            shoulder_screw();

          translate([rsupports, gapscrew,-.1*25.4]) washer();
          translate([rsupports,-gapscrew,-.1*25.4]) washer();


          translate([rsupports, gapscrew,-.2*25.4]) nut();
          translate([rsupports,-gapscrew,-.2*25.4]) nut();
        }
      }
      
      for(angle=[30:60:360])
        rotate([0,0,angle])
          translate ([ r_circ ,0,height+hcover])
            rh_screw();
    }
  }
}

// Modules
module probe_cover()
{
  union()
  {
    difference ()
    {
      union ()
      {
        cylinder (hcover,od/2,od/2);
        cylinder (hcover+hpost1,dpost1/2,dpost1/2);
        translate ([0,0,hcover])cylinder (.5*25.4,dpost1/2 +.75*25.4 ,dpost1/2);
        cylinder (hcover+hpost2,dpost2/2,dpost2/2);
        translate ([0,0, hcover+hpost1])cylinder (.1*25.4,dpost1/2,dpost2/2);    
      }

      // screw holes
      for(angle=[30:60:360])
        rotate([0,0,angle])
          translate ([ r_circ ,0,height/2])
              cylinder (height*2,d6clear/2,d6clear/2,center=true);

        // cut out for the spring
        translate([0,0,-gap_cover])
        cylinder(lspring,dspring_bot/2+gap/2,dspring_top/2);
    }
  }
}

module probe_shaft()
{
  difference()
  {
    // the hexagon probe base
    union ()
    {
      translate([0,0,tbot])
        rotate([0,0,30])
          cylinder (htop,shaft_dia/2,shaft_dia/2,$fn=6);
      translate ([0,0,tbot-hbot])
        rotate([0,0,30])
          cylinder (hbot,shaft_dia/3,shaft_dia/3,$fn=6);
    }

    // cutout for the straight connector pins
    for(angle=[0:120:240])
    {
      rotate([0,0,angle])
      {
        translate ([0,0,12.5])
          rotate ([0,90,0])
            cylinder(20,d10tap/2,d10tap/2);
      }
    }

    // cutout for the whole in the middle for the probe pin
    cylinder (100,d25tap/2,d25tap/2,center=true);
  }
}

module probe_housing()
{
  difference ()
  {
    union ()
    {
      difference ()
      {
        cylinder (height,od/2,od/2);
        
        // bottom hexagon cutout
        translate([0,0,tbot/2]) rotate([0,0,30]) cylinder (height,dhole/2,dhole/2,$fn=6);          

        // the hexagon top
        rotate([0,0,30]) cylinder (height,dhole/3,dhole/3,$fn=6);
        
        translate ([0,0,tbot]) cylinder (height,id/2,id/2);

        for(angle=[0:120:240])
        {
          rotate([0,0,angle])
          {
            translate ([ rsupports,gapscrew,-0.1]) cylinder(25,d6tap/2,d6tap/2);
            translate ([ rsupports,-gapscrew,-0.1]) cylinder(25,d6tap/2,d6tap/2);
            // translate ([ hex_size+lshoulder+hhead/2,0,tbot+hss ])
            // {
            //   rotate ([0,90,0])
            //     cylinder(hhead+2*gap,dhead/2+2*gap,dhead/2+2*gap,center=true);
            // }
          }
        }
    
        // wire holes
        rotate([0,0,60])
        {                    
          translate ([ 12,10,0]) cylinder(25.4,1.0,1.0);
          translate ([ 12,-10,0]) cylinder(25.4,1.0,1.0);
        }
      }

      // cutouts for the triangular opening
      for(angle=[0:120:240])
      {
        rotate([0,0,angle])
        {
          difference()
          {
            cylinder(height,od/2,od/2);
            translate ([12.5,0,0]) cube([od,od,height*2.5],center=true);   
          }
        }
      }
    }

    // screw holes in the thick case
    for(angle=[30:60:360])
      rotate([0,0,angle])
          translate ([ r_circ ,0,height/2])
              cylinder (height*2,rascrew,rascrew,center=true);

    // hole for wiring plug
    rotate ([0,0,60])
    {
      translate ([ loc_plug_flat ,0,hplug])
      rotate ([0,90,0])
      {
      cylinder (1*25.4, dplug_flat/2 ,dplug_flat/2);
      cylinder (1*25.4, dplug_hole/2,dplug_hole/2,center=true );
      }
      translate ([ loc_plug_flat-t_plug,0,hplug])
      rotate ([0,-90,0])
      {
      translate([0,0,1*25.4/2])
      cube([hplug_back,wplug_back,1*25.4],center=true);
      }
    }
  }
}

module perf_board()
{
  L=1.4*25.4;
  W=.4*25.4;
  T=.04*25.4;
  tfoot=.05*25.4;
  hfoot=.1*25.4;
    
  translate([-L/2,-W/2,hfoot])
  {
    difference ()
    {
      cube ([L,W,T]);
      for(i=[0.1*25.4:0.1*25.4:L-.1],j=[.1*25.4:.1*25.4:.31*25.4])
      translate ([i,j,0])
      cylinder (1*25.4,1.0,1.0,$fn=10);
    }

    translate([0,0,-hfoot])cube([tfoot,W,hfoot]);
    translate([L-tfoot,0,-hfoot])cube([tfoot,W,hfoot]);
  }
}

module rh_screw()
{
  $fn=20;
  difference ()
  {
    translate ([0,0,dc]) sphere(r);
    translate ([0,0,-r]) cube (2*r,center=true);
  }
  translate ([0,0,-lt]) cylinder (lt,dt/2,dt/2);
}

module washer()
{
  color("lightgreen")
  linear_extrude (1.27)
  difference ()
  {
     circle (3.175);
     circle (1.9811999999999999);
  }
}

module nut()
{
  nut_size=6.35;
  nut_dia =nut_size/cos(30);
  nut_id=4;
  nut_thickness=2.5;
  color("grey")
  rotate([0,0,30])
  linear_extrude ( nut_thickness )
  {
     difference ()
     {
        circle (nut_dia/2, $fn=6);
        circle (nut_id/2,$fn=10);
     }
  }
}

module shoulder_screw()
{
  $fn=20;
  color("lightblue")
  union  ()
  {
    cylinder (hhead,dhead/2,dhead/2);
    translate ([0,0,-lshoulder]) cylinder (lshoulder,dshoulder/2,dshoulder/2);
    translate ([0,0,-lthd-lshoulder]) cylinder (lthd,dthd/2,dthd/2);
  }
}

