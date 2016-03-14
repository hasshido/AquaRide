use<gears.scad>;
use<Mirror.scad>;
use<publicDomainGear.scad>;


Imprimir=true;

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
Grosor_Plataforma_sup=10;

Altura_Tope_Eje_Z=42; // Establecer en base al tamaño del motor
Altura_Estructura_Central=100;
Altura_Eje_Z_Dentado=Altura_Estructura_Central+250;
Altura_Soporte_Amplificadoras=48;


Ancho_Soporte_Amplificadoras=15;
Ancho_Plataforma_Sup=85;
Ancho_Rueda_Servo_Z=9;
Ancho_Rueda_Amplificadora_Grande=13;
Ancho_Rueda_Amplificadora_Pequena=12;
Ancho_Tubo_Eje_Z=4;
Ancho_Eje_Z=4;
Ancho_pasadizo_alim=4;
Ancho_AlineadorZ=10;

Altura_Eje_Amplificadoras=Ancho_Plataforma_Sup+15;

Posicion_X_Amplificadoras=27.5;
Margen_Holgura_Rotacion=2;

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
            
            // Medio cilindro para "ahuecar" el eje
            difference(){
                cylinder(h=Altura_Eje_Z_Dentado+1,d=Diam_eje_Z_dentado-Ancho_Eje_Z,center=true);
                
                translate([Diam_eje_Z_dentado/2,0,0])
                cube([Diam_eje_Z_dentado,Diam_eje_Z_dentado,Altura_Eje_Z_Dentado+1],center=true);
            }
        }

    } 
    else{
        // Partir la pieza por la mitad y ponerla una al lado de la otra para facilitar impresión
        difference(){
            rotate([90,0,0])      
                Eje_Z_dentado(Print=false);
            translate([0,Altura_Eje_Z_Dentado/2,0])
                cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado],center=true);
        }
        
        // Segunda mitad de la pieza, puesta al lado de la primera
        mirror([0,1,0])
        translate([Diam_eje_Z_dentado*2,0,0])
            intersection(){
                rotate([90,0,0])      
                    Eje_Z_dentado(Print=false);
                translate([0,Altura_Eje_Z_Dentado/2,0])
                    cube([Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado,Altura_Eje_Z_Dentado],center=true);   
                
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
            
            // Eje para permitir movimiento en Z 
            cylinder(h=Altura_Estructura_Central,d = Diam_eje_rotatorio-Margen_Holgura_Rotacion,$fn=50,
    center=true);
            
            // Plataforma superior para sujección del servo Z
            
            translate([0,0,(Altura_Tope_Eje_Z/2)+EngranajeZ_Grosor])
               cylinder(h = (Altura_Estructura_Central-Altura_Tope_Eje_Z)/2-EngranajeZ_Grosor, d1 = Diam_tope, d2 = Diam_Plataforma_sup, center = true/false);
            
            // Servo
            translate([36.5,62,Altura_Estructura_Central/2+12.5])
            rotate([0,90,-90])
                Servo_Futaba_s3003();
                
            // Plataforma para servo superior
            difference(){
                translate([30,19,Altura_Estructura_Central/2-Grosor_Plataforma_sup/2])
                    cube([55,Ancho_Plataforma_Sup,Grosor_Plataforma_sup],center=true);
                
                // Hueco para rueda servo Z
                translate([46,14,12.5+Altura_Estructura_Central/2])
                    rotate([90,-5,0])
                    cylinder(h=Ancho_Rueda_Servo_Z+2,d=55,center=true);      
            }
            

            // Cuerpo del soporte para el EJE1
            translate([Posicion_X_Amplificadoras,-Ancho_Rueda_Amplificadora_Grande/2-Ancho_Soporte_Amplificadoras/2,(Altura_Estructura_Central/2)+(Altura_Soporte_Amplificadoras/2)])
            Soporte_Eje_Amplificadora();

           // Estructura eje para Ruedas de Amplificacion EJE 2 
           difference(){     
                translate([Posicion_X_Amplificadoras,63,(Altura_Estructura_Central/2)+(Altura_Soporte_Amplificadoras/2)-(Grosor_Plataforma_sup/2)])
                    cube([Ancho_Soporte_Amplificadoras,Ancho_Soporte_Amplificadoras/3 ,Altura_Soporte_Amplificadoras+Grosor_Plataforma_sup],center=true);
                translate([Posicion_X_Amplificadoras,-Ancho_Rueda_Amplificadora_Grande,32+Altura_Estructura_Central/2])
                    rotate([90,0,0])
                    EjeAmplificadoraGrande();
            }
            
            
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
            translate([0,Diam_eje_rotatorio/2+Diam_Plataforma_sup/4,(Altura_Estructura_Central/4+0.5)])
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
            cylinder(d=Diam_eje_rotatorio+50,h=7,center=true);
        
            cylinder(d=Diam_eje_rotatorio-Margen_Holgura_Rotacion+1,h=20,center=true);
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
                
        //Rueda para estabilizar ejeZ
        translate([0,0,-40])
        Cilindro_Sujeccion_Vertical();
    }
    else {
        
       *difference(){
                Eje_Transmision_Core();
                Pasadizo_Alimentacion(pieza="hueco");
            }
     
       scale([0.9,1,0.9])
            Eje_Z_dentado(Print=true);   


        *Rueda_Servo_Z();
        
        rotate([90,0,0])
        *Amplificadora_servo_z();           

        rotate([0,180,0])
        *Rueda_Servo_Alpha();
        scale([0.7,0.7,1])
        *EjeAmplificadoraGrande();
        
       *Pasadizo_Alimentacion(pieza="tapa");
            
        *Cilindro_Sujeccion_Vertical();

        
    }
}

 Eje_Transmision();
 
 
     
     
     