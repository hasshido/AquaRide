$fn=30;
radius_bar =7; //mm
bend_radius =7 ; //long wheel 


module Carrier_Wheel_axle(){
    cylinder(r=1.4,h=21,center=true);  

}    

 module Carrier_Wheel(){

    difference() {
        cylinder(r=12,h=15,center=true);

        rotate_extrude()
        translate([bend_radius + radius_bar, 0, 0])
            circle(r=radius_bar,$fn=7);

        cylinder(d=6,h=20,center=true);
     }
}

Carrier_Wheel();

//Carrier_Wheel_axle();

