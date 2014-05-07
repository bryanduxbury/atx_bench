
module _atx_psu(depth=140) {
  color("silver")
  translate([0, depth/2, 0]) 
  cube(size=[150, depth, 86], center=true);

  color("black")
  translate([-138/2+114, 0, -43 + 6 + 17.5]) 
  cube(size=[29, 15, 23], center=true);

  color("black")
  translate([-138/2+114, 0, -43 + 6 + 38.5]) 
  cube(size=[15, 15, 10], center=true);

  // no spec for voltage switch height, width
  color("black")
  for (xy=[[6, 16], [6, 80], [120, 6], [144, 80]]) {
    translate([-150/2 + xy[0], 0, -86/2 + xy[1]]) 
      rotate([90, 0, 0]) cylinder(r=(0.1372 * 25.4) / 2, h=10, center=true, $fn=36);
  }

  // Fan positioning is a definite swag! Can't find a spec that makes it standard.
  color("black")
  translate([-75 + 6 + 6 + 40, 0, 0]) 
  rotate([90, 0, 0]) intersection() {
    cylinder(r=45, h=1, center=true);
    cube(size=[80, 80, 1], center=true);
  }
  
  color("silver")
  translate([0, depth + 6, -86/2+0.5]) 
  for (x = [-1,1]) {
    translate([x * (75 - 20), 0, 0]) 
    difference() {
      cube(size=[20, 20, 1], center=true);
      rotate([0, 0, 0]) cylinder(r=2, h=10, center=true);
    }
  }
}

// TODO: model all the parts of the plug!
module _barrel_jack() {
  cylinder(r=6, h=10, center=true);
}

module _lcd() {
  color("grey")
  translate([0, 0, -9.9/2]) 
    cube(size=[97, 39.5, 9.9], center=true);

  color("blue")
    cube(size=[76, 26, 1], center=true);

  color("green")
  translate([0, 0, -9.9-1.6/2])
  difference() {
    cube(size=[98, 60, 1.6], center=true);
    for (x = [-1,1], y = [-1, 1]) {
      translate([93/2 * x, 55 / 2 * y, 0]) 
        cylinder(r=1.5, h=2, center=true, $fn=36);
    }
  }

  color("grey")
  translate([0, 0, -14 + 2]) 
    cube(size=[97, 39.5, 4], center=true);

}

module _standoff(dia, height) {
  // TODO
}

module _rotary_encoder() {
  // TODO
}

// _lcd();

_atx_psu();