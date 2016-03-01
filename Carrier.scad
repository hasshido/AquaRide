// Variables

$fn=30;
Radio_eje_rueda=2;
Dims_rueda=[12, 22 ,12] ;
Dist_bar=40; //distancia de una varilla al centro
Posicion_Poleas=[20,45,5];
Diam_eje_rotatorio=23;
Posicion_ruedas=[Dist_bar,40,0];

use <Eje_Transmision.scad>;
use <Cabo_Hilos.scad>;
use <Carrier_Wheel.scad>;
use <Mirror.scad>;


Imprimir = false;


module servo(){
    union(){
        difference(){
            color("white")
                rotate([0,0,90])
                    translate([65,-65,0])
                        import("./Stl/Servo_stand.stl",center = true);
           translate([-40,-25,0])
            cube(30,20,20,center=true);    
        }
   color("gray")
     rotate([0,0,90])
        translate([0,-0,2])
            import("./Stl/Futaba3003.stl",center = true); 
    }
}

module Carrier(){
    union(){        
        difference(){           
            cube([100,110,10],center=true);
            
            // Replicamos con respecto al medio un cubo con las dimensiones de la rueda
            mirrorXY(Pos=Posicion_ruedas)
                cube(Dims_rueda,center=true);
            // Los ejes de las ruedas
            mirrorXY(Pos=[Dist_bar-10,40,0])
                rotate([0,90,0])
                    cylinder(h=100,r=Radio_eje_rueda);
            
            // Hueco central
            cylinder(h=30,d=Diam_eje_rotatorio,$fn=50,center=true);
        }
        // Añadir poleas SUJETO A CAMBIOS
        color("orange")
        mirrorXY(Pos=Posicion_Poleas)
            Cabo_Hilos();
        
        // Añadir ruedas
        color("green")
        mirrorXY(Pos=Posicion_ruedas)
        rotate([0,90,0])
            Carrier_Wheel();
        
        // Añadir Eje_transmision
        translate([0,0,25.6])
            rotate([0,0,-20])
            Eje_Transmision();
        
        // Añadir servo Alpha
        translate([0,45,5])
            servo();

        // Añadir Rueda Servo Alpha
        color("teal")
        translate([-0,55,51])
            //Módulo declarado en Eje_transmision.scad
            Rueda_Servo_Alpha();    
    }
}

Carrier();






       

