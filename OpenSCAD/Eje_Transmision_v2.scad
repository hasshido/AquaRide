use<gears.scad>;
use<Mirror.scad>;
use<publicDomainGear.scad>;
use<Probe.scad>;
use <motormountshelfclip.scad>;


Imprimir=false;

EngranajeZ_Num_Dientes=9;
EngranajeZ_Grosor=8;

Modulo_transmision_EngranajeZ=4;
Modulo_transmision_Servo_Z=10;
Modulo_transmision_Eje_Z_Dentado=8;


Diam_eje_rotatorio=23;
Diam_tope=Diam_eje_rotatorio+5;
Diam_Eje_Amplificadoras=5;
Diam_Plataforma_sup=45;
Diam_Boca_Servo=22;
Diam_eje_motor=6;
Grosor_Plataforma_sup=10;

Altura_Tope_Eje_Z=42; // Establecer en base al tamaño del motor
Altura_Estructura_Central=100;
Altura_Eje_Z_Dentado=Altura_Estructura_Central+420; /////////////////// 250;
Altura_Soporte_Amplificadoras=48;

Altura_Enganche_Eje_Z=20;
Grosor_Enganche_Eje_Z=2;

Ancho_Soporte_Amplificadoras=15;
Ancho_Plataforma_Sup=55;
Ancho_Rueda_Servo_Z=13;
Ancho_Rueda_Amplificadora_Grande=13;
Ancho_Rueda_Amplificadora_Pequena=12;
Ancho_Tubo_Eje_Z=4;
Ancho_Eje_Z=4;
Ancho_pasadizo_alim=4;
Ancho_AlineadorZ=10;

Altura_Eje_Amplificadoras=Ancho_Plataforma_Sup+15;

Posicion_X_Amplificadoras=27.5;
Margen_Holgura_Rotacion=2;
Margen_Encaje_Eje_Z=0.5;

Diam_eje_Z_dentado=Diam_eje_rotatorio-Margen_Holgura_Rotacion-Ancho_Tubo_Eje_Z;

module Eje_Z(){
       difference(){        
            cylinder(h=Altura_Eje_Z_Dentado,d = Diam_eje_Z_dentado,$fn=50,center=true);
            translate([Diam_eje_rotatorio-Diam_eje_rotatorio/3.5,0,0])
                cube([Diam_eje_rotatorio,Diam_eje_rotatorio,Altura_Eje_Z_Dentado],center=true);
        }

}

