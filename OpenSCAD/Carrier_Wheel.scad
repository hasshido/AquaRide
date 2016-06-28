$fn=30;
radius_bar =9; //mm
bend_radius =10; //long wheel 


module Carrier_Wheel_axle(){
    cylinder(r=2,h=30,center=true);  

}    

 module Carrier_Wheel(){

    difference() {
        cylinder(r=15,h=20,center=true);

        rotate_extrude()
        translate([bend_radius + radius_bar, 0, 0])
            circle(r=radius_bar,$fn=5);

        cylinder(r=6/2,h=20,center=true);
     }
}

Carrier_Wheel();

%Carrier_Wheel_axle();

