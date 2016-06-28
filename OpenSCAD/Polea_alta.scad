$fn=20;

radius_bar =3; //mm

bend_radius =4; //long wheel

difference() {
cylinder(r1=15, r2=5,h=25,,center=true);
translate([0,0,4])
    rotate_extrude()
        translate([bend_radius + radius_bar, 0, 0])
            circle(r=radius_bar);
}