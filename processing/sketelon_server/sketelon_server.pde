import SimpleOpenNI.*;
SimpleOpenNI kinect;


//config
int width = 1000;
int height = 1000;
int theme_mode = 0;
PFont f;  
String base = "../../visuals/";
ArrayList<Theme> themes;

PVector R_H_joint = new PVector();
PVector L_H_joint = new PVector();
PVector R_S_joint = new PVector();
PVector L_S_joint = new PVector();
PVector R_hand = new PVector();
PVector L_hand = new PVector();
PVector R_shoulder = new PVector();
PVector L_shoulder = new PVector();
float R_confidence;
float L_confidence;
float scaler_L_X = 0.0;
float scaler_L_Y = 0.0;
float scaler_R_X = 0.0;
float scaler_R_Y = 0.0;
int Width = 1;

class ImageClass{
  String imgurl;
  PImage img;
  int posX;
  int posY;
  float scale;
  int rotate;
  ImageClass(String imgurl, int posX, int posY, float scale, int rotate){
  this.imgurl=imgurl;
  this.img = loadImage(base+imgurl);
  this.posX=posX;
  this.posY=posY;
  this.scale=scale;
  this.rotate=rotate;
  }
  
  void draw(float off_x){
  scale(this.scale); 
  rotate(radians(this.rotate));
  image(this.img,this.posX+off_x,this.posY);
  resetMatrix();

  }
}

class Theme{
  ArrayList<ImageClass> imglist;
  String name;  
  Theme(ArrayList<ImageClass> imglist, String name){
  this.imglist= imglist;
  this.name = name;
  }
}

void setup() {
 f = createFont("Arial",16,true);
   textFont(f,200); 
themes = new ArrayList<Theme>();
  
ArrayList<ImageClass> imagelist1;
imagelist1 = new ArrayList<ImageClass>();
imagelist1.add(new ImageClass("theme_1/a1.png",200,200,0.1,45));
imagelist1.add(new ImageClass("theme_1/a2.png",0,0,1,0));
themes.add(new Theme(imagelist1,"sads"));

ArrayList<ImageClass> imagelist2;
imagelist2 = new ArrayList<ImageClass>();
imagelist2.add(new ImageClass("theme_1/a1.png",0,0,1,0));
imagelist2.add(new ImageClass("theme_1/a2.png",0,0,1,0));
themes.add(new Theme(imagelist2,"sads"));


 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// this change
 size(1000, 1000);
 fill(0, 0, 0);
 
}

void draw() {
 background(255);
themes.get(0).imglist.get(1).draw(R_hand.x);
themes.get(0).imglist.get(0).draw(R_hand.y);
text(
scaler_L_X+",\n "+
scaler_L_Y+",\n "+
scaler_R_X+",\n "+
scaler_R_Y+",\n "
,10,200);  
  kinect.update();
  //image(kinect.depthImage(), 0, 0);
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
  int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
    skeletonData(userId);
    }
  }
}




void calcWidth(PVector x, PVector y){
  width = (int)sqrt((x.x*x.y)+(y.x+y.y));

} 



void skeletonData(int userId) {
R_confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, R_H_joint);
L_confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, L_H_joint);
 kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, R_S_joint);
kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, L_S_joint);
if(L_confidence < 0.5 && R_confidence < 0.5 ){
   return;
 }
 kinect.convertRealWorldToProjective(R_H_joint, R_hand);
 kinect.convertRealWorldToProjective(L_H_joint, L_hand);
 kinect.convertRealWorldToProjective(R_S_joint, R_shoulder);
 kinect.convertRealWorldToProjective(L_S_joint, L_shoulder);
 

 calcWidth(L_shoulder,R_shoulder);

scaler_L_X = (L_hand.x - L_shoulder.x)/width;
scaler_L_Y = (L_hand.x - L_shoulder.x)/width;
scaler_R_X = (R_hand.x - R_shoulder.x)/width;
scaler_R_Y = (R_hand.y - R_shoulder.y)/width;
 
 

}



void drawSkeleton(int userId) {
 stroke(0);
 strokeWeight(5);

 kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

 noStroke();

 fill(255,0,0);
 drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint(int userId, int jointID) {
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
