// Variables
//use<publicDomainGear.scad>;
//    ajuste=ajuste; // ajusta las dos partes de la rueda
//    mm_per_tooth    = 8;    //ratio, ha de ser constante para encajar dos gears
//    number_of_teeth = number_of_teeth; //total number of teeth around the entire perimeter
//    thickness       = altura_rueda/2;//thickness, mm
//    hole_diameter   = 0;    //mm
//    twist           =0;    //teeth rotate this many degrees from bottom of gear to top.
//    teeth_to_hide   = 0;    //number of teeth to delete to make this only a fraction of a circle
//    pressure_angle  = 30;   //Controls how straight or bulged the tooth sides are. In degrees.
//    clearance       = 0.1;  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
//    backlash        = 0 ; //gap between two meshing teeth, in the direction along the circumference of the pitch circle

use<gears.scad>;
use<publicDomainGear.scad>;

teethNum=9;
Diam_eje_rotatorio=23;
Diam_Plataforma_sup=40;
Grosor_Plataforma_sup=10;
Altura_eje=100;
Altura_eje_z=270;
grosor_eje=4;
diam_eje_amplif=5;
ancho_rueda_servo_sup=9;
Altura_ejeAmp=45;

Ancho_amplif_grande=13;
Amplif_Pos_X=27.5;
ancho_soporte_amplif=15;

margen_holgura=2;
altura_tope=42; // Establecer en base al tamaño del motor
altura_rueda=8;
modulo_transmision=4;
modulo_transmision_vert=10;
modulo_transmision_amp=8;




module eje_direccional(){
    difference(){        
        cylinder(h=Altura_eje+Altura_eje_z,d = Diam_eje_rotatorio-margen_holgura-grosor_eje,$fn=50,center=true);
        translate([Diam_eje_rotatorio-Diam_eje_rotatorio/3.5,0,0])
            cube([Diam_eje_rotatorio,Diam_eje_rotatorio,Altura_eje+Altura_eje_z],center=true);
    }
}

module eje_dentado(){
        intersection(){
            eje_direccional();
        
           translate([3,0,Altura_eje_z])
            rotate([0,90,-90])
            rack (mm_per_tooth=(modulo_transmision_vert), 
            number_of_teeth=Altura_eje_z*2/modulo_transmision_vert,
            thickness=Diam_eje_rotatorio, height=20,
            pressure_angle =0,
            backlash=0.1 );
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
   color("gray")
     rotate([0,0,90])
        translate([0,-0,2])
            import("./Stl/Futaba3003.stl",center = true); 
    }
}

module Amplificadora_servo_z(){
    union(){    
    //PequeñaAmplificadora 
        translate([0,12,0])   
        rotate([90,70,0])
            gear (
                mm_per_tooth    = modulo_transmision_amp, number_of_teeth =6,   thickness       = 12,   hole_diameter   = diam_eje_amplif,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.1,  backlash        = 0.0  );
        
    //GrandeAmplificadora           
        rotate([90,32,0])
            gear (
                mm_per_tooth    = modulo_transmision_vert, number_of_teeth =15,   thickness       =Ancho_amplif_grande,   hole_diameter   = diam_eje_amplif,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.0,  backlash        = 0.0  );
    }    
}    

// Eje principal

module Eje_Transmision(){
difference(){
    union(){
        // Rueda dentada para permitir giro en alfa
           translate([0,0,altura_tope/2+altura_rueda/2])     
                gear_bevel(m = modulo_transmision,  //dientes/mm
                                        z =teethNum,    // Numero de dientes
                                        x =0,     //Profile shift
                                        h = altura_rueda,   // Altura de la rueda
                                        w = 25,   // angulo de los dientes
                                        w_bevel = 0, // Ángulo de la rueda
                                        w_helix = 0,   //angulo de los dientes
                                        D = 50,         //??
                                        clearance = -0.1,  // Hueco entre ruedas
                                        center = true ); 
        // Tope del eje con <carrier>
            cylinder(h=altura_tope,d = Diam_eje_rotatorio+5,$fn=50,center=true);
        
        // Eje para permitir movimiento en Z 
            cylinder(h=Altura_eje,d = Diam_eje_rotatorio-margen_holgura,$fn=50,
center=true);
        
        // Plataforma superior para sujección del servo Z
        translate([0,0,(altura_tope/2)+altura_rueda])
            cylinder(h = (Altura_eje-altura_tope)/2-altura_rueda, d1 = Diam_eje_rotatorio, d2 = Diam_Plataforma_sup, center = true/false);
        
        // Servo
        translate([36.5,66,Altura_eje/2+12.5])
        rotate([0,90,-90])
            servo();
            
        // Plataforma para servo superior
        difference(){
            translate([30,20,Altura_eje/2-Grosor_Plataforma_sup/2])
                cube([55,100,Grosor_Plataforma_sup],center=true);
            
            translate([46,14,12.5+Altura_eje/2])
                rotate([90,-5,0])
                cylinder(h=ancho_rueda_servo_sup+5,d=45,center=true);      
        }
         // Eje para Ruedas de Amplificacion     

        difference(){
            
            translate([Amplif_Pos_X,-2-Ancho_amplif_grande/2-ancho_soporte_amplif/2,(Altura_eje/2)+(Altura_ejeAmp/2)])
                cube([ancho_soporte_amplif,ancho_soporte_amplif,Altura_ejeAmp],center=true);
            translate([Amplif_Pos_X,-Ancho_amplif_grande,32+Altura_eje/2])
                rotate([90,0,0])
               cylinder(d=diam_eje_amplif, h =100,center=true);
        }
    }
    scale([1.04,1.04,1])
        eje_direccional();
}

// PIEZAS ANEXAS!
// Variables
d_Boca_Servo=22; //mm

//Eje dentado para transmisión en Z
translate([0,0,-12])
render()
    eje_dentado();

//Rueda servo en Z
//Servo
color("green")
translate([46,14,12.5+Altura_eje/2])     
    rotate([90,-5,0])
    render()
        gear (
            mm_per_tooth    = modulo_transmision_amp, number_of_teeth =15,   thickness       = ancho_rueda_servo_sup,   hole_diameter   = 3,    twist           = 0,   teeth_to_hide   = 0,  pressure_angle  = 28,  clearance       = 0.1,  backlash        = 0.0  );

// Sistema de engranajes
translate([Amplif_Pos_X,0,32+Altura_eje/2]) 
    render()
        Amplificadora_servo_z();  
            

//Rueda acoplada a servo en alpha
*translate([70,0,0])    
    rotate([0,180,0])
        difference(){
                gear_bevel(m = modulo_transmision,  //dientes/mm
                        z =teethNum*2,    // Numero de dientes
                        x =0,     //Profile shift
                        h = altura_rueda,   // Altura de la rueda
                        w = 25,   // angulo de los dientes
                        w_bevel = 0, // Ángulo de la rueda
                        w_helix = 0,   //angulo de los dientes
                        D = 0,         //??
                        clearance = -0.1,  // Hueco entre ruedas
                        center = true
                        );
                // Hueco para servo
             translate([0,0,-4])
                cylinder(h=8,d=d_Boca_Servo,center=true); 
        }
 }