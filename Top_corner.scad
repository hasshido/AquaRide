 // Variables
ancho_cristal=5.5;
ancho_piezamain=8;
size_piezamain=60;
size_enganche=30;
ancho_enganche=8;
size_platf_poleaAlta=40;

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
        
        
        translate([-size_platf_poleaAlta/5,-size_platf_poleaAlta/5,ancho_piezamain/2])
            cylinder(d=size_platf_poleaAlta,h=ancho_piezamain,center=true);
        
        difference(){
        translate([-size_platf_poleaAlta/5,-size_platf_poleaAlta/5,-ancho_piezamain])
            cylinder(d2=size_platf_poleaAlta,h=ancho_piezamain*2,center=true);
        translate([50,50,-50])    
            cube([100,100,100],center=true);   
         
        }
        
        translate([10,5,12])
            import("./Stl/Polea_baja.stl");
        
        translate([-10,-10,20])
            import("./Stl/Polea_alta.stl");
    }
    
    
}
Top_corner_motor();