use <motormountshelfclip.scad>;


// Variables
ancho_cristal=5.5;
size_soporteMotor=50;
ancho_piezamain=7;
size_piezamain=60;
size_enganche=40;
ancho_enganche=6;

module pestanita(){
    
    
    hueco_silicona_size=40;

    difference(){
        translate([ancho_cristal,ancho_cristal,-size_enganche])
            cube([size_enganche,size_enganche,size_enganche]);
       
        translate([ancho_cristal+ancho_enganche,ancho_cristal+ancho_enganche,-size_enganche])
            cube([size_enganche,size_enganche,size_enganche]);
        
         translate([ancho_cristal/1.5,ancho_cristal/1.5,-size_enganche/2])
            cylinder(h=size_enganche,d=20,center=true,$fn=4);
        }
}

module cilindro_eje(){
    
    //Cilindro para la cuerda
    difference(){

        cylinder(d=10,h=20,center=true);
        color("teal")
        translate([0,0,0.01])
        translate([0,0,-20])
            scale([1.02,1.02,1.01])
                import("./Stl/NEMA17.stl");
        difference(){
            translate([0,0,5])
                cylinder(d=12,h=6,center=true);
            translate([0,0,5])
                cylinder(d=7,h=6,center=true);
        }

        
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

        
        translate([0,-29,2])    
        nema17shaftplate(43, 45, 10);

        
        // Nema17
        %color("teal")
        translate([0,-29,-1])
        scale([1.00,1.00,1.00])
            import("./Stl/NEMA17.stl");




    }
}


Top_corner_motor();
*cilindro_eje();   