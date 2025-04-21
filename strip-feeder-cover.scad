tab_length_mm = 2;
tab_height_mm = 4;

base_width_mm = 6.5;
base_length_mm = 91 + (2 * tab_length_mm);
base_height_mm = 2;

union(){
    linear_extrude(height = base_height_mm, center = false)
        square([ base_width_mm, base_length_mm]);

    translate([0, 0, 0])
        linear_extrude(height = tab_height_mm, center = false)
            square([ base_width_mm, tab_length_mm]);

    translate([0, base_length_mm - tab_length_mm, 0])
        linear_extrude(height = tab_height_mm, center = false)
            square([ base_width_mm, tab_length_mm]);
}