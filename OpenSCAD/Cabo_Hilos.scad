module Cabo_Hilos(){
    difference(){
        cylinder(h=15,r=8/2,$fn=30);
        translate([0,0,8])
            difference(){
                cylinder(h=4,r=5,$fn=15,center=true);
                cylinder(h=4,r=2.5,$fn=15,center=true);
        }   
        
    }
}

Cabo_Hilos();