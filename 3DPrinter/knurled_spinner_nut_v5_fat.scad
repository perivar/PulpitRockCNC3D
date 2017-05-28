// tau function
function t (angle) = angle*360;

bearing_outer_d = 22.15;
bearing_h = 10.5;
//bearing_h = 7;

//hexnut_d = 18.90; // 1/2 in nut
//hexnut_d = 14.287; // 3/8 in nut
//hexnut_d = 11.11; // 1/4 in nut
hexnut_d = 18.90; // M12
//hexnut_d = 16.90; // M10
//hexnut_d = 12.90; // M8

wall_th = 1.6;
inverse_knurling=true;
num_weights = 3;

housing_knurled_3();

module housing_knurled_3() {

    difference() {  
        //$fn=30;
        // main housings
            union() {
                //translate([0,0,bearing_h/2]) cylinder(r=bearing_outer_d/2+wall_th*2,h=bearing_h,center=true);
                if (num_weights <= 2)
                {
                    translate([0,0,-bearing_h/2])
                        knurl(k_cyl_od=bearing_outer_d+wall_th*4, k_cyl_hg=bearing_h,knurl_hg=bearing_h/3, inverse=true);
                }
                else
                {
                    difference() {
                        cylinder(r=bearing_outer_d,h=bearing_h,center=true);
                        // innie knurling
                        for(i=[0:num_weights]) {
                        rotate([0,0,(i*2+1)*360/num_weights/2]) 
                            translate([bearing_outer_d*1.5+wall_th*2,0,-bearing_h/2]) scale([1,1.3,1]) 
                                knurl(k_cyl_od=bearing_outer_d*2,k_cyl_hg=bearing_h,knurl_hg=bearing_h/3,e_smooth=-1.75);
                        }
                    }
                }
                //knurl(k_cyl_od=bearing_outer_d+wall_th,knurl_cyl_hg=bearing_h);
                for(i=[0:num_weights]) {
                    rotate([0,0,i*360/num_weights]) translate([hexnut_d+wall_th*5,0,-bearing_h/2]) 
                        //cylinder(r=bearing_outer_d/2+wall_th,h=bearing_h,center=true);
                        knurl(k_cyl_od=hexnut_d+wall_th*5,k_cyl_hg=bearing_h,knurl_hg=bearing_h/3, inverse=inverse_knurling);
                }
            }
        
        // subtract bearing hole
        cylinder(r=bearing_outer_d/2,h=bearing_h,center=true);
        // subtract weight holes
        for(i=[0:num_weights]) {
            rotate([0,0,i*360/num_weights]) translate([hexnut_d+wall_th*5,0,0]) 
               hexagon(hexnut_d,bearing_h); 
               //cylinder(r=bearing_outer_d/2,h=bearing_h*2,center=true);
        }
    }
}

module hexagon(width,height) {
    angle = 360/6;
    cot = width / tan(angle);
    echo(angle, 1/tan(angle), cot);
    union()
    {
        rotate([0,0,0])
            cube([width,cot,height],center=true);
        rotate([0,0,angle])
            cube([width,cot,height],center=true);
        rotate([0,0,2*angle])
            cube([width,cot,height],center=true);
    }
}



//////////////////////////////////////////
// KNURL LIBRARY
//

/*
 * knurledFinishLib_v2.scad
 * 
 * Written by aubenc @ Thingiverse
 *
 * This script is licensed under the Public Domain license.
 *
 * http://www.thingiverse.com/thing:31122
 *
 * Derived from knurledFinishLib.scad (also Public Domain license) available at
 *
 * http://www.thingiverse.com/thing:9095
 *
 * Usage:
 *
 * Drop this script somewhere where OpenSCAD can find it (your current project's
 * working directory/folder or your OpenSCAD libraries directory/folder).
 *
 * Add the line:
 *
 *   use <knurledFinishLib_v2.scad>
 *
 * in your OpenSCAD script and call either...
 *
 *    knurled_cyl( Knurled cylinder height,
 *                 Knurled cylinder outer diameter,
 *                 Knurl polyhedron width,
 *                 Knurl polyhedron height,
 *                 Knurl polyhedron depth,
 *                 Cylinder ends smoothed height,
 *                 Knurled surface smoothing amount );
 *
 *  ...or...
 *
 *    knurl();
 *
 *  If you use knurled_cyl() module, you need to specify the values for all and
 *
 *  Call the module ' help(); ' for a little bit more of detail
 *  and/or take a look to the PDF available at http://www.thingiverse.com/thing:9095
 *  for a in depth descrition of the knurl properties.
 */


module knurl(k_cyl_hg = 12,
             k_cyl_od = 25,
             knurl_wd =  3,
             knurl_hg =  4,
             knurl_dp =  1.5,
             e_smooth =  1.75,
             s_smooth =  0,
             inverse = false)
{
    knurled_cyl(k_cyl_hg, k_cyl_od, 
                knurl_wd, knurl_hg, knurl_dp, 
                e_smooth, s_smooth, inverse);
}

module knurled_cyl(chg, cod, cwd, csh, cdp, fsh, smt, inv)
{
    cord=(cod+cdp+cdp*smt/100)/2;
    cird=cord-cdp;
    cfn=round(2*cird*PI/cwd);
    clf=360/cfn;
    crn=ceil(chg/csh);

