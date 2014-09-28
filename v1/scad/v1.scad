// TODO:
// - figure out the binding post configuration

use <external_parts.scad>

// material thickness
t = 3;



// measure
atx_psu_depth = 140;

jog_wheel_radius = 35/2;

w = 150 + 2 * t;
h = 125;
// room for electronics in the front
d = atx_psu_depth + 150;

binding_post_spacing = (w - 2 * t) / 8;



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
  rotate([90, 0, 0]) _ext() jog_wheel_front();
  translate([0, t, 0]) rotate([90, 0, 0]) _ext() jog_wheel_back();
}

module assembled() {
  translate([0, d/2 - t - t/2, -h/2 + 86/2+t + t/2]) 
    rotate([0, 0, 180]) _atx_psu();
  translate([-w/2 + 2 * t + 98/2, -d/2 + t + t/2, h/2 - 2 * t - 60/2]) 
    rotate([90, 0, 0]) _lcd();

  translate([-3.5 * binding_post_spacing, -d/2 + t/2, -h/2 + t + t + 12.3/2]) 
  for (x=[0:7]) {
    translate([x * binding_post_spacing, 0, 0]) 
      rotate([90, 0, 0]) _binding_post();
  }

  translate([3.5 * binding_post_spacing, -d/2 + t/2, -h/2 + t + t + 12.3/2 + 10 + 12.3/2]) 
  for (x=[-1:0]) {
    translate([x * binding_post_spacing, 0, 0]) 
      rotate([90, 0, 0]) _binding_post();
  }

  for (x=[-1,1]) {
    translate([x * (w/2 - t/2), 0, 0]) 
    rotate([90, 0, 90]) _ext() side();
  }
  
  translate([0, d/2 - t, 0]) rotate([90, 0, 0]) _ext() back();
  translate([0, -d/2 + t, 0]) rotate([90, 0, 0]) _ext() face();
  
  translate([0, 0, -h/2 + t]) _ext() bottom();
  
  translate([w/2 - (w - 2 * t - 98) / 2, -d/2 - t * 2, h/2 - 2 * t - 60/2]) _jog_wheel_assembly();
}

assembled();