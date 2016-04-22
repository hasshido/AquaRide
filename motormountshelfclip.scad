

joinfactor=0.125;

gDefaultMountHoleRadius = 3/2*1.1; 
gDefaultMountSlotLength = 10;
gNema17MountDiagonal = 43;

nema17shaftplate(43, 43, 3);

//motorMountShelfClip(42, 42, 12, 20, 6.5);

//motorMountShelfClipLong(42, 42, 12, 20, 6.5);

//motorMountShelfClipFront(42, 12, 44, 38, 6.5);



//=============================================
// Modules
//=============================================
module squaretube(innerWidth, innerDepth, width, depth, thickness) 
{
	difference()
	{
		cube(size=[width, depth, thickness], center=true);

		// Subtract the inner square
		cube(size=[innerWidth, innerDepth, thickness+joinfactor*2], center=true);
	}
}

module nema17shaftplate(width, height, thickness) 
{
	mountHoleRadius = 3/2*1.1;
	mountRadius = gNema17MountDiagonal/2;
	
	shaftcollarradius = 11.5;
	
	difference()
	{
		cube(size=[width, height, thickness], center=true);
		
		// Subtract a circle for the collar around the shaft
		cylinder(r=shaftcollarradius, h=thickness+2*joinfactor, center=true);
		
		// Create the mounting holes
		for(hole=[0:3])
		{
			rotate([0,0,(hole*90)+45])
			translate([mountRadius, 0, 0])
			cylinder(r=mountHoleRadius, h=thickness+2*joinfactor, center=true, $fn=12);
		}
	}
}


module motorMountShelfClip(width, depth, height, extent, gap)
{
	
	wallthickness = 3; 
	OuterWidth = width+2*wallthickness;
	OuterDepth = depth +2*wallthickness;

	union()
	{
		squaretube(width, depth, OuterWidth, OuterDepth, height);
	

		// Attach the shelf pads
		translate([-width/2-wallthickness, depth/2, -height/2])
		cube(size=[wallthickness, extent+wallthickness, height]);
	
		translate([-width/2+gap, depth/2, -height/2])
		cube(size=[wallthickness, extent+wallthickness, height]);
	}
}

module motorMountShelfClipLong(width, depth, height, extent, gap)
{
	wallthickness = 3; 
	OuterWidth = width+2*wallthickness;
	OuterDepth = depth +2*wallthickness;

	union()
	{
		squaretube(width, depth, OuterWidth, OuterDepth, height);
	
		// Attach the shelf pads
		translate([-width/2-wallthickness/2, (gap+wallthickness)/2+depth/2+wallthickness,0])
		cube(size=[wallthickness,gap+wallthickness+joinfactor, height], center=true);
	
		translate([0, depth/2+gap+wallthickness+wallthickness/2, 0])
		cube(size=[OuterWidth, wallthickness, height], center=true);
	}
}

module motorMountShelfClipFront(width, depth, height, extent, gap)
{
	wallthickness = 3; 
	OuterWidth = width+2*wallthickness;
	OuterHeight = height +2*wallthickness;

	translate([OuterWidth/2, OuterHeight/2, depth/2])
	squaretube(width, height, OuterWidth, OuterHeight, depth);

	translate([wallthickness+width/2-joinfactor, height/2+wallthickness-joinfactor, wallthickness/2])
		nema17shaftplate(width+joinfactor*2, height+joinfactor*2, wallthickness);

	// Shelf clip
	translate([0, 0, 0])
	cube(size=[OuterWidth, wallthickness, extent]);

	translate([0, -wallthickness-gap,0])
	cube(size=[OuterWidth, wallthickness, extent]);

	translate([0, -wallthickness-gap+joinfactor,0])
	cube(size=[OuterWidth, gap+wallthickness+joinfactor*2, wallthickness]);
}