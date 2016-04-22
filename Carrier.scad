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
Posicion_Poleas=[20,45,5];
Diam_eje_rotatorio=23;
Posicion_ruedas=[Dist_bar,40,-20];

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
            cylinder(h=30,d=Diam_eje_rotatorio,$fn=50,center=true);
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
            servo();

        // Añadir Rueda Servo Alpha
        *color("teal")
        translate([-0,55,51])
            //Módulo declarado en Eje_transmision.scad
            Rueda_Servo_Alpha();    
    }
}

Carrier();
*bar_holder();





       

