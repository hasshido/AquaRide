Dist_bar=40; //distancia de una varilla al centro
radius_bar =5.3; //mm
largo_bar=100;
pos_bar=[0,Dist_bar,9];
margen_bar=1;
ancho_cristal=5.5+0.4;
ancho_pestanita=6;

use <Mirror.scad>
use <Polea_baja.scad>

Altura_Base=36;
Anchura_Base= (Dist_bar*2)+20;
Largo_Base=45;

module varilla(){
    translate([largo_bar/2,0,0])
        rotate([0,90,0])
        cylinder(r=radius_bar+margen_bar, h=largo_bar,center=true,$fn=100);
}


module wagon(){
    difference(){
        translate([5,0,0])
        cube([Largo_Base,Anchura_Base,Altura_Base],center=true);
        
        translate([0,-Anchura_Base/2-5,-Altura_Base])
            cube([Largo_Base,Anchura_Base+10,Altura_Base]);
        
        %mirrorY(pos_bar)
            varilla();

        difference(){
            translate([-Largo_Base-8,-(Anchura_Base+5)/2,0+8])
             cube([Largo_Base,Anchura_Base+5,Altura_Base]);
            
            translate([-8,0,8])
            rotate([90,0,0])
            cylinder(r=10,h=Anchura_Base+6,center=true);   
        }

    }
    
    mirrorY([5,Dist_bar/2,21])
        Polea_baja();

    
}

wagon();
