// TODO:
// - figure out the binding post configuration

use <external_parts.scad>

// material thickness
t = 3;

atx_psu_depth = 140; // TODO: measure

jog_wheel_radius = 35/2;

w = 250;
h = 100;
d = atx_psu_depth + 100;

binding_post_r = 12.3 / 2;
binding_post_spacing = 16;

lcd_w = 98;
lcd_h = 60;

spacer_h = 6;

module _ext() {
  color([.9,.9,.9, .5])
    linear_extrude(height=t, center=true) child(0);
}

// TODO:
// - holes for power supply back tabs
// - holes for mounting mainboard
// - holes for mounting channel modules
// - add power supply venting
module bottom() {
  square(size=[w, d], center=true);
}

module top() {
  
}

// TODO:
// - hole for lcd
// - mounting holes for lcd 
// - holes for binding posts
// - holes for channel indicator lights and switches
// - hole for jog wheel
// - hole for master on/off switch
// - holes for other buttons (!)
// - edge tabs
module face() {
  square(size=[w, h], center=true);
}

// TODO:
// - cutout for power supply parts
// - cutout for power supply mounting holes
// - bottom slots
// - side tabs
module back() {
  square(size=[w, h], center=true);
}

// TODO:
// - venting for power supply
// - slots all around
module side() {
  square(size=[d, h], center=true);
}

module jog_wheel_back() {
  difference() {
    circle(r=jog_wheel_radius, $fn=72);
    circle(r=3-l/2, $fn=72);
  }
}

module jog_wheel_front() {
  circle(r=jog_wheel_radius, $fn=72);
}

module _jog_wheel_assembly() {
  rotate([90, 0, 0]) _rotary_encoder();
  translate([0, -15 - t/2, 0]) rotate([90, 0, 0]) color("black") _ext() jog_wheel_front();
  translate([0, -15 + t / 2, 0]) rotate([90, 0, 0]) color("black") _ext() jog_wheel_back();
  translate([0, -15 + t + t / 2, 0]) rotate([90, 0, 0]) color("black") _ext() jog_wheel_back();
}

module _controls() {
  translate([0, 0, -lcd_h / 2 - 5]) {
    translate([-lcd_w/2 - jog_wheel_radius * 2 - 10, 0, 0]) rotate([90, 0, 0]) _lcd();
    translate([-5 - jog_wheel_radius, 0, 0]) _jog_wheel_assembly();
  }
}

module _binding_post_channel() {
  rotate([90, 0, 0]) {
    translate([-binding_post_spacing, 0, 0]) _binding_post();
    _binding_post();
    translate([binding_post_spacing, 0, 0]) _binding_post("red");
  }
}

module _fixed_channel() {
  rotate([90, 0, 0]) {
    for (x=[0:3]) {
      translate([-binding_post_spacing * x, 0, 0]) _binding_post("red");
    }
    translate([-4 * binding_post_spacing, 0, 0]) _binding_post();
  }
}

module assembled() {
  translate([-w/2 + t + spacer_h, -d/2 + 50 + t + t/2 + 3, -h/2 + 40 + 10]) 
    rotate([90, 0, 90]) 
      _mainboard_pcba();

  translate([0, -d / 2 + t + t / 2 + 20 + 25, -h/2 + t + spacer_h]) {
    translate([w/2 - t - 5 - 50, 0, 0])
      rotate([0, 0, 0]) _frontend_pcba();

    translate([w/2 - t - 5 - 50 - 5 - 100, 0, 0])
      rotate([0, 0, 0]) _frontend_pcba();
  }

  translate([-w/2 + t + 5 + 40, d/2 - t/2 - t - 25/2, 0]) 
    rotate([90, 0, 0]) _80mm_fan();

  
  translate([w / 2 - 150/2 - 2*t, d/2 - t - t/2, -h/2 + 86/2+t + t/2]) 
    rotate([0, 0, 180]) _atx_psu();
  
  translate([w/2, -d/2 + t + t/2, h/2]) _controls();

  translate([w/2 - 40, -d/2 + t/2, -h/2 + binding_post_r + 15]) _binding_post_channel();

  translate([w/2 - 100, -d/2 + t/2, -h/2 + binding_post_r + 15]) _binding_post_channel();

  translate([w/2 - 140, -d/2 + t/2, -h/2 + binding_post_r + 15]) _fixed_channel();

  // translate([-3.5 * binding_post_spacing, -d/2 + t/2, -h/2 + t + t + 12.3/2])
  // for (x=[0:7]) {
  //   translate([x * binding_post_spacing, 0, 0])
  //     rotate([90, 0, 0]) _binding_post();
  // }
  //
  // translate([3.5 * binding_post_spacing, -d/2 + t/2, -h/2 + t + t + 12.3/2 + 10 + 12.3/2])
  // for (x=[-1:0]) {
  //   translate([x * binding_post_spacing, 0, 0])
  //     rotate([90, 0, 0]) _binding_post();
  // }



  for (x=[-1,1]) {
    translate([x * (w/2 - t/2), 0, 0]) 
    rotate([90, 0, 90]) _ext() side();
  }
  
  translate([0, d/2 - t, 0]) rotate([90, 0, 0]) _ext() back();
  translate([0, -d/2 + t, 0]) rotate([90, 0, 0]) _ext() face();
  
  translate([0, 0, -h/2 + t]) _ext() bottom();


}

assembled();

// !_binding_post_channel();