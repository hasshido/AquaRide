module mirrorXY(Pos=[10,10,0])
 {
    translate(Pos)
        child();
    
    mirror([1,0,0])
        translate(Pos)
            child();
    mirror([0,1,0])
        translate(Pos)
           child();

    mirror([1,0,0])
        mirror([0,1,0])
            translate(Pos)
                child();
}

// Módulos
module mirrorX(Pos=[10,10,0])
 {
    translate(Pos)
        child(); 
    mirror([1,0,0])
        translate(Pos)
            child();
}

module mirrorY(Pos=[10,10,0])
 {
    translate(Pos)
        child(); 
    mirror([0,1,0])
        translate(Pos)
           child();
}

module mirrorZ(Pos=[10,10,0])
 {
    translate(Pos)
        child(); 	
    mirror([0,1,0])
        translate(Pos)
           child();
}


