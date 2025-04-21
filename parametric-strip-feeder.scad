/////////////////////////////////////////////////////////////////////
//                            CC Atribution                        //
/////////////////////////////////////////////////////////////////////
// by: Jacob Christ @ pontech.com
/////////////////////////////////////////////////////////////////////
echo(version=version());

base_length_mm = 90; // Opulo standard strip feeder length = 120mm

// Set the next Qty8mm, Qty12mm, and Qty16mm to an integer number of strips
Qty8mm = 0;
Qty12mm = 0;
Qty16mm = 9;

// screw_offset_mm adjusts the screw center in the base (left to right)
screw_offset_mm = -4.5;

// ear_ parameters allow for adding an addition ear to the feeder
ear_8mm_side_mm = 0;
ear_16mm_side_mm = 0;


base_height_mm = 2;

wall_height_mm = 10 + base_height_mm;
wall_height_to_tape_mm = 7 + base_height_mm;
wall_length_mm = base_length_mm;

/////////////////////////////////////////////////////////////////////
//                            WARNING!!!                           //
/////////////////////////////////////////////////////////////////////
// Changing the wall_width_mm has not been tested and may not work.
/////////////////////////////////////////////////////////////////////
wall_width_mm = 2;
wall_half_width_mm = wall_width_mm / 2;

tape_width_8mm = 8 + wall_width_mm - 1;
tape_width_12mm = 12 + wall_width_mm - 1;
tape_width_16mm = 16 + wall_width_mm - 1;

tape_height_mm = 1;

// base_height_mm+wall_height_to_tape_mm+tape_height_mm

module wall() {
    // Wall
    wall_profile = [
        [-wall_half_width_mm, 0],
        [-wall_half_width_mm, wall_height_to_tape_mm],
        [-wall_half_width_mm + 0.5, wall_height_to_tape_mm],
        [-wall_half_width_mm + 0.5, wall_height_to_tape_mm + tape_height_mm],
        [-wall_half_width_mm, wall_height_to_tape_mm + tape_height_mm + 0.5],
        [-wall_half_width_mm, wall_height_mm],
        [wall_half_width_mm, wall_height_mm],
        [wall_half_width_mm, wall_height_to_tape_mm + tape_height_mm + 0.5],
        [wall_half_width_mm - 0.5, wall_height_to_tape_mm + tape_height_mm],
        [wall_half_width_mm - 0.5, wall_height_to_tape_mm],
        [wall_half_width_mm, wall_height_to_tape_mm],
        [wall_half_width_mm, 0]
    ];
    linear_extrude(height = base_length_mm, center = true)
        polygon(wall_profile);
}

module screw_hole_cutter(through_all = false) {
    screw_hole_diameter_mm = 5.75;
    screw_bore_diameter_mm = 8;
    screw_hole_radius_mm = screw_hole_diameter_mm / 2;
    screw_bore_radius_mm = screw_bore_diameter_mm / 2;

    if(through_all){
        cutter_height = wall_height_mm;
            rotate([-90,0,0]){
                cylinder(h = cutter_height, r1 = screw_hole_radius_mm , r2 = screw_hole_radius_mm , center = false, $fn=64);
                translate([0, 0, base_height_mm/2])
                    cylinder(h = cutter_height, r1 = screw_bore_radius_mm, r2 = screw_bore_radius_mm, center = false, $fn=64);
            }
    }
    else{
        cutter_height = base_height_mm*2;
            rotate([-90,0,0]){
                cylinder(h = cutter_height, r1 = screw_hole_radius_mm, r2 = screw_hole_radius_mm, center = false, $fn=64);
                translate([0, 0, base_height_mm/2])
                    cylinder(h = base_height_mm, r1 = screw_bore_radius_mm, r2 = screw_bore_radius_mm, center = false, $fn=64);
                translate([0, 0, base_height_mm*1.5])
                    cylinder(h = cutter_height, r1 = screw_bore_radius_mm, r2 = 0, center = false, $fn=64);
            }
    }
    
}

module screw_hole_cutter_array() {
    translate([-screw_offset_mm,0,0])
        for(w = [0: 15: base_width_mm])
            for(l = [-base_length_mm/2: 15: base_length_mm/2])
                translate([w, -0.1, l])
                    //if(w % 45 == 0)
                    //if(w == 7 * 15)
                    //    screw_hole_cutter(true);
                    //else
                        screw_hole_cutter(false);
}


// Base
base_width_mm = (Qty8mm * tape_width_8mm) + (Qty12mm * tape_width_12mm) + (Qty16mm * tape_width_16mm) + wall_width_mm + ear_8mm_side_mm + ear_16mm_side_mm ;
color("gray")
    difference(){
        union () {
            translate([-wall_half_width_mm -ear_8mm_side_mm , 0, 0])
                linear_extrude(height = base_length_mm, center = true)
                    square([ base_width_mm, base_height_mm]);

            // 8mm Walls
            for (a = [ 0 : tape_width_8mm : Qty8mm * tape_width_8mm])
            {
                translate([a, 0, 0])
                    wall();
            }

            // 12mm Walls
            offset_12mm = Qty8mm * tape_width_8mm;
            for (a = [ offset_12mm  : tape_width_12mm : offset_12mm + Qty12mm * tape_width_12mm ])
            {
                translate([a, 0, 0])
                    wall();
            }

            // 16mm Walls
            offset_16mm = offset_12mm + Qty12mm * tape_width_12mm;
            for (a = [ offset_16mm  : tape_width_16mm : offset_16mm + Qty16mm * tape_width_16mm ])
            {
                translate([a, 0, 0])
                    wall();
            }
        }

        screw_hole_cutter_array();

    }

// Uncomment the following line to render the screw hole cutting tool
//screw_hole_cutter_array();







