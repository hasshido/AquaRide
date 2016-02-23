$fn=30;

radius_bar =5; //mm

bend_radius =5; //long wheel

angle_1 = 10;
angle_2 = 100;


difference() {
cylinder(r=10,h=11,center=true);
rotate_extrude()
    translate([bend_radius + radius_bar, 0, 0])
    circle(r=radius_bar);
cylinder(r=2,h=20,center=true);
    
    
}



       

