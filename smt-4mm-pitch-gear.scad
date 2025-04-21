// === Parameters ===
hole_pitch = 4;               // Distance between tape holes (mm)
tooth_width = 1.0;            // Width of each tooth (approx hole size)
tooth_height = 1.5;           // How far tooth sticks out from gear edge
gear_thickness = 1.0;           // Thickness of the flat gear
center_hole_diameter = 5;     // Shaft hole in center

num_teeth = 25;  // derived later if needed
gear_pitch_diameter = hole_pitch * num_teeth / PI;  // Ensures 4mm pitch

// === Gear generation ===
module smt_tape_sprocket() {
    tooth_radius = gear_pitch_diameter / 2 + 0;
    hub_radius = tooth_radius - tooth_height + 0.1;

    union() {
        // Base gear disk
        difference() {
            cylinder(h = gear_thickness, r = hub_radius, center=true, $fn=100);
            
            // Optional shaft hole
            translate([0,0,-0.1])
            cylinder(h = gear_thickness + 1, r = center_hole_diameter / 2, center=true, $fn=50);

            // Key
            cube([2,center_hole_diameter * 1.5,gear_thickness*2], center=true);
        }

        // Add teeth around the perimeter
        for (i = [0 : num_teeth - 1]) {
            angle = i * 360 / num_teeth;
            x = (tooth_radius - tooth_height / 2) * cos(angle);
            y = (tooth_radius - tooth_height / 2) * sin(angle);

            // Teeth are small rectangular extrusions
            translate([x, y, 0])
            rotate([0, 0, angle])
            cube([tooth_height, tooth_width, gear_thickness], center=true);
        }
    }
}

// === Run it ===
smt_tape_sprocket();
