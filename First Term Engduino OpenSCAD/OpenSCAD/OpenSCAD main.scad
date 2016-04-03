//3 components to this design :
//   body, USB holder, hinge pole



use <Spiff.scad>;


$fn = 64;
xBase = 95;
yBase = 130;
zBase = 20;
rBase = 3;

xUSB = 16;
yUSB = 12;
zUSB = 7.5;
rLock = 1; 

wUSB_case = 3;
zUSB_case = zUSB+10;

xHinge = 5;
yHinge = (yUSB+wUSB_case)/2;
zHinge = 8;
rHinge = 1.5;

spacing = 1;

text_height = 2;

engduino_height = 20;
rBasePole = 3;
rTopPole = 2;


//modules included in body()
module roundedbase(xdim = xBase, ydim = yBase, zdim = zBase, rdim = rBase){
     difference(){
     cube([xdim, ydim, zdim], false);
     union(){
     // Rounds the vertical edges
     translate([0,0 ,0])cube ([rdim, rdim ,zdim], false);
     translate([xdim-rdim,0,0])cube([rdim, rdim ,zdim], false);
     translate([0,ydim-rdim,0])cube ([rdim, rdim ,zdim], false);
     translate([xdim-rdim,ydim-rdim,0])cube ([rdim, rdim ,zdim], false);      
     translate([2,7/2, zBase - zBase * (3/4)]) cube([5, ydim-7, zBase * (3/4)], false);
     translate([xdim - 7,7/2, zBase - zBase * (3/4)]) cube([5, ydim-7, 20 + zBase * (3/4)], false);     
     }}
     
     difference(){
     union(){
     // Cuts drains into the surface     
     translate([rdim,rdim ,0])cylinder (r=rdim,h=zdim);
     translate([xdim-rdim,rdim,0])cylinder(r=rdim,h=zdim);
     translate([rdim,ydim-rdim,0])cylinder (r=rdim,h=zdim);
     translate([xdim-rdim,ydim-rdim,0])cylinder (r=rdim,h=zdim);   
     translate([2,7/2,-(20 + zBase * (3/4))]) cube([5, ydim-7, 20 + zBase * (3/4)], false);
     translate([xdim - 7,7/2,-(20 + zBase * (3/4))]) cube([5, ydim-7, 20 + zBase * (3/4)], false);
          }
     union(){
     translate([2,7/2, zBase - zBase * (3/4)]) cube([5, ydim-7, zBase * (3/4)], false);
     translate([xdim - 7,7/2, zBase - zBase * (3/4)]) cube([5, ydim-7, 20 + zBase * (3/4)], false);
     }}  
     

}   
module socket(xdim = xUSB+wUSB_case, ydim = yUSB+wUSB_case, zdim = zUSB_case ){
   cube([xdim, ydim, zdim]); 
}
module lock(zdim, rdim){
     rotate( a = [0, 90, -45]){ 
         difference(){
             cylinder(h = zdim, r = rdim);
             translate([-rdim,0,0]) cube([2*rdim, rdim, zdim], false);
        }
    }       
}   
module hinge(xdim = xHinge, ydim = yHinge, zdim = zHinge){
    translate([-xdim,yHinge/2,(zUSB_case)]) cube([xdim, ydim, zdim], false);   
}

module hingePole(zdim = xUSB+wUSB_case+yHinge + 10, rdim = rHinge){
    rotate([0,90,0]) translate([0,0,0]) cylinder(h = zdim, r = rdim);
}


module addText(textHeight, position  , rotation, text) {
  translate(position)
    rotate(a=rotation) {
      linear_extrude(height = textHeight)
      write(text);
    }
}



//module included in USBholder()
module USBsize(xdim = xUSB,ydim = yUSB,zdim = zUSB){
     if( xdim != xUSB || ydim != yUSB || xdim != xUSB ){
          echo("ERROR: Port head is not a USB head. DO NOT RENDER");
     }  
     else{
        cube([xdim,ydim,zdim], false);
     }
}
//ydim extends USBlength + length above lock  to bottom of socket
//due to rotation,
//yUSB_case refenrence to zSocket &
//zUSB_case reference to ySocket
module USB_case(xdim = xUSB + wUSB_case - rLock *2, ydim = yUSB + zUSB_case+zHinge+spacing, zdim = yUSB+wUSB_case,rdim = 1 ){
     difference(){
     cube([xdim, ydim, zdim], false);
     //rounds the vertical edges
     union(){     
     translate([0,0 ,0])cube ([rdim, rdim ,zdim], false);
     translate([xdim-rdim,0,0])cube([rdim, rdim ,zdim], false);
     translate([0,ydim-rdim,0])cube ([rdim, rdim ,zdim], false);
     translate([xdim-rdim,ydim-rdim,0])cube ([rdim, rdim ,zdim], false);             
     }}
     translate([rdim,rdim ,0])cylinder (r=rdim,h=zdim);
     translate([xdim-rdim,rdim,0])cylinder(r=rdim,h=zdim);
     translate([rdim,ydim-rdim,0])cylinder (r=rdim,h=zdim);
     translate([xdim-rdim,ydim-rdim,0])cylinder (r=rdim,h=zdim);
}

module hingeSpace(xdim = xUSB + wUSB_case - rLock *2 ,rdim = rLock + spacing/2){
    rotate([0, 90,0]) hull(){
         translate([-(yUSB+wUSB_case)/2   ,yUSB + rdim + spacing/2 , 0  ]) cylinder(h=xdim, r=rdim);
         translate([-(yUSB+wUSB_case)/2 , yUSB+ zUSB_case + zHinge -rdim - spacing ,0 ]) cylinder(h=xdim, r=rdim);    }
}   







module Renderbody(){ 
     difference(){   
         roundedbase();
         translate([0,35,0]){ 
         translate([ 22, 60, zBase -(zUSB_case) ]) 
         rotate([0,0,45]) {
             socket();
         }
     }
     }
     
     translate([0,35,0]){
     difference(){
         union(){
         translate([ 22, 60, zBase -(zUSB_case) ]) {
         rotate([0,0,45]) {
         hinge();
         translate([xUSB+wUSB_case, 0,0]) mirror([1,0,0]) hinge();
         }}}
         translate([10, 59, zBase+zHinge/2 ]) {
         rotate([0,0,45]) hingePole();
         }
     }
     }

     translate([24,85, zBase - (zUSB_case)/2]) lock(xUSB+wUSB_case, rLock);
     translate([24,58, zBase -(zUSB_case)/2]) rotate([0,0,180]){lock(zUSB_case , rLock);}
     
     addText(text_height, [xBase - 22, yBase - 15,zBase], [0,0,-90], "University");
     addText(text_height, [xBase - 34, yBase - 45,zBase], [0,0,-90], "College");
     addText(text_height, [xBase - 46, yBase - 65,zBase], [0,0,-90], "London");
}
module RenderUSBholder (){
     difference(){
         USB_case();
         union(){
         translate([((xUSB + wUSB_case - rLock *2) - xUSB)/2 , 0, (yUSB+wUSB_case- zUSB)/2]) USBsize();
         hingeSpace();
         }
     }
}

Renderbody();
rotate(a = 90, v= [0,0,1] )translate ([150, -38,0]) RenderUSBholder();
translate ([0,190,0]) hingePole();