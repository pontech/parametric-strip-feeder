strip_length_mm = 90;
base_height_mm = 2;
base_width_mm = 3;

tape_height_mm = 10;
tape_width_mm = 1;

track_window_width_mm = 2.5;
track_base_width_mm = 2.5;
track_height_mm = base_height_mm + tape_height_mm;

track_width_mm = track_window_width_mm + tape_width_mm + track_base_width_mm;

window_length_mm = strip_length_mm * 0.75; 
window_height_mm = 7.5; 


module track_tape() {
    difference(){
        union() {
            // base
            cube([track_width_mm,strip_length_mm,base_height_mm]);
            
            // tape track (window)
            translate([0,0,0])
                cube([track_window_width_mm,strip_length_mm,track_height_mm]);
            translate([track_window_width_mm + tape_width_mm,0,0])
                cube([track_base_width_mm,strip_length_mm,track_height_mm]);
        }

        // Windwow
        translate([-0.1, (strip_length_mm - window_length_mm) / 2,base_height_mm])
            cube([track_window_width_mm + 0.2,window_length_mm,window_height_mm]);
    }
}

module track_foot() {
    standoff_width_mm = 2;
    standoff_length_mm = 3;
    key_width_mm = 2;
    key_length_mm = 8;
    total_width_mm = standoff_width_mm + key_width_mm;
    total_length_mm = key_length_mm;
    
    foot_height_mm = base_height_mm + 8;
    
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

module track_cover_catch() {
    peg_width_mm = 3;
    peg_length_mm = 2;
    peg_gap_length_mm = 1;
    peg_pluse_gap_mm = peg_length_mm + peg_gap_length_mm;
    pegs = 3;

    total_width_mm = peg_width_mm + 3;
    total_length_mm = pegs * peg_length_mm + (pegs - 1) * peg_gap_length_mm;
    
    translate([-total_width_mm,0,0])
        union(){
            // base
            translate([0,0,0])
                cube([total_width_mm,total_length_mm,base_height_mm]);
            // peg(s)
            translate([0,0 * peg_pluse_gap_mm,0])
                cube([peg_width_mm,peg_length_mm,track_height_mm]);
            translate([0,1 * peg_pluse_gap_mm,0])
                cube([total_width_mm,peg_length_mm,track_height_mm]);
            translate([0,2 * peg_pluse_gap_mm,0])
                cube([peg_width_mm,peg_length_mm,track_height_mm]);
        }
    
}

union() {
    track_tape();
    translate([track_width_mm,5,0])
        track_foot();
    translate([track_width_mm,strip_length_mm -3,0])
        track_foot();

    translate([0,0,0])
        track_cover_catch();
}
