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

$fn=30;
$fs=0.15;

mSize=3;

keyX = cherrySize;
keyY = cherrySize;
keyZ = moduleZ;

keySize = [keyX, keyY, moduleZ+2];


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


module plate(){
  difference(){
    cube([moduleX, moduleY, moduleZ]);
    keyHoles(1.5,11.5,1.5,4.5);
    
    keyHoles(1.5,1.5,5.5,5.5);
    keyHoles(5,5,5.5,5.5);
    keyHoles(6.5,6.5,5.5,5.5);
    keyHoles(8,8,5.5,5.5);
    
    keyHoles(11.5,11.5,5.5,5.5);
  }
}

module top(){
  difference(){
    cube([moduleX+edgeSpace, moduleY+edgeSpace, topZ]);
    translate([edgeSpace/2,edgeSpace/2,-1])cube([moduleX, moduleY, topZ+2]);
  }
  translate([0,0,-keyZ]){
    repeate(3.1, 3.1, 6.1, 6.1)cube([space,space,topZ]);
    repeate(4.1, 4.1, 6.1, 6.1)cube([space,space,topZ]);
    repeate(3.1, 3.1, 6.9, 6.9)cube([space,space,topZ]);
    repeate(4.1, 4.1, 6.9, 6.9)cube([space,space,topZ]);
    
    repeate(9.9, 9.9, 6.1, 6.1)cube([space,space,topZ]);
    repeate(10.9, 10.9, 6.1, 6.1)cube([space,space,topZ]);
    repeate(9.9, 9.9, 6.9, 6.9)cube([space,space,topZ]);
    repeate(10.9, 10.9, 6.9, 6.9)cube([space,space,topZ]);
  }
  
  
}

plate();
translate([-edgeSpace/2,-edgeSpace/2,-(topZ/3)])top();
//#cube([140,140,140]);