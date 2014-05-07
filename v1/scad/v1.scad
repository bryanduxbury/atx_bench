use <external_parts.scad>

// material thickness
t = 3;

// measure
atx_psu_depth = 140;

w = 150 + 2 * t;
h = 100;
// room for electronics in the front
d = atx_psu_depth + 150;

module _ext() {
  color([.9,.9,.9, .5])
  linear_extrude(height=t, center=true) child(0);
}

module bottom() {
  square(size=[w, d], center=true);
}

module top() {
  
}

module face() {
  square(size=[w, h], center=true);
}

module back() {
  square(size=[w, h], center=true);
}

module side() {
  square(size=[d, h], center=true);
}

module assembled() {
  translate([0, d/2 - t - t/2, -h/2 + 86/2+t + t/2]) rotate([0, 0, 180]) _atx_psu();
  
  
  
  translate([-w/2 + 2 * t + 98/2, -d/2 + t + t/2, h/2 - 2 * t - 60/2]) rotate([90, 0, 0]) _lcd();

  for (x=[-1,1]) {
    translate([x * (w/2 - t/2), 0, 0]) 
    rotate([90, 0, 90]) _ext() side();
  }
  
  translate([0, d/2 - t, 0]) rotate([90, 0, 0]) _ext() back();
  translate([0, -d/2 + t, 0]) rotate([90, 0, 0]) _ext() face();
  
  translate([0, 0, -h/2 + t]) _ext() bottom();
}

assembled();