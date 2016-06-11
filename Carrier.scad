use <Eje_Transmision.scad>;
use <Cabo_Hilos.scad>;
use <Carrier_Wheel.scad>;
use <Mirror.scad>;



$fn=30;
radius_bar=5.6;
margen_bar=1;
Radio_eje_rueda=2;
Dims_rueda=[12, 22 ,12] ;
Dist_bar=40; //distancia de una varilla al centro
Posicion_Poleas=[20,45,-20];
Diam_eje_rotatorio=23;
Posicion_ruedas=[Dist_bar,40,-20];
Separacion_receptor_cables=28;

Imprimir = false;

module bar_holder(){
rotate([90,0,0])
    difference(){
        union(){
                cylinder(r=radius_bar+5,h=10,center=true);
            translate([0,10,0])
                cube([(radius_bar+5)*2,20,10],center=true);
        }
        cylinder(r=radius_bar+margen_bar,h=11,center=true);
        
    }
}

module servo(){
    union(){
        difference(){
            color("white")
                rotate([0,0,90])
                    translate([65,-65,0])
                        import("./Stl/Servo_stand.stl",center = true);
           translate([-40,-25,0])
            cube(30,20,20,center=true);    
            
            mirrorX(Pos=[-27.5,20,0])
            cube(30,20,20,center=true);      

            
            
        }
   *color("gray")
     rotate([0,0,90])
        translate([0,-0,2])
            import("./Stl/Futaba3003.stl",center = true); 
    }
}

module Carrier(){
    union(){        
        difference(){           
            cube([102,110,10],center=true);

            // Hueco central
            cylinder(h=30,r=Diam_eje_rotatorio/2,$fn=50,center=true);
        }
        // Añadir poleas
        color("orange")
        mirrorXY(Pos=Posicion_Poleas)
            Cabo_Hilos();
        
        // Añadimos los amarres
        mirrorXY(Pos=Posicion_ruedas)
            bar_holder();
        
        
        // Añadir Eje_transmision
        *translate([0,0,25.6])
            rotate([0,0,-20])
            Eje_Transmision();
        
        // Añadir servo Alpha
        translate([0,45,5])
            rotate([0,0,0])
            servo();

        // Añadir Rueda Servo Alpha
        *color("teal")
        translate([-0,55,51])
            //Módulo declarado en Eje_transmision.scad
            Rueda_Servo_Alpha();    
            
        // Añadir Receptor de cables
        translate([0,38,0])
        mirrorY(Pos=[-40,Separacion_receptor_cables/2,10])  
            cube([15,5,20],center=true);
            
        translate([-40,38,20])
        rotate([0,-60,0])
            difference(){
                cylinder(h=10,r=28/2,center=true);
                cylinder(h=11,r=22/2,center=true);
            }
 
    }
}

Carrier();
*bar_holder();





       

