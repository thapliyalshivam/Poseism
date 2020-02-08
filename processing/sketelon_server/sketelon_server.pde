import SimpleOpenNI.*;
SimpleOpenNI kinect;


//config
int width = 1920;
int height = 1080;

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
float scaler_bias = 1.0;
int shoulder_width = 1;
int i = 0;
float width_bias = 1.0;
int theme_mode = 0;


class ImageClass{
  String imgurl;
  PImage img;
  int posX;
  int posY;
  float scale;
  float scale_sensitivity;
  float rot_sensitivity;
  int rotate;
  int pos_off;
  
  ImageClass(String imgurl, int posX, int posY, float scale, int rotate, float scale_sensitivity, float rot_sensitivity, int pos_off){
  this.imgurl=imgurl;
  this.img = loadImage(base+imgurl);
  this.scale_sensitivity = scale_sensitivity;
  this.rot_sensitivity= rot_sensitivity;
  this.posX=posX;
  this.posY=posY;
  this.pos_off=pos_off;
  this.scale=scale;
  this.rotate=rotate;
  }
  
  void draw(){
  translate(this.posX+450, this.posY+450);
  scale(this.scale+(scaler_L_X*this.scale_sensitivity)); 
  rotate(radians(this.rotate+scaler_R_Y*this.rot_sensitivity));
  image(this.img,this.posX-450+(scaler_L_Y*pos_off),this.posY-450+(scaler_R_X*pos_off));
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
 f = createFont("Futura",16,true);
 textFont(f,180); 
themes = new ArrayList<Theme>();
  
ArrayList<ImageClass> imagelist1;
imagelist1 = new ArrayList<ImageClass>();
//imagelist1.add(new ImageClass("theme_1/a1.png",400,0,0.5,45, 0.2,20,100));
imagelist1.add(new ImageClass("theme_1/a2.png",250,20,0.8,0, -0.2,30,90));
imagelist1.add(new ImageClass("theme_1/a3.png",500,10,0.9,0, 0.2,-30,40));
imagelist1.add(new ImageClass("theme_1/a4.png",650,150,0.6,0, 0.2,30,-100));
imagelist1.add(new ImageClass("theme_1/a5.png",250,100,1,0, -0.2,30,-60));
imagelist1.add(new ImageClass("theme_1/a6.png",0,0,0.89,0, -0.2,-30,40));
themes.add(new Theme(imagelist1,"Motionism"));

ArrayList<ImageClass> imagelist2;
imagelist2 = new ArrayList<ImageClass>();

imagelist2.add(new ImageClass("theme_1/a1.png",400,40,0.2,45, 0.2,20,100));
themes.add(new Theme(imagelist2,"sads"));


 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// this change
 size(1920, 1080);
 fill(0, 0, 0);
 
}

void draw() {
 background(116,193,217);
for(i=0;i<themes.get(theme_mode).imglist.size();++i)
{
themes.get(theme_mode).imglist.get(i).draw();
}
 
fill( 255, 255, 255);
 text("Poseism",550,570);
  
  
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
  shoulder_width = (int)sqrt((x.x*x.y)+(y.x+y.y));
  width_bias = shoulder_width/scaler_bias;
} 



void skeletonData(int userId) {
R_confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, R_H_joint);
L_confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, L_H_joint);
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

scaler_L_X = (L_hand.x - L_shoulder.x)/width_bias;
scaler_L_Y = (L_hand.y - L_shoulder.y)/width_bias;
scaler_R_X = (R_hand.x - R_shoulder.x)/width_bias;
scaler_R_Y = (R_hand.y - R_shoulder.y)/width_bias;
 
 

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
