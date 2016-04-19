 // Variables
ancho_cristal=6;
ancho_soporte=5;
ancho_piezamain=7;
size_piezamain=60;
size_enganche=30;
ancho_enganche=6;

module pestanita(){
    difference(){
        translate([ancho_cristal,ancho_cristal,-size_enganche])
            cube([size_enganche,size_enganche,size_enganche]);
       
        translate([ancho_cristal+ancho_enganche,ancho_cristal+ancho_enganche,-size_enganche])
            cube([size_enganche,size_enganche,size_enganche]);
        }
}

difference(){
    // Contenedor NEMA17
    translate([0,0,-25])
        cube([50,50,50],center=true);
    // Hueco para NEMA17
    color("teal")
    translate([0,0,0.01])
    scale([1.02,1.02,1.01])
        import("./Stl/NEMA17.stl");
    // Elimina varas NEMA17
    translate([0,0,-22])
        cube([36,36,50],center=true);
    
    //Hueco para la alimentación
    translate([0,-25,-39])
        cube([15,10,15],center=true);
    }
}

module Top_corner_motor(){
    union(){
        // PiezaEsquina  
        difference(){
        translate([size_piezamain/2-ancho_piezamain,size_piezamain/2-ancho_piezamain,-(size_piezamain/2-ancho_piezamain)])  
            cube([size_piezamain,size_piezamain,size_piezamain],center=true);
        translate([50,50,-50])    
            cube([100,100,100],center=true);
        }
        
        pestanita();
    }
}
Top_corner_motor();