
module Cabo_Hilos(){
    difference(){
        cylinder(h=10,d=5,$fn=30);
        translate([0,0,8])
            difference(){
                cylinder(h=1,d=10,$fn=15,center=true);
                cylinder(h=1,d=4,$fn=15,center=true);
        }   
        
    }
}

Cabo_Hilos();