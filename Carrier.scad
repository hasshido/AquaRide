// Variables

$fn=30;
Radio_eje_rueda=2;
Dims_rueda=[12, 22 ,12] ;
Dist_bar=40; //distancia de una varilla al centro
Posicion_Poleas=[20,45,5];
Diam_eje_rotatorio=15;


// Módulos
module mirror_XY(Pos=[10,10,0])
 {
    translate(Pos)
        children();
    
    mirror([1,0,0])
        translate(Pos)
            children();
    mirror([0,1,0])
        translate(Pos)
           children();

    mirror([1,0,0])
        mirror([0,1,0])
            translate(Pos)
                children();
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

// Main code

union(){
    
    difference(){
        
        cube([100,110,10],center=true);
        
        // Replicamos con respecto al medio un cubo con las dimensiones de la rueda
        mirror_XY(Pos=[Dist_bar,40,0])
            cube(Dims_rueda,center=true);
        // Los ejes de las ruedas
        mirror_XY(Pos=[Dist_bar-10,40,0])
            rotate([0,90,0])
                cylinder(h=100,r=Radio_eje_rueda);
        
        // Hueco central
        cylinder(h=30,d=Diam_eje_rotatorio,$fn=50,center=true);
        

    }
    // Añadir poleas SUJETO A CAMBIOS
    color("orange")
    mirror_XY(Pos=Posicion_Poleas)
        import("./Stl/Cabo_Hilos.stl");
    
    color("blue")
    translate([0,0,25])
        import("./Stl/Eje_Transmision.stl");
 
   //rotate([0,0,90])
    translate([0,45,5])
        servo();
    
    
    color("teal")
    mirror([0,0,1])
    translate([-70,55,-50])
        import("./Stl/Eje_Transmision_rueda.stl",center = true);   
    
    
    
}









       