    echo("knurled cylinder max diameter: ", 2*cord);
    echo("knurled cylinder min diameter: ", 2*cird);


    
    if( fsh < 0 )
    {
        union()
        {
            shape(fsh, cird+cdp*smt/100, cord, cfn*4, chg);
            
            translate([0,0,-(crn*csh-chg)/2])
            {
                if (inv)
                {
                    knurled_finish(cird, cord, clf, csh, cfn, crn);
                }
                else
                {
                    knurled_finish(cord, cird, clf, csh, cfn, crn);
                }
            }
       }
    } 
    else if ( fsh == 0 )
    {
        intersection()
        {
            cylinder(h=chg, r=cord-cdp*smt/100, $fn=2*cfn, center=false);

            translate([0,0,-(crn*csh-chg)/2])
            {
                if (inv)
                {
                    knurled_finish(cird, cord, clf, csh, cfn, crn);
                }
                else
                {
                    knurled_finish(cord, cird, clf, csh, cfn, crn);
                }
            }
        }
    }
    else 
    {
        intersection()
        {
            shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);

            translate([0,0,-(crn*csh-chg)/2])
            {
                if (inv)
                {
                    knurled_finish(cird, cord, clf, csh, cfn, crn);
                }
                else
                {
                    knurled_finish(cord, cird, clf, csh, cfn, crn);
                }
            }
        }
    }
}

module shape(hsh, ird, ord, fn4, hg)
{
    x0= 0;
    x1 = hsh > 0 ? ird : ord;
    x2 = hsh > 0 ? ord : ird;

    y0=0;
    y1=0;
    y2=abs(hsh);
    y3=hg-abs(hsh);
    y4=hg;
    y5=hg;

    if ( hsh >= 0 )
    {
        rotate_extrude(convexity=10, $fn=fn4)
        polygon(points=[[x0,y1],[x1,y1],[x2,y2],[x2,y3],[x1,y4],[x0,y4]],
                paths=[[0,1,2,3,4,5]]);
    }
    else
    {
        rotate_extrude(convexity=10, $fn=fn4)
        polygon(points=[[x0,y0],[x1,y0],[x1,y1],[x2,y2],
                        [x2,y3],[x1,y4],[x1,y5],[x0,y5]],
                paths=[[0,1,2,3,4,5,6,7]]);
    }
}

module knurled_finish(ord, ird, lf, sh, fn, rn)
{
    for(j=[0:rn-1])
    {
        h0=sh*j;
        h1=sh*(j+1/2);
        h2=sh*(j+1);
        for(i=[0:fn-1])
        {
            lf0=lf*i;
            lf1=lf*(i+1/2);
            lf2=lf*(i+1);
            polyhedron(
                points=[
                     [ 0,0,h0],
                     [ ord*cos(lf0), ord*sin(lf0), h0],
                     [ ird*cos(lf1), ird*sin(lf1), h0],
                     [ ord*cos(lf2), ord*sin(lf2), h0],

                     [ ird*cos(lf0), ird*sin(lf0), h1],
                     [ ord*cos(lf1), ord*sin(lf1), h1],
                     [ ird*cos(lf2), ird*sin(lf2), h1],

                     [ 0,0,h2],
                     [ ord*cos(lf0), ord*sin(lf0), h2],
                     [ ird*cos(lf1), ird*sin(lf1), h2],
                     [ ord*cos(lf2), ord*sin(lf2), h2]
                    ],
                faces=[
                     [0,1,2],[2,3,0],
                     [1,0,4],[4,0,7],[7,8,4],
                     [8,7,9],[10,9,7],
                     [10,7,6],[6,7,0],[3,6,0],
                     [2,1,4],[3,2,6],[10,6,9],[8,9,4],
                     [4,5,2],[2,5,6],[6,5,9],[9,5,4]
                    ],
                convexity=5);
         }
    }
}

module knurl_help()
{
    echo();
    echo("    Knurled Surface Library  v2  ");
    echo("");
    echo("      Modules:    ");
    echo("");
    echo("        knurled_cyl(parameters... );    -    Requires a value for each an every expected parameter (see bellow)    ");
    echo("");
    echo("        knurl();    -    Call to the previous module with a set of default parameters,    ");
    echo("                                  values may be changed by adding 'parameter_name=value'        i.e.     knurl(s_smooth=40);    ");
    echo("");
    echo("      Parameters, all of them in mm but the last one.    ");
    echo("");
    echo("        k_cyl_hg   -   [ 12   ]  ,,  Height for the knurled cylinder    ");
    echo("        k_cyl_od   -   [ 25   ]  ,,  Cylinder's Outer Diameter before applying the knurled surfacefinishing.    ");
    echo("        knurl_wd   -   [  3   ]  ,,  Knurl's Width.    ");
    echo("        knurl_hg   -   [  4   ]  ,,  Knurl's Height.    ");
    echo("        knurl_dp   -   [  1.5 ]  ,,  Knurl's Depth.    ");
    echo("        e_smooth   -   [  2   ]  ,,  Bevel's Height at the bottom and the top of the cylinder    ");
    echo("        s_smooth   -   [  0   ]  ,,  Knurl's Surface Smoothing :  File down the top of the knurl this value, i.e. 40 will smooth it a 40%.    ");
    echo("");
}

