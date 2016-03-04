module Cabo_Hilos(){
    difference(){
        cylinder(h=15,d=8,$fn=30);
        translate([0,0,8])
            difference(){
                cylinder(h=4,d=10,$fn=15,center=true);
                cylinder(h=4,d=5,$fn=15,center=true);
        }   
        
    }
}

Cabo_Hilos();