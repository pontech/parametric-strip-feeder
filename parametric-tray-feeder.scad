/////////////////////////////////////////////////////////////////////
//                            CC Atribution                        //
/////////////////////////////////////////////////////////////////////
// by: Jacob Christ @ pontech.com
/////////////////////////////////////////////////////////////////////
echo(version=version());

base_length_mm = 40; // Opulo standard strip feeder length = 120mm
base_width_mm = 29;
base_height_min_mm = 2;// + 7;
base_height_mm = base_height_min_mm + 7;

// Set pocket definitions here:
pocket_to_next_mm = 1; // spacing between like pockets
pocket_to_pocket_mm = 1; // spacking between different pockets

// width, length, depth
pockets = [
//    [10, 10, 1],
//    [10, 10, 1],
//    [5, 5, 1],
    [10.5,  7.8, 4.55], // OLP-000049 - 6-SMD DIP
    [8.75,  6.2, 1.75], // OLp-000055 - 14-SOIC
    [ 5.1,  6.2, 1.75],
];

echo(base_width_mm);
echo(len(pockets));

// screw_x_offset_mm adjusts the screw center in the base (left to right)
screw_x_offset_mm = -4;
screw_y_offset_mm = 4.5;

// ear_ parameters allow for adding an addition ear to the feeder
ear_8mm_side_mm = 0;
ear_16mm_side_mm = 10;

tape_height_mm = 1;


module screw_hole_cutter(through_all = false) {
    screw_hole_diameter_mm = 5.75;
    screw_bore_diameter_mm = 8;
    screw_hole_radius_mm = screw_hole_diameter_mm / 2;
    screw_bore_radius_mm = screw_bore_diameter_mm / 2;

    if(through_all){
        cutter_height = base_height_min_mm;
            rotate([0,0,0]){
                cylinder(h = cutter_height, r1 = screw_hole_radius_mm , r2 = screw_hole_radius_mm , center = false, $fn=64);
                translate([0, 0, base_height_min_mm/2])
                    cylinder(h = cutter_height, r1 = screw_bore_radius_mm, r2 = screw_bore_radius_mm, center = false, $fn=64);
            }
    }
    else{
        cutter_height = base_height_min_mm;
            rotate([0,0,0]){
                union(){
                cylinder(h = cutter_height, r1 = screw_hole_radius_mm, r2 = screw_hole_radius_mm, center = false, $fn=64);
                translate([0, 0, cutter_height-.01])
                    cylinder(h = screw_hole_radius_mm, r1 = screw_hole_radius_mm, r2 = 0, center = false, $fn=64);
                }
            }
    }
    
}

module screw_hole_cutter_array() {
    translate([-screw_x_offset_mm,screw_y_offset_mm,0])
        for(w = [0: 15: base_width_mm + ear_16mm_side_mm])
            for(l = [0: 15: base_length_mm])
                translate([w, l, -0.1])
                    if(w >= base_width_mm )
                        screw_hole_cutter(true);
                    else
                        screw_hole_cutter(false);
}


// Trays
cutter_offset = 1.005;
difference(){
    difference() {
        union() {
            // Base
            color("gray")
            translate([0 - ear_8mm_side_mm , 0, 0])
                linear_extrude(height = base_height_mm, center = false)
                    square([ base_width_mm, base_length_mm]);

            color("gray")
            translate([0 - ear_8mm_side_mm , 0, 0])
                linear_extrude(height = base_height_min_mm, center = false)
                    square([ base_width_mm + ear_16mm_side_mm , base_length_mm]);
        }

        // Pockets
        color("yellow")
        {
            p = 0;
            pocket = pockets[p];
            pocket_x = pocket[0];
            pocket_y = pocket[1];
            
            col_spacing_mm = pocket_to_pocket_mm + pocket_x ;
            row_spacing_mm = pocket_to_next_mm + pocket_y;

            col_count = floor(base_length_mm / row_spacing_mm);
            echo("count", p, col_count);

            for (i = [0 : col_count -1])
            {
                x_pos = p * col_spacing_mm + pocket_to_pocket_mm;
                y_pos = i * row_spacing_mm + pocket_to_next_mm;
                echo(p, i, x_pos, y_pos);
                translate([x_pos, y_pos, base_height_mm - pockets[p][2] + cutter_offset])
                    cube([pockets[p][0],pockets[p][1],pockets[p][2]]);
            }
        }

        color("yellow")
        {
            p = 1;
            pocket = pockets[p];
            pocket_x = pocket[0];
            pocket_y = pocket[1];
            
            col_spacing_mm = pocket_to_pocket_mm + pockets[0][0] ;
            row_spacing_mm = pocket_to_next_mm + pocket_y;

            col_count = floor(base_length_mm / row_spacing_mm);
            echo("count", p, col_count);

            for (i = [0 : col_count -1])
            {
                x_pos = p * col_spacing_mm + pocket_to_pocket_mm;
                y_pos = i * row_spacing_mm + pocket_to_next_mm;
                echo(p, i, x_pos, y_pos);
                translate([x_pos, y_pos, base_height_mm - pockets[p][2] + cutter_offset])
                    cube([pockets[p][0],pockets[p][1],pockets[p][2]]);
            }
        }

        color("yellow")
        {
            p = 2;
            pocket = pockets[p];
            pocket_x = pocket[0];
            pocket_y = pocket[1];
            
            col_spacing_mm = pocket_to_pocket_mm + pockets[0][0] + pocket_to_pocket_mm + pockets[1][0];
            row_spacing_mm = pocket_to_next_mm + pocket_y;

            col_count = floor(base_length_mm / row_spacing_mm);
            echo("count", p, col_count);

            for (i = [0 : col_count -1])
            {
                x_pos = 1 * col_spacing_mm + pocket_to_pocket_mm;
                y_pos = i * row_spacing_mm + pocket_to_next_mm;
                echo(p, i, x_pos, y_pos);
                translate([x_pos, y_pos, base_height_mm - pockets[p][2] + cutter_offset])
                    cube([pockets[p][0],pockets[p][1],pockets[p][2]]);
            }
        }


        screw_hole_cutter_array();

    }
}
// Uncomment the following line to render the screw hole cutting tool
//screw_hole_cutter_array();







// Pockets
//color("yellow")
//            for(p = [0 : len(pockets) - 1]){
//                pocket = pockets[p];
//                pocket_x = pocket[0];
//                pocket_y = pocket[1];
//                
//                col_spacing_mm = pocket_to_pocket_mm + pocket_x ;
//                row_spacing_mm = pocket_to_next_mm + pocket_y;
//
//                col_count = floor(base_length_mm / row_spacing_mm);
//                echo("count", p, col_count);
//
//                for (i = [0 : col_count -1])
//                {
//                    x_pos = p * col_spacing_mm + pocket_to_pocket_mm;
//                    y_pos = i *  + pocket_to_next_mm;
//                    echo(p, i, x_pos, y_pos)
//                    translate([x_pos, y_pos, base_height_mm - pockets[p][2] + 1.005])
//                        cube([pockets[p][0],pockets[p][1],pockets[p][2]]);
//                }
//            }
//        }


