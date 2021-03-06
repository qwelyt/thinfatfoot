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

part="full"; //["full","left","right","left and right","other"]
switchType="MX"; //["MX","BOX","square"]

keys=true;
caps=true;
showTop=true;
showPlate=true;
showBottom=true;
partSpaceing=0;

halfSpaceingX=0;
halfSpaceingY=0;

proMicroPosition=position(5,7,3.5);

$fn=50;
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

module saCap(x=cherryCutOutSize/1.36,y=cherryCutOutSize/1.36,z=4,row=1){
  color([0.3,1,0.7])
  translate([x-0.819,y-0.8,z+3.5])
  rotate([0,0,90])
  import(str("SA_1u_r", row , ".stl"));
  
}


module proMicro(type="proMicro"){
  rotate([0,0,90])
  if(type == "cutout"){
    union(){
      translate([0,0,0.9])cube([19,33.7,4], center=true);
      translate([-7.3,0,-1.2])cube([4.5,33.7,2], center=true);
      translate([7.3,0,-1.2])cube([4.5,33.7,2], center=true);
      translate([0,17,2])cube([8,3,3], center=true);
      translate([0,-20,0.5])cube([23,2.7,3],center=true);
    }
  } else if(type == "lid"){
    union(){
      translate([0,-2,2.8])cube([10,34,1],center=true);
      translate([0,-18,1.8])cube([22,2,3],center=true);
    }
  } else if(type == "proMicro") {
    import("pro-micro.stl");
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

module switchCut(type="MX"){
  if(type=="MX"){
    mxSwitchCut();
  } else if(type=="BOX"){
    x=cherryCutOutSize/1.5;
    y=cherryCutOutSize/1.5;
    translate([x,y,0])
    cube([cherryCutOutSize-2,cherryCutOutSize,moduleZ*4],center=true);
  } else if(type=="square"){
    x=cherryCutOutSize/1.5;
    y=cherryCutOutSize/1.5;
    translate([x,y,0])
    cube([cherryCutOutSize,cherryCutOutSize,cherryCutOutSize], center=true);
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
   repeate(yStart,yEnd, xStart, xEnd) switchCut(switchType);
}

module keyHoleWithStabs(yStart, yEnd, xStart, xEnd){
  module stabHole(){
    cube([cherryCutOutSize,3,10],center=true);
  }
  centerSwitch=[cherryCutOutSize/1.5,cherryCutOutSize/1.5,0];
  repeate(yStart,yEnd, xStart, xEnd) {
    translate(centerSwitch)translate([0,-(cherryCutOutSize/1.5-0.495+3),0])stabHole();
    switchCut(switchType);
    translate(centerSwitch)translate([0,cherryCutOutSize/1.5-0.17+3,0])stabHole();
  }
}

module screwPoints(antiTilt=false,which="all"){
  rotation = antiTilt ? [0,-tilt,0] : [0,0,0];
  if(which=="all"){
    // Corners
    translate([6,6,0])rotate(rotation)children();
    translate([6,moduleY-6,0])rotate(rotation)children();
    translate([moduleX-6,6,0])rotate(rotation)children();
    translate([moduleX-6,moduleY-6,0])rotate(rotation)children();
    
    // middle
    translate([6,moduleY/2,0])rotate(rotation)children();
//    translate([6,moduleY/2-space,0])rotate(rotation)children();
//    translate([6,moduleY/2+space,0])rotate(rotation)children();
    
    translate([moduleX-6,moduleY/2,0])rotate(rotation)children();
//    translate([moduleX-6,moduleY/2-space,0])rotate(rotation)children();
//    translate([moduleX-6,moduleY/2+space,0])rotate(rotation)children();
  } else if (which == "lower"){
    translate([moduleX-6,6,0])rotate(rotation)children();
    translate([moduleX-6,moduleY-6,0])rotate(rotation)children();
    
    translate([moduleX-6,moduleY/2,0])rotate(rotation)children();
  } else if (which == "upper") {
    translate([6,6,0])rotate(rotation)children();
    translate([6,moduleY-6,0])rotate(rotation)children();
    
    translate([6,moduleY/2,0])rotate(rotation)children();
  }
}


module mXScrew(m=3,h=20){
  union(){
    cylinder(d=mScrewheadD(m), h=mScrewheadH(m));
    translate([0,0,mScrewheadH(m)])cylinder(d=m, h=h);
  }
}


module plate(part="full"){
  module keyPlacements(){
  keyHoles(1.5,11.5,1.5,4.5);
    
    keyHoles(1.5,1.5,5.5,5.5);
    keyHoleWithStabs(5,5,5.5,5.5);

    keyHoles(6.5,6.5,5.5,5.5);
    keyHoleWithStabs(8,8,5.5,5.5);
    
    keyHoles(11.5,11.5,5.5,5.5);
}

  module fullPlate(){
    difference(){
      cube([moduleX, moduleY, moduleZ]);
      keyPlacements();
      screwPoints(true)translate([0,0,-1])cylinder(d=mSize+0.5,h=moduleZ+2);
    }
  }

  module halfPlate(plus=true){
    difference(){
      union(){
        cube([moduleX, moduleY/2-space/2, moduleZ]);
        if(plus){
          cube([moduleX/2+space/2, moduleY/2+space/2, moduleZ]);
          cube([moduleX/2+space/2, moduleY/2+space/2+2, moduleZ/2]);
        } else {
          cube([moduleX/2-space/2, moduleY/2+space/2, moduleZ]);
          cube([moduleX/2-space/2, moduleY/2+space/2+2, moduleZ/2]);
        }
      }
      if(plus){
        translate([moduleX/2+space/2,moduleY/2-(space/2+2),-1])
        cube([moduleX/2-space/2+1,2+1,moduleZ/2+1]);
      } else {
        translate([moduleX/2-space/2,moduleY/2-(space/2+2),-1])
        cube([moduleX/2+space/2+1,2+1,moduleZ/2+1]);
      }
    }
  }

  module leftPlate(){
    difference(){
      halfPlate(true);
      keyPlacements();
      screwPoints(true)translate([0,0,-1])cylinder(d=mSize+0.5,h=moduleZ+2);
    }
  }
  module rightPlate(){
    difference(){
      translate([moduleX,moduleY,0])rotate([0,0,180])halfPlate(false);
      keyPlacements();
      screwPoints(true)translate([0,0,-1])cylinder(d=mSize+0.5,h=moduleZ+2);
    }
  }
  
  
//  {
////    fullPlate();
//    color([0.4,0.7,0.9])leftPlate();
////    translate([space, space, 0])
////    translate([3,0.5,0])
//    translate([halfSpaceingX,halfSpaceingY,0])
//    color([0.9,0.7,0.4])rightPlate();
//  
//  }
  if(keys){
    repeate(1.5,11.5,1.5,4.5)cherrySwitch();
    
    repeate(1.5,1.5,5.5,5.5)cherrySwitch();
    repeate(5,5,5.5,5.5)cherrySwitch();
    repeate(6.5,6.5,5.5,5.5)cherrySwitch();
    repeate(8,8,5.5,5.5)cherrySwitch();
    
    repeate(11.5,11.5,5.5,5.5)cherrySwitch();
  }
  if(caps){
//    repeate(1.5,9.5,1.5,4.5)cherryCap();
    for(row=[1:4]){
      repeate(1.5,9.5,row+0.5,row+0.5)saCap(row=row);
    }
    
    repeate(1.5,11.5,1.5,4.5)cherryCap();
    
    repeate(1.5,1.5,5.5,5.5)cherryCap();
    repeate(5,5,5.5,5.5)cherryCap(capSize=2);
    repeate(6.5,6.5,5.5,5.5)cherryCap();
    repeate(8,8,5.5,5.5)cherryCap(capSize=2);
    
    repeate(11.5,11.5,5.5,5.5)cherryCap();
  }
  if(part=="full"){
    fullPlate();
  } else if(part=="left") {
    leftPlate();
  } else if(part=="right") {
    rightPlate();
  } else if(part=="left and right") {
    translate([-halfSpaceingX,-halfSpaceingY,0])
    leftPlate();
    
    translate([halfSpaceingX,halfSpaceingY,0])
    rightPlate();
  }
}

module top(part="full"){
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
  
  module fullTop(){
    difference(){
      union(){
        difference(){
          union(){
            difference(){
              cube([moduleX+edgeSpace*1.3, moduleY+edgeSpace, topZ]);
              translate([edgeSpace*1-1,edgeSpace-1,-1])cube([moduleX-edgeSpace+2, moduleY-edgeSpace+2, topZ+2]);
              
            }
            translate([0,0,-keyZ]){
              repeate(3.035, 3.1, 6.035, 6.1)cube([space,space,topZ]);
              repeate(3.035, 3.1, 6.9, 6.9)cube([space,space,topZ]);
              
              repeate(3.95, 4.1, 6.035, 6.1)cube([space,space,topZ]);
              repeate(3.95, 4.1, 6.9, 6.9)cube([space,space,topZ]);
              
              repeate(10.05, 10.05, 6.035, 6.1)cube([space,space,topZ]);
              repeate(10.05, 10.05, 6.9, 6.9)cube([space,space,topZ]);
              
              repeate(10.965, 11.3, 6.035, 6.1)cube([space,space,topZ]);
              repeate(10.965, 11.3, 6.9, 6.9)cube([space,space,topZ]);
            }
          }
          translate([edgeSpace/2,edgeSpace/2,-1])cube([moduleX, moduleY, moduleZ*3.7]);
          
          translate([moduleX+edgeSpace*0.7,0,0])roundier();
          translate([edgeSpace*0.55,0,20])rotate([0,180,0])roundier();
        }
      }
    
      translate([0,7.45,29])rotate([180,0,0])rounder();  
      translate([0,moduleY+edgeSpace*2-10,12.55])rotate([90,0,0])rounder();
      
      translate([edgeSpace/2, edgeSpace/2,9])screwPoints(true)cylinder(d=mSize,h=moduleZ*2);
    }
  }
  
  module halfTop(plus=true){
    difference(){
      union(){
        difference(){
          union(){
            cube([moduleX+edgeSpace*1.3, (moduleY+edgeSpace)/2-edgeSpace*0.7, topZ]);
            translate([moduleX,0,0])cube([30, (moduleY+edgeSpace)/2+edgeSpace*0.7, topZ]);
          }
          
          if(plus){
            translate([edgeSpace*1-1,edgeSpace-1,-1])cube([moduleX-edgeSpace+2, moduleY-edgeSpace+2, topZ+2]);
          } else {
            translate([edgeSpace*1.576-1,edgeSpace-1,-1])cube([moduleX-edgeSpace+2, moduleY-edgeSpace+2, topZ+2]);
          }
        }
        translate([0,0,-keyZ]){
          if(plus){
            repeate(3.035, 3.1, 6.035, 6.1)cube([space,space,topZ]);
            repeate(3.035, 3.1, 6.9, 6.9)cube([space,space,topZ]);
            
            repeate(3.95, 4.1, 6.035, 6.1)cube([space,space,topZ]);
            repeate(3.95, 4.1, 6.9, 6.9)cube([space,space,topZ]);
            
            translate([0, (moduleY+edgeSpace)/2-edgeSpace*0.7,3]){
              cube([20,20,10.09]);
              translate([5.52,0,10])cube([4,20,3]);
            }
          } else {
            row=1.64;
            repeate(3.035, 3.1, row+0.035, row+0.1)cube([space,space,topZ]);
            repeate(3.035, 3.1, row+0.9, row+0.9)cube([space,space,topZ]);
            
            repeate(3.95, 4.1, row+0.035, row+0.1)cube([space,space,topZ]);
            repeate(3.95, 4.1, row+0.9, row+0.9)cube([space,space,topZ]);
            
            translate([1, (moduleY+edgeSpace)/2-edgeSpace*0.7,3]){
              cube([20,20,10.09]);
              translate([10,0,10])cube([4,20,3]);
            }
          }
        }
      }
      translate([0,7.45,29])rotate([180,0,0])rounder();
      if(plus){
        translate([edgeSpace/2,edgeSpace/2,-1])cube([moduleX, moduleY, moduleZ*3.7]);
        translate([moduleX+edgeSpace*0.7,0,0])roundier();
        translate([edgeSpace*0.55,0,20])rotate([0,180,0])roundier();
        
        translate([edgeSpace/2, edgeSpace/2,9])screwPoints(true)cylinder(d=mSize,h=moduleZ*2);
        
        translate([moduleX+7, ((moduleY+edgeSpace)/2-edgeSpace*0.7)+6.6,-1]){
          cube([21,21,11.1]);
          translate([7.5,0,11])cube([5,21,3.5]);
        }
      } else {
        translate([edgeSpace+1.42,edgeSpace/2,-1])cube([moduleX, moduleY, moduleZ*3.7]);
        translate([moduleX+edgeSpace*1.025,0,0])roundier();
        translate([edgeSpace*0.875,0,20])rotate([0,180,0])roundier();
        
        translate([moduleX+edgeSpace*1.07,moduleY+edgeSpace/2,9])rotate([0,0,180])screwPoints(true)cylinder(d=mSize,h=moduleZ*2);
        
        translate([moduleX+edgeSpace, ((moduleY+edgeSpace)/2-edgeSpace*0.7)+6.6,-1]){
          cube([21,21,11.1]);
          translate([1,0,10.5])cube([5,20.3,4]);
        }
      }
      
    }
  }
  
  
  module leftTop(){
    difference(){
      halfTop(true);
//      translate([moduleX+5,5,0])cube([10,20,40],center=true);
    }
  }
  module rightTop(){
    translate([moduleX+(edgeSpace*1.6),moduleY+edgeSpace,0])rotate([0,0,180])halfTop(false);
  }
  
//  translate([-moduleY,0,0])
//  color([0.5,0.6,0.7]) fullTop();
  
//  color([0.7,0.6,0.5]) leftTop();
//  
//  translate([halfSpaceingX-0.465,halfSpaceingY,0])
//  color([0.7,0.5,0.6]) rightTop();
  
  if(part=="full"){
    fullTop();
  } else if(part=="left") {
    leftTop();
  } else if(part=="right") {
    rightTop();
  } else if(part=="left and right") {
    translate([-halfSpaceingX,-halfSpaceingY,0])
    leftTop();
    
    translate([halfSpaceingX,halfSpaceingY,0])
    rightTop();
  }
  
}



module bottom(part="full"){
  module screwHole(inset=7.5){
    union(){
     translate([0,0,-1])cylinder(d=mScrewheadD(mSize+1.2),h=inset);
     translate([0,0,3])cylinder(d=mSize+0.5,h=20);
    }
  }
  module cordParth(l=50){
    rotate([0,-90,0]){
      cylinder(d=4,h=l,center=true);
      translate([-2,0,0])cube([4,4,l],center=true);
    }
  }
  
  module cordLips(left=true){
    if(left){
      translate([-65,-92,-3])cube([6,3,1],center=true);
      
      translate([-53,-70,-3])cube([3,6,1],center=true);
      translate([-53,-30,-3])cube([3,6,1],center=true);
    } else {
      translate([-63,2,-3])cube([6,3,1],center=true);
      translate([-48,2,-3])cube([6,3,1],center=true);
      translate([-65,92,-3])cube([6,3,1],center=true);
      
      translate([-53,70,-3])cube([3,6,1],center=true);
      translate([-53,30,-3])cube([3,6,1],center=true);
    }
  }
  
  module pmCutOut(){
    proMicro("cutout");
    translate([-30,0,-moduleZ-1]){
      difference(){
        scale([1.5,1,1])rotate([0,0,45])cylinder(moduleZ*2,14,10.8,$fn=4);
        translate([17,0,moduleZ])cube([10,20,moduleZ*2],center=true);
      }
      translate([10.5,0,moduleZ])cube([3,15.5,moduleZ*2],center=true);
    }
    translate([-55,0,-2])cordParth();
    translate([-55,0,-2])rotate([0,0,90])cordParth(moduleY*0.805);
    

    
    translate([-80,90,-2])cordParth();
    translate([-80,-90,-2])cordParth();
  }
  
  module house(h=8,wb=14,wt=10,t=1.8){
    difference(){
      scale([t,1,1])rotate([0,0,45])cylinder(h,wb,wt,$fn=4);
      translate([3,0,-2])scale([t+0.2,0.9,1])rotate([0,0,45])cylinder(h,wb,wt,$fn=4);
      translate([wb*1.26,0,h/2])cube([wb,wb*1.5,h+1],center=true);
    }
    translate([-wb/5,-wb*0.97,1])cube([wb*(t+0.12),10,2],center=true);
    translate([-wb/5,wb*0.97,1])cube([wb*(t+0.12),10,2],center=true);
    translate([-wb-6,0,1])cube([10,wb*(t+0.856),2],center=true);
  }
  
  module fullBottom(){
    difference(){
      cube([moduleX,moduleY, moduleZ*10]);
      translate([-10,-10,moduleZ*8])rotate([0,tilt,0])cube([moduleX*1.3,moduleY*1.3, moduleZ*11]);
      translate([edgeSpace/2,edgeSpace/2,5])cube([moduleX-edgeSpace,moduleY-edgeSpace, moduleZ*6]);
      
      screwPoints()screwHole();
      
  //    translate([30,30,0])cube([10,10,10]);
      translate(proMicroPosition){
        pmCutOut();
      }
      translate(proMicroPosition){
        translate([-29, 0,0]){
          scale([1.02,1.02,1.02])house();
          house();
        }
      }
    }
//    translate(proMicroPosition){
//      translate([-29, 0,0])
//      house(h=8,wb=14,wt=10);
//    }
    translate(proMicroPosition){
      cordLips(false);
      cordLips(true);
    }
  }
  module halfBottom(plus=true){
    lip=9;
    mov=0.052;
    difference(){
      union(){
        cube([moduleX,moduleY/2-space/3.2, moduleZ*10]);
        if(plus){
          
          translate([moduleX/2,0,0])cube([moduleX/2,moduleY/2+space/3.2, moduleZ*10]);
          translate([moduleX/(2-mov+0.0025),0,0])cube([moduleX/(2+mov),moduleY/2+space/3.2+lip, 2]);
        } else {
          translate([moduleX/2,0,0])cube([moduleX/2,moduleY/2+space/3.2, moduleZ*10]);
          translate([moduleX/1.42,0,0])cube([moduleX/3.38099,moduleY/2+space/3.2+lip, 2]);
        }
      }
      if(plus){
        translate([-1,moduleY/2-space/3.2-lip,-1])cube([moduleX/3.38099+1,moduleY/2+space/3.2+lip, 3]);
      } else {
        translate([-1,moduleY/2-space/3.2-lip,-1])cube([moduleX/(2+mov)+1,moduleY/2+space/3.2+lip, 3]);
      }
    }
    
  }
  module leftBottom(){
    difference(){
      halfBottom(true);
      screwPoints(which="upper")screwHole(inset=11.5);
      screwPoints(which="lower")screwHole();
      
      translate([-10,-10,moduleZ*8])rotate([0,tilt,0])cube([moduleX*1.3,moduleY*1.3, moduleZ*11]);
      translate([edgeSpace/2,edgeSpace/2,5])cube([moduleX-edgeSpace,moduleY-edgeSpace, moduleZ*6]);
      
      translate(proMicroPosition){
        pmCutOut();
        translate([-29, 0,0]){
          scale([1.02,1.02,1.02])house();
          house();
        }
      }
//      cube([10,10,40],center=true);
//      translate([moduleX,0,0])cube([10,10,40],center=true);
      
    }
//    #translate([0,0,8])screwPoints(which="upper")mXScrew();  
//    #translate([0,0,4.5])screwPoints(which="lower")mXScrew(h=10);  
    translate(proMicroPosition)cordLips(true);
  }
  module rightBottom(){
    difference(){
      translate([moduleX,moduleY,0])rotate([0,0,180])halfBottom(false);
//      screwPoints()screwHole();
      screwPoints(which="upper")screwHole(inset=11.5);
      screwPoints(which="lower")screwHole();
      
      translate([-10,-10,moduleZ*8])rotate([0,tilt,0])cube([moduleX*1.3,moduleY*1.3, moduleZ*11]);
      translate([edgeSpace/2,edgeSpace/2,5])cube([moduleX-edgeSpace,moduleY-edgeSpace, moduleZ*6]);
      
      translate(proMicroPosition){
        pmCutOut();
        translate([-29, 0,0]){
          scale([1.02,1.02,1.02])house();
          house();
        }
      }
    }
//    #screwPoints()mXScrew();  
    translate(proMicroPosition)cordLips(false);
  }
  
  
//  translate([-moduleX*2,0,0])color([1,0,1])fullBottom();
//  color([0,1,1])leftBottom();
//  translate([halfSpaceingX,halfSpaceingY,0])
//  color([1,1,0])rightBottom();
//  
//  translate(proMicroPosition){
//    translate([-29, 0,0]){
//      scale([1.02,1.02,1.02])house();
//      house();
//    }
//  }
//  
////  house();
////  translate([33,0,0])proMicro();
//  
//  
//  
//  translate(proMicroPosition){
//    color([1,1,0])proMicro();
//    color([0.1,1,0.4])translate([2,0,0])proMicro("lid");
//  }
  
  if(part=="full"){
    fullBottom();
  } else if(part=="left") {
    leftBottom();
  } else if(part=="right") {
    rightBottom();
  } else if(part=="left and right") {
    translate([-halfSpaceingX,-halfSpaceingY,0])
    leftBottom();
    
    translate([halfSpaceingX,halfSpaceingY,0])
    rightBottom();
  } else if(part == "other") {
    proMicro("lid");
    translate([0,30,0])house();
  }
}


module keyboard(){
  translate([10,10,25]){
//    rotate([0,0,0]){
    rotate([0,tilt,0]){
      if(showTop){
        translate([0,0,partSpaceing])
        translate([-edgeSpace/2,-edgeSpace/2,-(topZ/3)])
        color([1,0.3,0.3])
        top(part);
      }
      if(showPlate){
        color([0.6,0.6,0.3])
        plate(part);
      }
    }
    if(showBottom){
      translate([0,0,-partSpaceing])
      translate([0,0,-23])
      color([0.3,0.5,1])
      bottom(part);
    }
  }
}
//
//
////!mXScrew(m=3,h=20);
keyboard();
if(showPrintBox){
//  translate([0,space/2,0])
  #cube(printerSize);
}