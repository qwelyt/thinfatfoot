space=19.04;
edgeSpace=space;

cherryCutOutSize=14;
cherrySize=14.58;

keySpace=space-cherrySize;

function size(q) = (keySpace*q)
                        +cherrySize
                        *(q-1)
                        +cherrySize;
                        
keyCols=6;
keyRows=12;
moduleX = size(keyCols);
moduleY = size(keyRows);
moduleZ = 3;
topZ=20;

keys=true;
caps=true;
showTop=true;
showPlate=true;
showBottom=true;

$fn=30;
$fs=0.15;

mSize=3;

keyX = cherrySize;
keyY = cherrySize;
keyZ = moduleZ;

keySize = [keyX, keyY, moduleZ+2];
tilt=7;


/*[ Printer settings ]*/
showPrintBox=false;
printerSize=[140,140,140];

// mX: h=mX-1, d= X*(1+((1/3)*2))
function mNutH(m) = m-1;
function mNutD(m) = m*(1+((1/3)*2));
function mNutDHole(m) = mNutD(m)+2;
function mScrewheadH(m) = m-1;
function mScrewheadD(m) = m+2; // This is most probably not correct, but works for m3

          
function position(x,y,z) = [space*(x-1), space*(y-1), z];


module cherrySwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([cherryCutOutSize/1.5,cherryCutOutSize/1.5,13.32])
  rotate([0,0,90])
  color([1,0.6,0.3])
		import("switch_mx.stl");
}
module cherryCap(x=cherryCutOutSize/1.36,y=cherryCutOutSize/1.36,z=4, capSize=1, homing=false,rotateCap=false){
	// Awesome caps created by rsheldiii
	// Lib: KeyV2: Parametric Mechanical Keycap Library
	// Download here: https://www.thingiverse.com/thing:2783650

  capRotation = rotateCap ? 0 : 90;

  color([0.3,1,0.7])
	if(capSize == 1){
		translate([x-0.819,y-0.8,z+3.5])rotate([0,0,capRotation]){
      if(homing){
        rotate([0,0,180])import("keycap-dsa-1.0-row3-homing-cherry.stl");
      } else {
        import("keycap-dsa-1.0-row3-cherry.stl");
      }
    }
  } else if(capSize==2){
		translate([x-0.819,y-0.8,z+3.5])
    rotate([0,0,capRotation])
			import("keycap-dsa-2.0-row3-cherry.stl");
	}
}


