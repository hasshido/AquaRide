use<gears.scad>;
use<publicDomainGear.scad>;


Imprimir=true;

EngranajeZ_Num_Dientes=9;
EngranajeZ_Grosor=8;

Modulo_transmision_EngranajeZ=4;
Modulo_transmision_Servo_Z=10;
Modulo_transmision_Eje_Z_Dentado=8;


Diam_eje_rotatorio=23;
Diam_Eje_Amplificadoras=5;
Diam_Plataforma_sup=40;
Diam_Boca_Servo=22;
Grosor_Plataforma_sup=10;

Altura_Tope_Eje_Z=42; // Establecer en base al tamaño del motor
Altura_Estructura_Central=100;
Altura_Eje_Z_Dentado=270;
Altura_Soporte_Amplificadoras=45;

Ancho_Soporte_Amplificadoras=15;
Ancho_Rueda_Servo_Z=9;
Ancho_Rueda_Amplificadora_Grande=13;
Ancho_Rueda_Amplificadora_Pequena=12;
Ancho_Tubo_Eje_Z=4;


Posicion_X_Amplificadoras=27.5;
Margen_Holgura_Rotacion=2;

module Eje_Z(){
    difference(){        
        cylinder(h=Altura_Estructura_Central+Altura_Eje_Z_Dentado,d = Diam_eje_rotatorio-Margen_Holgura_Rotacion-Ancho_Tubo_Eje_Z,$fn=50,center=true);
        translate([Diam_eje_rotatorio-Diam_eje_rotatorio/3.5,0,0])
            cube([Diam_eje_rotatorio,Diam_eje_rotatorio,Altura_Estructura_Central+Altura_Eje_Z_Dentado],center=true);
    }
}

module Eje_Z_dentado(){
        intersection(){
            Eje_Z();
        
            translate([3,0,Altura_Eje_Z_Dentado])
            rotate([0,90,-90])
                rack (mm_per_tooth=(Modulo_transmision_Servo_Z), 
                number_of_teeth=Altura_Eje_Z_Dentado*2/Modulo_transmision_Servo_Z,
                thickness=Diam_eje_rotatorio, height=20,
                pressure_angle =0,
                backlash=0.1 );
        }
    }

module Servo_Futaba_s3003(){
    union(){
        difference(){
            color("white")
                rotate([0,0,90])
                    translate([65,-65,0])
                        import("./Stl/Servo_stand.stl",center = true);
           translate([-40,-25,0])
            cube(30,20,20,center=true);    
        }
        if(Imprimir==false){       
        color("gray")
            rotate([0,0,90])
            translate([0,-0,2])
                import("./Stl/Futaba3003.stl",center = true); 
        }   
    }
}

module EjeAmplificadoraGrande(){
                cylinder(h=Ancho_Rueda_Amplificadora_Grande+Ancho_Rueda_Amplificadora_Pequena+Ancho_Soporte_Amplificadoras+15,d=Diam_Eje_Amplificadoras, $fn=40); 
}

module Amplificadora_servo_z(){
    union(){    
    //PequeñaAmplificadora 
        translate([0,12,0])   
        rotate([90,70,0])
            gear (
                mm_per_tooth    = Modulo_transmision_Eje_Z_Dentado, number_of_teeth =6,   thickness       = Ancho_Rueda_Amplificadora_Pequena,   hole_diameter   = Diam_Eje_Amplificadoras,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.1,  backlash        = 0.0  );
        
    //GrandeAmplificadora           
        rotate([90,32,0])
            gear (
                mm_per_tooth    = Modulo_transmision_Servo_Z, number_of_teeth =15,   thickness       =Ancho_Rueda_Amplificadora_Grande,   hole_diameter   = Diam_Eje_Amplificadoras,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.0,  backlash        = 0.0  );
        
        if(Imprimir==false){
            translate([0,Ancho_Rueda_Amplificadora_Grande/2 + Ancho_Rueda_Amplificadora_Pequena,0])
            rotate([90,0,0])
                EjeAmplificadoraGrande();
            
        }
    }
}    
module Rueda_Servo_Z(){
difference(){    
            gear (
            mm_per_tooth    = Modulo_transmision_Eje_Z_Dentado, number_of_teeth =15,   thickness       = Ancho_Rueda_Servo_Z,   hole_diameter   = 0,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.1,  backlash        = 0.0  );

        translate([0,0,-5])
                cylinder(h=8,d=Diam_Boca_Servo,center=true); 
        
    }
}   
module Rueda_Servo_Alpha(){