module Eje_Z_dentado(Print=false){
    if(Print == false){
        difference(){
            union(){
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
                                
                    difference(){
                    translate([5,0,-Altura_Eje_Z_Dentado/2-15/2])    
                    cube([25,15,15],center = true);        
                    translate([11,0,-Altura_Eje_Z_Dentado/2-29])
                        scale([1.1,1.1,1]) 
                        probe_connector();

                    scale([1.5,1,1])    
                    translate([10,0,-Altura_Eje_Z_Dentado/2-19])   
                    probe_connector(tube=true);
                            
                    }  
            }
            
            // Medio cilindro para "ahuecar" el eje
            difference(){
                cylinder(h=Altura_Eje_Z_Dentado+50,d=Diam_eje_Z_dentado-Ancho_Eje_Z,center=true);
                
                translate([Diam_eje_Z_dentado/2,0,0])
                cube([Diam_eje_Z_dentado,Diam_eje_Z_dentado,Altura_Eje_Z_Dentado+50],center=true);
            }
        }


    } 
    else{
        // Partir la pieza por un tercio y ponerla una al lado de la otra para facilitar impresión
        difference(){
            translate([0,-Altura_Eje_Z_Dentado/6,0])
            difference(){
                translate([0,-Altura_Enganche_Eje_Z,0])
                rotate([90,0,0])      
                    Eje_Z_dentado(Print=false);
               translate([0,-Altura_Eje_Z_Dentado/3,0])
                    cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado],center=true);
            }
            rotate([90,0,0])
            difference(){
                cylinder(d=Diam_eje_Z_dentado+1,h=Altura_Enganche_Eje_Z*2,center=true);
                cylinder(d=Diam_eje_Z_dentado-Grosor_Enganche_Eje_Z-Margen_Encaje_Eje_Z/2-0.5,h=Altura_Enganche_Eje_Z*2+1,center=true);
            }
        }
        
        // Pieza central de las 3
        mirror([0,1,0])
        translate([Diam_eje_Z_dentado*3,-Altura_Eje_Z_Dentado/6,0])
        difference(){
            rotate([90,0,0])      
                Eje_Z_dentado(Print=false);
            translate([0,Altura_Eje_Z_Dentado/3+Altura_Eje_Z_Dentado/8,0])
                cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado/3+Altura_Eje_Z_Dentado/4,Altura_Eje_Z_Dentado/3],center=true); 
            translate([0,-Altura_Eje_Z_Dentado/3-Altura_Eje_Z_Dentado/8,0])
                cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado/3+Altura_Eje_Z_Dentado/4,Altura_Eje_Z_Dentado/3],center=true);     
        
        translate([0,-Altura_Eje_Z_Dentado/6+Altura_Enganche_Eje_Z/2,0])
            rotate([90,0,0])
                cylinder(d=Diam_eje_Z_dentado-Grosor_Enganche_Eje_Z+Margen_Encaje_Eje_Z/2,h=Altura_Enganche_Eje_Z,center=true);
       translate([0,+Altura_Eje_Z_Dentado/6-Altura_Enganche_Eje_Z/2,0])
            rotate([90,0,0])
                cylinder(d=Diam_eje_Z_dentado-Grosor_Enganche_Eje_Z+Margen_Encaje_Eje_Z/2,h=Altura_Enganche_Eje_Z,center=true);
            
        }
        
        
        // Tercera pieza
        mirror([0,1,0])
        translate([Diam_eje_Z_dentado*6,0,0])
        difference(){
            translate([0,+Altura_Eje_Z_Dentado/6,0])
            difference(){
                translate([0,+Altura_Enganche_Eje_Z,0])
                rotate([90,0,0])      
                    Eje_Z_dentado(Print=false);
               translate([0,+Altura_Eje_Z_Dentado/3,0])
                    cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado],center=true);
            }
            rotate([90,0,0])
            difference(){
                cylinder(d=Diam_eje_Z_dentado+1,h=Altura_Enganche_Eje_Z*2,center=true);
                cylinder(d=Diam_eje_Z_dentado-Grosor_Enganche_Eje_Z-Margen_Encaje_Eje_Z/2-0.5,h=Altura_Enganche_Eje_Z*2+1,center=true);
            }
        }
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
                cylinder(h=Altura_Eje_Amplificadoras,d=Diam_Eje_Amplificadoras, $fn=40,center=true); 
}
module Soporte_Eje_Amplificadora(){
    difference(){
                    union(){
                        cube([Ancho_Soporte_Amplificadoras,Ancho_Soporte_Amplificadoras,Altura_Soporte_Amplificadoras],center=true);
                         translate([0,(Ancho_Soporte_Amplificadoras+Ancho_Rueda_Amplificadora_Grande)/2,3*Altura_Soporte_Amplificadoras/4])
                         cube([Ancho_Soporte_Amplificadoras,2*Ancho_Soporte_Amplificadoras+Ancho_Rueda_Amplificadora_Grande,Altura_Soporte_Amplificadoras/2],center=true);     
                    }
        // Hueco para el eje
        translate([0,Altura_Eje_Amplificadoras/2-Ancho_Soporte_Amplificadoras,32-Altura_Soporte_Amplificadoras/2])
        rotate([90,0,0])
        EjeAmplificadoraGrande();
                    
         // Hueco para la rueda
                    
        translate([0,
                    Ancho_Soporte_Amplificadoras/2+Ancho_Rueda_Amplificadora_Grande/2,
                    32-Altura_Soporte_Amplificadoras/2])
        rotate([90,-5,0])
        cylinder(h=Ancho_Rueda_Amplificadora_Grande+2,d=63,center=true);               
                    
    }
                
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
            translate([0,Altura_Eje_Amplificadoras/2-2*Ancho_Soporte_Amplificadoras,0])
            rotate([90,0,0])
                EjeAmplificadoraGrande();
            
        }
    }
}    
module Rueda_Stepper_Z(){
difference(){    
         gear (
            mm_per_tooth    = Modulo_transmision_Servo_Z, number_of_teeth =10,   thickness       = Ancho_Rueda_Servo_Z,   hole_diameter   = Diam_eje_motor,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.0,  backlash        = 0.0  );
        
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

module Eje_Transmision_Core(){
    
    difference(){
     
        union(){
            // Rueda dentada para permitir giro en alfa
            rotate([0,0,180])
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
            cylinder(h=Altura_Tope_Eje_Z,d = Diam_tope,$fn=50,center=true);
            
            translate([0,0,-13.5])
            cylinder(h=15,d2=Diam_tope,d1=Diam_tope+15,center=true);
            
            // Eje para permitir movimiento en A 
            cylinder(h=Altura_Estructura_Central,d = Diam_eje_rotatorio-Margen_Holgura_Rotacion,$fn=50,
    center=true);
            
            // Plataforma superior para sujección del servo Z
            
            translate([0,0,(Altura_Tope_Eje_Z/2)+EngranajeZ_Grosor])
               cylinder(h = (Altura_Estructura_Central-Altura_Tope_Eje_Z)/2-EngranajeZ_Grosor, d1 = Diam_tope, d2 = Diam_Plataforma_sup, center = true/false);
            
                
            // Plataforma para servo superior
            difference(){
                translate([21,19,Altura_Estructura_Central/2-Grosor_Plataforma_sup/2])
                    cube([38,Ancho_Plataforma_Sup,Grosor_Plataforma_sup],center=true);
                
            }
            
                    
        
            translate([20,15,-1+(Altura_Estructura_Central/2)+23])    
            rotate([90,0,0])
            nema17shaftplate(40, 45, 8);
            
            // Alineador EjeZ
           color("teal")
           translate([-Diam_eje_Z_dentado/2-Ancho_AlineadorZ/2+4,0,-1+(Altura_Estructura_Central/2)+(Altura_Soporte_Amplificadoras/2)])
            cube([Ancho_AlineadorZ,Ancho_AlineadorZ,Altura_Soporte_Amplificadoras],center=true);                                                                                                    
        }
            
           
        scale([1.04,1.04,1])
            Eje_Z();
    
    }

 }
 
 
 
module Pasadizo_Alimentacion(pieza="tapa"){
         
    if (pieza=="hueco"){   
        // Pasadizo para alimentacion del servo Z
            translate([0,Diam_eje_rotatorio/2+Diam_Plataforma_sup/4-1.5,(Altura_Estructura_Central/4+0.5)])
                cube([Ancho_pasadizo_alim,Diam_Plataforma_sup/2,Altura_Estructura_Central/2+1],center=true);
    }
    if  (pieza=="tapa"){   
        intersection(){
            Eje_Transmision_Core();
            translate([0,2,3])
            Pasadizo_Alimentacion(pieza="hueco");
        }
    }
 
}
    
module Cilindro_Sujeccion_Vertical(){ 
    difference(){
            cylinder(d=Diam_eje_rotatorio+50,h=8,center=true);
        
            cylinder(d=Diam_eje_rotatorio-Margen_Holgura_Rotacion+1,h=20,center=true);
    } 
}

module Endstop_Z(){
    difference(){
    union(){
        translate([20,0,117.5])
            cube([40,40,15],center=true);
        translate([0,0,120])
            cylinder(r=20,h=10,center=true);
    }
    scale([1.02,1.02,1])
    Eje_Z();

    translate([-15,0,117.5])
        cube([15,4,15],center=true);
    }
}    
module Eje_Transmision(){
    if(Imprimir==false){         

        union(){
            difference(){
                Eje_Transmision_Core();
                Pasadizo_Alimentacion(pieza="hueco");
            }
            Pasadizo_Alimentacion(pieza="tapa");

        }
     
        //Eje dentado para transmisión en Z
        color("yellow")
        translate([0,0,-150])
        render()
            Eje_Z_dentado();

        //Rueda stepper en Z
        *color("green")
            translate([20,0,22+Altura_Estructura_Central/2])     
            rotate([90,19,0])
            render()
                Rueda_Stepper_Z();
        
        
        // Nema17
        %color("teal")
        translate([20,20.5,22+Altura_Estructura_Central/2])
        rotate([90,0,0])
            import("./Stl/NEMA17.stl");



        // Sistema de engranajes
          *color("orange")
            translate([Posicion_X_Amplificadoras,0,32+Altura_Estructura_Central/2]) 
             render()
                    Amplificadora_servo_z();           

         
        //Rueda acoplada a servo en alpha
        *translate([60,0,25])    
        rotate([0,180,0])
                Rueda_Servo_Alpha();
                
        //Rueda para estabilizar ejeZ
        *translate([0,0,-40])
        Cilindro_Sujeccion_Vertical();
        
        *Endstop_Z();
    }
    else {
        
       *difference(){
                Eje_Transmision_Core();
                Pasadizo_Alimentacion(pieza="hueco");
            }
     
       *scale([0.9,1,0.9])
        Eje_Z_dentado(Print=true);   


        *Rueda_Stepper_Z();
        
        rotate([90,0,0])
        *Amplificadora_servo_z();           

        rotate([0,180,0])
        *Rueda_Servo_Alpha();
            
        *scale([0.7,0.7,1])
        EjeAmplificadoraGrande();
        
       *Pasadizo_Alimentacion(pieza="tapa");
            
       *Cilindro_Sujeccion_Vertical();

       *Endstop_Z();
    }
}

Eje_Transmision();
*Endstop_Z();

 
 
     
     
     