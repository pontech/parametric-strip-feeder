render_lid = false;
render_tray = true;

carrier_width_mm = 15;
carrier_length_mm = 120;
carrier_height_mm = 6.5;

// Set pocket definitions here:
pocket_to_next_mm = 1; // spacing between like pockets
pocket_to_pocket_mm = 1; // spacking between different pockets

// width, length, depth
pockets = [
    [10.5 + 0.1,  7.8 + 0.1, 4.55 + 0.1], // OLP-000049 - 6-SMD DIP
    [8.75 + 0.1,  6.2 + 0.1, 1.75 + 0.1], // OLP-000055 - 14-SOIC
    [ 5.1 + 0.1,  6.2 + 0.1, 1.75 + 0.1], // OLP-0000?? - 8-SOIC
];

// The index below selects the pocket from above
pocket = pockets[0];
wall_width_mm = 1.2;


// === Dovetail Profile (2D)
module dovetail_profile(dovetail_angle,     // Degrees
                        dovetail_depth,     // Vertical height
                        dovetail_width,     // Bottom (narrow) width
                        ) {
    // How much wider top is than bottom
    half_top_extra = dovetail_depth * tan(dovetail_angle);  
    
    polygon([
        [0, 0],
        [dovetail_width, 0],
        [dovetail_width + half_top_extra, dovetail_depth],
        [-half_top_extra, dovetail_depth]
    ]);
}

// === Dovetail Slot
module dovetail(dovetail_length_mm = 12,
                dovetail_angle = 90-55,      // Degrees
                dovetail_depth = 1.6,       // Vertical height
                dovetail_width = 1.55,      // Bottom (narrow) width
            ) {
    
    translate([-dovetail_width/2,dovetail_length_mm,-0.001])
    rotate([90,0,0])
        linear_extrude(height = dovetail_length_mm)
            dovetail_profile(dovetail_angle,dovetail_depth,dovetail_width);
    
}

module menlu_dovetail() {
    dovetail_length_mm = 13;  // Extrusion thickness (e.g., length of slot)
    dovetail_z_offset_mm = -0.1;
    inter_dovetail_mm = 5;
    

    translate([-inter_dovetail_mm, 0, dovetail_z_offset_mm])
        dovetail(dovetail_length_mm);
    translate([0, 0, dovetail_z_offset_mm])
        dovetail(dovetail_length_mm);
    translate([inter_dovetail_mm, 0, dovetail_z_offset_mm])
        dovetail(dovetail_length_mm);

    keyhole_width_mm = 2.5;
    keyhole_height_mm = 1.5;
    translate([-5, dovetail_length_mm-0.1, -0.1])
        translate([-keyhole_width_mm/2,0,0])
            cube([keyhole_width_mm,dovetail_length_mm,keyhole_height_mm]);
    translate([0, dovetail_length_mm-0.1, -0.1])
        translate([-keyhole_width_mm/2,0,0])
            cube([keyhole_width_mm,dovetail_length_mm,keyhole_height_mm]);
    translate([5, dovetail_length_mm-0.1, -0.1])
        translate([-keyhole_width_mm/2,0,0])
            cube([keyhole_width_mm,dovetail_length_mm,keyhole_height_mm]);

}

//////////////////////////////
// Render Tray
//////////////////////////////
if(render_tray == true){
    difference(){
        union(){
            // tray body
            translate([-carrier_width_mm/2,-0.1, 0])
                cube([carrier_width_mm, carrier_length_mm, carrier_height_mm]);
            
            // tray walls
            translate([0,0,carrier_height_mm]){
                
                translate([-carrier_width_mm/2 + wall_width_mm/2,0,0])
                    translate([-wall_width_mm/2,0,0])
                        cube([wall_width_mm,carrier_length_mm, 2]);

                translate([carrier_width_mm/2 - wall_width_mm/2,0,0])
                    translate([-wall_width_mm/2,0,0])
                        cube([wall_width_mm,carrier_length_mm, 2]);
            }
        }

        // Menlu Keyway Cutouts
        color("blue")
        translate([0,0,0]){
            translate([0, 0,0])
                menlu_dovetail();
            translate([0, 82,0])
                menlu_dovetail();
        }

        // part pockets
        color("red")
        for( p = [pocket_to_next_mm : pocket[1] + pocket_to_next_mm : carrier_length_mm])
            translate([-pocket[0]/2,p,carrier_height_mm - pocket[2] ])
                cube(pocket);

        // lid cutout
        color("green")
        translate([0,0,carrier_height_mm +1])
            rotate([0,180,0])
                dovetail(dovetail_length_mm = carrier_length_mm,
                        dovetail_angle = 45,
                        dovetail_depth = 1.1,
                        dovetail_width = carrier_width_mm - (3 * wall_width_mm)
                    );

    }
}



//////////////////////////////
// Render Lid
//////////////////////////////
if(render_lid == true){
    // lid cutout
    color("green")
        translate([0,0,carrier_height_mm +1])
        difference() {
            rotate([0,180,0])
                dovetail(dovetail_length_mm = carrier_length_mm,
                        dovetail_angle = 45,
                        dovetail_depth = 1.1,
                        dovetail_width = carrier_width_mm - (3 * wall_width_mm)
                    );

            window_percentage = 0.90;
            translate([-1,carrier_length_mm * (1-window_percentage) / 2, -3])
            cube([2,carrier_length_mm * window_percentage, 4]);

        }
}



