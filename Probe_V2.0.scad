use<Mirror.scad>;


$fn=50;


diam_screw_head=15; // Diametro de la tuerca
diam_screw=9;
diam_ext_electrodo=23;
radio_probe=diam_ext_electrodo/2;
height_screw=6;

length_section=5+height_screw*2;
separation=5; // Se puede animar!!
distance_sections=separation+length_section;
number_parts=5;
radio_cable=2;

grosor_separacion_vertical=0;

altura_conector=25;
ancho_conector=7;
anchura_conector_pole=4.3;

module probe_connector(tube=false){
    
        if (tube==true)
    {
            translate([0,0,altura_conector/2])
    cube([anchura_conector_pole,anchura_conector_pole,altura_conector],center=true);
    } else{
    translate([0,0,altura_conector/2])
    cube([anchura_conector_pole,anchura_conector_pole,altura_conector],center=true);
    
    translate([0,0,altura_conector+ancho_conector/2])
    cube([ancho_conector,ancho_conector,ancho_conector],center=true);
    }

}

module probe(){
   
difference(){
    union(){
    translate([0,-(distance_sections*(number_parts+1))/2,0])
    for (aux=  [1:number_parts])
        {
            translate([0,aux*distance_sections,0])
            rotate([90,0,0])
                cylinder(r=radio_probe, h=length_section,center=true);
        }
    }
    

    translate([0,-(distance_sections*(number_parts))/2,0])
    for (aux=  [0:number_parts]){
         translate([0,aux*distance_sections,0])
            rotate([90,0,0])
                difference(){
                    cylinder(d=diam_screw_head+1, h=height_screw*2+separation,center=true,$fn=6);
                    
                }
        }
        
}
}








probe();
translate([0,0,radio_probe/2])
    probe_connector();
    