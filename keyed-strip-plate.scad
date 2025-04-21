module track_foot(base_height_mm = 2.1) {
    standoff_width_mm = 2;
    standoff_length_mm = 3;
    key_width_mm = 2;
    key_length_mm = 8.1;
    total_width_mm = standoff_width_mm + key_width_mm;
    total_length_mm = key_length_mm;
    
    foot_height_mm = base_height_mm + 8.1;
    
    union(){
        // base
        translate([0,standoff_length_mm - key_length_mm,0])
            cube([total_width_mm,total_length_mm,base_height_mm]);
        // standoff
        cube([standoff_width_mm,standoff_length_mm,foot_height_mm]);
        // key
        translate([standoff_width_mm,standoff_length_mm - key_length_mm,0])
            cube([key_width_mm,key_length_mm,foot_height_mm]);
    }
    
}

module key_hole() {
    translate([0, 5, 0])
        track_foot();

    translate([-2, 10, 0])
        track_foot();
}


difference(){
    translate([0.05, -5,-2])
        cube([1.5,110,15]);

    translate([0, 0, 0])
    key_hole();
    
    translate([0, 90, 0])
    key_hole();
}

//    translate([15, 15, 0])
//        track_foot();