    difference(){
                gear_bevel(m = Modulo_transmision_EngranajeZ,  //dientes/mm
                        z =EngranajeZ_Num_Dientes*2,    // Numero de dientes
                        x =0,     //Profile shift
                        h = EngranajeZ_Grosor,   // Altura de la rueda
                        w = 25,   // angulo de los dientes
                        w_bevel = 0, // Ángulo de la rueda
                        w_helix = 0,   //angulo de los dientes
                        D = 0,         //??
                        clearance = -0.1,  // Hueco entre ruedas
                        center = true
                        );
                // Hueco para servo
             translate([0,0,-4])
                cylinder(h=8,d=Diam_Boca_Servo,center=true); 
        }
    
}

module Eje_Transmision(){
    difference(){
        
        
        
        union(){
            // Rueda dentada para permitir giro en alfa
            translate([0,0,Altura_Tope_Eje_Z/2+EngranajeZ_Grosor/2])     
                    gear_bevel(m = Modulo_transmision_EngranajeZ,  //dientes/mm
                                            z =EngranajeZ_Num_Dientes,    // Numero de dientes
                                            x =0,     //Profile shift
                                            h = EngranajeZ_Grosor,   // Altura de la rueda
                                            w = 25,   // angulo de los dientes
                                            w_bevel = 0, // Ángulo de la rueda
                                            w_helix = 0,   //angulo de los dientes
                                            D = 50,         //??
                                            clearance = -0.1,  // Hueco entre ruedas
                                            center = true ); 
            // Tope del eje con <carrier>
            cylinder(h=Altura_Tope_Eje_Z,d = Diam_eje_rotatorio+5,$fn=50,center=true);
            
            // Eje para permitir movimiento en Z 
            cylinder(h=Altura_Estructura_Central,d = Diam_eje_rotatorio-Margen_Holgura_Rotacion,$fn=50,
    center=true);
            
            // Plataforma superior para sujección del servo Z
            translate([0,0,(Altura_Tope_Eje_Z/2)+EngranajeZ_Grosor])
                cylinder(h = (Altura_Estructura_Central-Altura_Tope_Eje_Z)/2-EngranajeZ_Grosor, d1 = Diam_eje_rotatorio, d2 = Diam_Plataforma_sup, center = true/false);
            
            // Servo
            translate([36.5,66,Altura_Estructura_Central/2+12.5])
            rotate([0,90,-90])
                Servo_Futaba_s3003();
                
            // Plataforma para servo superior
            difference(){
                translate([30,20,Altura_Estructura_Central/2-Grosor_Plataforma_sup/2])
                    cube([55,100,Grosor_Plataforma_sup],center=true);
                
                translate([46,14,12.5+Altura_Estructura_Central/2])
                    rotate([90,-5,0])
                    cylinder(h=Ancho_Rueda_Servo_Z+5,d=45,center=true);      
            }
             // Eje para Ruedas de Amplificacion     

            difference(){
                
                translate([Posicion_X_Amplificadoras,-2-Ancho_Rueda_Amplificadora_Grande/2-Ancho_Soporte_Amplificadoras/2,(Altura_Estructura_Central/2)+(Altura_Soporte_Amplificadoras/2)])
                    cube([Ancho_Soporte_Amplificadoras,Ancho_Soporte_Amplificadoras,Altura_Soporte_Amplificadoras],center=true);
                translate([Posicion_X_Amplificadoras,-Ancho_Rueda_Amplificadora_Grande,32+Altura_Estructura_Central/2])
                    rotate([90,0,0])
                   cylinder(d=Diam_Eje_Amplificadoras, h =100,center=true);
            }
        }
        scale([1.04,1.04,1])
            Eje_Z();
    }

 }
    
    
if(Imprimir==false){         

    Eje_Transmision();
 
    //Eje dentado para transmisión en Z
     color("yellow")
    translate([0,0,-12])
        render()
            Eje_Z_dentado();

    //Rueda servo en Z
    color("green")
        translate([46,14,12.5+Altura_Estructura_Central/2])     
        rotate([90,-5,0])
        render()
            Rueda_Servo_Z();

    // Sistema de engranajes
      color("orange")
        translate([Posicion_X_Amplificadoras,0,32+Altura_Estructura_Central/2]) 
         render()
                Amplificadora_servo_z();           

     
    //Rueda acoplada a servo en alpha
    translate([60,0,25])    
    rotate([0,180,0])
            Rueda_Servo_Alpha();
} else {
    Eje_Transmision();
 
    *rotate([90,0,0])
            Eje_Z_dentado();

    *Rueda_Servo_Z();
    
    *rotate([90,0,0])
    Amplificadora_servo_z();           

    *rotate([0,180,0])
    Rueda_Servo_Alpha();
    
    *EjeAmplificadoraGrande();
    
    
}

 
 
 
 
 
 