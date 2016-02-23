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

teethNum=9;
Diam_eje_rotatorio=23;
Diam_Plataforma_sup=40;
Grosor_Plataforma_sup=6;
Altura_eje=100;
grosor_eje=4;
margen_holgura=2;
altura_tope=42; // Establecer en base al tamaño del motor
altura_rueda=8;
modulo_transmision=4;

module eje_direccional(){
    difference(){        
        cylinder(h=Altura_eje+10,d = Diam_eje_rotatorio-margen_holgura-grosor_eje,$fn=50,center=true);
        translate([Diam_eje_rotatorio-Diam_eje_rotatorio/3.5,0,0])
            cube([Diam_eje_rotatorio,Diam_eje_rotatorio,Altura_eje+10],center=true);
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


// Eje principal
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
                                        center = true
                                    ); 
        
        // Tope del eje con <carrier>
            cylinder(h=altura_tope,d = Diam_eje_rotatorio+5,$fn=50,center=true);
        
        // Eje para permitir movimiento en Z 
            cylinder(h=Altura_eje,d = Diam_eje_rotatorio-margen_holgura,$fn=50,
center=true);
        
        // Plataforma superior para sujección del servo Z
        translate([0,0,(altura_tope/2)+altura_rueda])
            cylinder(h = (Altura_eje-altura_tope)/2-altura_rueda, d1 = Diam_eje_rotatorio, d2 = Diam_Plataforma_sup, center = true/false);
            
        translate([30,45,Altura_eje/2+12])
        rotate([0,-90,90])
            servo();
        translate([30,20,Altura_eje/2-Grosor_Plataforma_sup/2])
            cube([55,60,Grosor_Plataforma_sup],center=true);

    }
    scale([1.04,1.04,1])
        eje_direccional();
}



// PIEZAS ANEXAS!
// Variables
d_Boca_Servo=22; //mm

//translate([-25,0,10])
*rotate([90,0,0])
    eje_direccional();
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
