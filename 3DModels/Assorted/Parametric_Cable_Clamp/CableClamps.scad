// ==============================================
// Clamp for 9 mm diameter cable
// J.Beale 12-Sept-2015
// ==============================================
fudge = 0.25;  // fudge factor for printer slop in ID
fn=80;  // facets on cylinder
eps=0.03; // small number
bn = 100; // big number

// ==============================================
//  Commonly adjusted parameters

COD = 9.22;      // outer diameter of cable
ID = 3.5 + eps;  // diameter of mounting hole
th = 3.0;        // thickness of clamp
W = 10.0;  // width of clamp

// ==============================================

// --- Shouldn't need to adjust this part ---

R1 = (COD + fudge)/2;  // radius of cable
R2 = R1 + th;  // radius of curved part of clamp
L = R2 * 2.2; // length of flat base part of clamp

// ----------------------------------

module mt_hole() {  // mounting hole
  translate([-W,-R2-(ID),W/2]) rotate([0,90,0]) cylinder(d=ID, h=W*3, $fn=fn);
}


module cable() {
  translate([R1,0,-W]) 
    cylinder(r=R1, h=W*3, $fn=fn);  // cylinder to clamp
}

module flatClamp() {
 difference() {    
  union() {
    translate([R1,0,0]) 
      cylinder(r=R2, h=W, $fn=fn);  // cylinder part of clamp
    translate([0,-L,0]) cube([th,L,W]); // flat part of clamp
  }
  cable();
  translate([-bn,-bn/2,-bn/2]) cube([bn,bn,bn]);  // trim base flat
  translate([-R1,-R1,-eps]) cube([R1*2,R1*2,W+2*eps]);  // open cylinder
  mt_hole(); // mounting hole
 }
}

module cornerClamp() {
 difference() {
  translate([0,-R1,0]) flatClamp();
  translate([-eps,-eps,-eps]) cube([100,100,100]);
  translate([-eps,-120,-eps]) cube([100,100,100]);
 }
}

// cornerClamp();  // cable clamp against a 90 degree corner

flatClamp();  // cable clamp for a flat surface