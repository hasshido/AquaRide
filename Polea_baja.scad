$fn=20;
radius_bar =2; //mm
bend_radius =4; //long wheel

module Polea_baja(){
	difference() {
	    cylinder(r1=8, r2=5,h=8 ,center=true);
	    
	    rotate_extrude()
	    translate([bend_radius + radius_bar, 0, 0])
		circle(r=radius_bar);
	}
}

Polea_baja();
