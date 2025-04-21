// Cover weight

tape_width_mm = 8;
weight_width_mm = tape_width_mm - 1.25;
weight_lenght_mm = 35;
weight_height_mm = 5;

cover_width_mm = weight_width_mm -1.4;

difference() {
    // Weight
    cube([weight_width_mm, weight_lenght_mm , weight_height_mm]);

    // Cover hole (front)
    translate([0.75, 1, -1])
        cube([cover_width_mm, 3, 7]);

    // Cover hole (rear)
    translate([0.75, weight_lenght_mm, 0.5])
        rotate([45, 0, 0])
            cube([cover_width_mm, 2.5, 8]);

    // wedge
    translate([-1, -5, 5])
        rotate([-75, 0, 0])
            cube ([tape_width_mm, 5, 5* weight_height_mm]);

}

