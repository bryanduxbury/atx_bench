use <./arduino.scad>

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
module _binding_post(col = "black") {
  assign(total_h = 34)
  assign(external_post_h = 12.4 + 1 + 7.3 + 1) 
  assign(screw_len = total_h - external_post_h)
  {
    color(col)
    translate([0, 0, external_post_h / 2]) 
    cylinder(r=12.3/2, h=external_post_h, center=true);

    color("silver")
    translate([0, 0, -screw_len/2])
    cylinder(r=5/32 * 25.4 / 2, h=screw_len, center=true, $fn=36);
  }
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
  color("black")
  translate([0, 0, -5])
  cube(size=[12.5, 13.2, 10], center=true);

  color("gray") {
    translate([0, 0, 2.5])
    cylinder(r=7/2, h=5, center=true, $fn=36);
  
    translate([0, 0, 5 + 5]) 
    difference() {
      cylinder(r=6/2, h=10, center=true, $fn=36);
      translate([0, 3, 5]) 
      cube(size=[10, 3, 14], center=true);
    }
  }
}

module _frontend_pcba() {
  translate([0, 0, 1.6/2]) 
  color("green")
  difference() {
    cube(size=[100, 50, 1.6], center=true);
    for (x=[-1,1],y=[-1,1]) {
      translate([x * (50 - 2.5), y * (25 - 2.5), 0]) {
        cylinder(r=3.1/2, h=10, center=true, $fn=12);
      }
    }
  }
  
  color("gray")
  for (x=[-1,1]) {
    translate([x * 23, -11.5, 38.1/2 + 1.6]) {
      cube(size=[41.6, 25, 38.1], center=true);
    }
  }
  
}

module _mainboard_pcba() {
  translate([450/1000*25.4, 0, 0]) {
    translate([0, 0, 1.6/2]) 
    color("green")
    difference() {
      cube(size=[100, 80, 1.6], center=true);
      for (x=[-1,1],y=[-1,1]) {
        translate([x * (50 - 2.5), y * (40 - 2.5), 0]) {
          cylinder(r=3.1/2, h=10, center=true, $fn=12);
        }
      }
    }
  
    color("white")
    translate([50 - 11, 0, 15/2 + 1.6]) {
      cube(size=[22, 52, 15], center=true);
    } 
  
    color("gray")
    for (x=[-1,1]) {
      translate([12.5 + x * 12.5, 40 - 5, 15/2+1.6]) {
        cube(size=[20, 10, 15], center=true);
      }
    }
  }

  translate([-50, -40 + 2100/1000 * 25.4, 15]) 
  rotate([180, 0, 0])
    translate([600 / 1000 * 25.4, 2 * 25.4, 0])  
      Arduino(false, false, false);
}

module _80mm_fan() {
  color("black") {
    difference() {
      cube(size=[80, 80, 25], center=true);
      for (x=[-1,1],y=[-1,1]) {
        translate([x * 71.5/2, y * 71.5/2, 0]) 
        cylinder(r=4.4/2, h=30, center=true, $fn=36);
      }
    
      intersection() {
        cylinder(r=85/2, h=26, center=true);
        cube(size=[76, 76, 30], center=true);
      }
    }
  
    cylinder(r=12, h=20, center=true);
  }
  
  color("gray")
  for (a=[0:8]) {
    rotate([0, 0, a * 360/9]) 
    translate([0, 17.5, 0]) rotate([0, 30, 0]) cube(size=[2, 35, 20], center=true);
  }
  
}

// _lcd();
// _atx_psu();
// _binding_post();
// _frontend_pcba();
// _mainboard_pcba();
// _rotary_encoder();
_80mm_fan();