module mxSwitchCut(x=cherryCutOutSize/1.5,y=cherryCutOutSize/1.5,z=0,rotateCap=false){
  capRotation = rotateCap ? 0 : 90;
  d=14.05;
  p=14.58/2+0.3;
  translate([x,y,z]){
    translate([0,0,-3.7])
    rotate([0,0,capRotation]){
      difference(){
        cube([d,d,10], center=true);
        translate([d*0.5,0,0])cube([1,4,12],center=true);
        translate([-d*0.5,0,0])cube([1,4,12],center=true);
      }


      translate([0,-(p-0.6),1.8]) rotate([-10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,-(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);

      translate([0,(p-0.6),1.8]) rotate([10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);
    }
  }
}

module repeate(yStart, yEnd, xStart, xEnd){
  for(y = [yStart:yEnd]){
    for(x = [xStart:xEnd]){
      translate(position(x,y,keyZ)) children();
    }
  }
}

module keyHoles (yStart, yEnd, xStart, xEnd){
   repeate(yStart,yEnd, xStart, xEnd) mxSwitchCut();
}

module screwPoints(antiTilt=false){
  rotation = antiTilt ? [0,-tilt,0] : [0,0,0];
  translate([6,6,0])rotate(rotation)children();
  translate([6,moduleY-6,0])rotate(rotation)children();
  translate([moduleX-6,6,0])rotate(rotation)children();
  translate([moduleX-6,moduleY-6,0])rotate(rotation)children();
}


module plate(){
  difference(){
    color([0.4,0.7,0.9])cube([moduleX, moduleY, moduleZ]);
    keyHoles(1.5,11.5,1.5,4.5);
    
    keyHoles(1.5,1.5,5.5,5.5);
    keyHoles(5,5,5.5,5.5);
    keyHoles(6.5,6.5,5.5,5.5);
    keyHoles(8,8,5.5,5.5);
    
    keyHoles(11.5,11.5,5.5,5.5);
    
    
    screwPoints(true)cylinder(d=mSize,h=moduleZ+2);
    
  }
  
  if(keys){
    repeate(1.5,11.5,1.5,4.5)cherrySwitch();
    
    repeate(1.5,1.5,5.5,5.5)cherrySwitch();
    repeate(5,5,5.5,5.5)cherrySwitch();
    repeate(6.5,6.5,5.5,5.5)cherrySwitch();
    repeate(8,8,5.5,5.5)cherrySwitch();
    
    repeate(11.5,11.5,5.5,5.5)cherrySwitch();
  }
  if(caps){
    repeate(1.5,9.5,1.5,4.5)cherryCap();
    
//    repeate(1.5,11.5,1.5,4.5)cherryCap();
    
    repeate(1.5,1.5,5.5,5.5)cherryCap();
    repeate(5,5,5.5,5.5)cherryCap(capSize=2);
    repeate(6.5,6.5,5.5,5.5)cherryCap();
    repeate(8,8,5.5,5.5)cherryCap(capSize=2);
    
//    repeate(11.5,11.5,5.5,5.5)cherryCap();
  }
}

module top(){
  module rounder(){
    translate([0,0,16.5])
    rotate([0,90,0])
    union(){
      translate([0,0,-edgeSpace])
      difference(){
        translate([0,0,0])cube([10,10,moduleX+edgeSpace*2.5]);
        translate([0,0,-1])cylinder(h=moduleX+edgeSpace*2.5+2, d=15);
      }
    }
  }
  module roundier(){
    union(){
      difference(){
        translate([0,-1,-1])cube([20,moduleY+edgeSpace+2,22]);
        translate([0,-2,10])rotate([-90,0,0])cylinder(h=moduleY+edgeSpace+4, d=21);
      }
    }
  }
  
  difference(){
    union(){
      difference(){
        union(){
          difference(){
            cube([moduleX+edgeSpace*1.3, moduleY+edgeSpace, topZ]);
            translate([edgeSpace*1-1,edgeSpace-1,-1])cube([moduleX-edgeSpace+2, moduleY-edgeSpace+2, topZ+2]);
            
          }
          translate([0,0,-keyZ]){
            repeate(3.1, 3.1, 6.1, 6.1)cube([space,space,topZ]);
            repeate(3.1, 3.1, 6.9, 6.9)cube([space,space,topZ]);
            
            repeate(3.95, 4.1, 6.1, 6.1)cube([space,space,topZ]);
            repeate(3.95, 4.1, 6.9, 6.9)cube([space,space,topZ]);
            
            repeate(10.05, 10.05, 6.1, 6.1)cube([space,space,topZ]);
            repeate(10.05, 10.05, 6.9, 6.9)cube([space,space,topZ]);
            
            repeate(10.9, 10.9, 6.1, 6.1)cube([space,space,topZ]);
            repeate(10.9, 10.9, 6.9, 6.9)cube([space,space,topZ]);
          }
        }
        translate([edgeSpace/2,edgeSpace/2,-1])cube([moduleX, moduleY, moduleZ*3.7]);
        
        translate([moduleX+edgeSpace*0.7,0,0])roundier();
        translate([edgeSpace*0.55,0,20])rotate([0,180,0])roundier();
      }
    }
  
    translate([0,7.45,29])rotate([180,0,0])rounder();  
    translate([0,moduleY+edgeSpace*2-10,12.55])rotate([90,0,0])rounder();
    
    translate([edgeSpace/2, edgeSpace/2,9])screwPoints(true)cylinder(d=mSize,h=moduleZ*3);
  }
}

module bottom(){
  module screwHole(){
    union(){
     translate([0,0,-1])cylinder(d=mNutDHole(mSize+1),h=6,$fn=6);
     translate([0,0,4])cylinder(d=mSize,h=20);
    }
  }
  
  difference(){
    cube([moduleX,moduleY, moduleZ*10]);
    translate([-10,-10,moduleZ*8])rotate([0,tilt,0])cube([moduleX*1.3,moduleY*1.3, moduleZ*11]);
    translate([edgeSpace/2,edgeSpace/2,5])cube([moduleX-edgeSpace,moduleY-edgeSpace, moduleZ*6]);
    
    screwPoints()screwHole();
  }
}

module keyboard(){
  translate([10,10,0]){
//    rotate([0,0,0]){
    rotate([0,tilt,0]){
      if(showPlate){
        plate();
      }
      if(showTop){
        translate([-edgeSpace/2,-edgeSpace/2,-(topZ/3)])color([0.5,0.6,0.7])top();
      }
    }
    if(showBottom){
      color([1,0,1])translate([0,0,-23])bottom();
    }
  }
}


keyboard();
//#cube([140,140,140]);