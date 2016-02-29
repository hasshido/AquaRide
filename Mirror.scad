module mirrorXY(Pos=[10,10,0])
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

// Módulos
module mirrorX(Pos=[10,10,0])
 {
    translate(Pos)
        children(); 
    mirror([1,0,0])
        translate(Pos)
            children();
}

module mirrorY(Pos=[10,10,0])
 {
    translate(Pos)
        children(); 
    mirror([0,1,0])
        translate(Pos)
           children();
}

module mirrorZ(Pos=[10,10,0])
 {
    translate(Pos)
        children(); 
    mirror([0,1,0])
        translate(Pos)
           children();
}


