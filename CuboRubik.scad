difference(){
     union(){
    cube([30,30,30], center = true);
     translate([-11.5,-11.5,-11.5])
        cube([10,10,10], center = true);
    translate([-11.5,-11.5,0])
        cube([10,10,10], center = true);
    translate([-11.5,-11.5,11.5])
        cube([10,10,10], center = true);
    
    translate([11.5,-11.5,-11.5])
        cube([10,10,10], center = true);
    translate([11.5,-11.5,0])
        cube([10,10,10], center = true);
    translate([11.5,-11.5,11.5])
        cube([10,10,10], center = true);
    
    translate([0,-11.5,-11.5])
        cube([10,10,10], center = true);
    translate([0,-11.5,0])
        cube([10,10,10], center = true);
    translate([0,-11.5,11.5])
        cube([10,10,10], center = true);
        
   translate([-11.5,0,-11.5])
        cube([10,10,10], center = true);
    translate([-11.5, 0,0])
        cube([10,10,10], center = true);
    translate([-11.5,-0,11.5])
        cube([10,10,10], center = true);
    
    translate([11.5,-0,-11.5])
        cube([10,10,10], center = true);
    translate([11.5,-0,0])
        cube([10,10,10], center = true);
    translate([11.5,0,11.5])
        cube([10,10,10], center = true);
    
    translate([0,0,-11.5])
        cube([10,10,10], center = true);
    translate([0,0,0])
        cube([10,10,10], center = true);
    translate([0,0,11.5])
        cube([10,10,10], center = true);
        
     translate([-11.5,11.5,-11.5])
        cube([10,10,10], center = true);
    translate([-11.5,11.5,0])
        cube([10,10,10], center = true);
    translate([-11.5,11.5,11.5])
        cube([10,10,10], center = true);
    
    translate([11.5,11.5,-11.5])
        cube([10,10,10], center = true);
    translate([11.5,11.5,0])
        cube([10,10,10], center = true);
    translate([11.5,11.5,11.5])
        cube([10,10,10], center = true);
    
    translate([0,11.5,-11.5])
        cube([10,10,10], center = true);
    translate([0,11.5,0])
        cube([10,10,10], center = true);
    translate([0,11.5,11.5])
        cube([10,10,10], center = true);
        
    translate([-4.5,0,17]) 
    linear_extrude(height = 0.5)
    scale([0.3,0.3,0.6])
    text("Anita", font = "Liberation Sans");

    translate([-16,-17,-13]) 
    rotate([90,0,0])
    linear_extrude(height = 0.5)
     scale([0.15,0.15,0.6])
        text("By Víctor", font = "Liberation Sans");
    }
        cube([25,25,25], center = true);
    }