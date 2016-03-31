use<gears.scad>;
use<Mirror.scad>;
use<publicDomainGear.scad>;

$fn=20;

radio_probe=10;
length_section=10;


separation=5*pow(sin(180*$t),2); // Se puede animar!!
distance_sections=separation+length_section;
number_parts=5;
radio_cable=2;
ancho_electrodo=5;
grosor_electrodo=2;
grosor_separacion_vertical=1;


module probe(){
difference(){
    union(){
    translate([0,-(distance_sections*(number_parts-1))/2,0])
    for (aux=  [0:number_parts-1])
        {
            translate([0,aux*distance_sections,0])
            rotate([90,0,0])
                cylinder(r=radio_probe, h=length_section,center=true);
        }


    mirrorY([0,-(distance_sections*(number_parts-1)+length_section)/2,0])
        difference(){
        sphere(r=radio_probe);
            difference(){
                sphere(r=radio_probe);
                sphere(r=radio_probe-grosor_electrodo);
            }
        }
    }

  

    
    rotate([90,0,0]) 
    cylinder(h=(distance_sections*number_parts +radio_probe*2),r=radio_cable, center=true);
    
    translate([0,-(distance_sections*(number_parts-2))/2,0])
    for (aux=  [0:number_parts-2])
        {
            translate([0,aux*distance_sections,0])
            rotate([90,0,0])
                difference(){
                    cylinder(r=radio_probe+1, h=ancho_electrodo+separation,center=true);
                    cylinder(r=radio_probe-grosor_electrodo, h=length_section+1+separation,center=true);
                    cube([grosor_separacion_vertical,radio_probe*3,ancho_electrodo*2],center=true);
                }
        }
        
}
}

probe();
    