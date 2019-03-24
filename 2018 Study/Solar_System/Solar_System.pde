import java.util.*;
ArrayList<Object> movers = new ArrayList<Object>();
ArrayList<Object> movers2 = new ArrayList<Object>();
Repeller inverse;
float t = 0,t1 = 200,t2 = 400;
float flow = 0.75;

void setup() {
  size(900,600); 
  frameRate(60);
}
float s,v,v1;
void mousePressed(){ 
  float size = noise(t);
  float velocityX = noise(t1);
  float velocityY = noise(t2);
   s = map(size,0,1,5,25);
   v = map(velocityX,0,1,-10,10);
   v1 = map(velocityY,0,1,-10,20);
  t += flow;
  t1 += flow;
  t2 += flow;
  int x = 12;
  for(int i = 0; i < 2; i++){
  movers.add(new Object(new PVector(mouseX,mouseY), s, new PVector(random(-x,x),random(-x,x)) )); 
  }
    inverse = new Repeller(mouseX,mouseY);
}
float ts;
void draw() { 
  background (0);
  float size = noise(ts);
  ts = map(size,0,1,5,25);
  t += flow;
  
  if(movers.size() > 50) {
    movers.remove(0);
  }
  if(movers2.size() > 50) {
    movers2.remove(0);
  }
  
  Iterator<Object> it = movers.iterator();
  while(it.hasNext()){
    Object b = (Object) it.next();
    b.run();
    b.applyForce(new PVector(0,random(0,0.3)));
    b.sun(inverse);
    if(b.spawn()) {
      movers2.add(new Object(new PVector(b.location.x,b.location.y), ts, new PVector(random(-3,3),random(-3,3)) ));
      runA();
      
    }
    inverse.display();
    //b.applyRepel(inverse);
    if(b.isGone()){
      it.remove();
      }
  }
  //----
  Iterator<Object> it2 = movers2.iterator();
  while(it2.hasNext()){
    Object a = (Object) it2.next();
    a.run();
    a.applyForce(new PVector(0,random(0,0.3)));
    a.sun(inverse);
     if(a.spawn()) {
      movers.add(new Object(new PVector(a.location.x,a.location.y), ts, new PVector(random(-3,3),random(-3,3)) ));
      runB();
    }
     if(a.isGone()){
      it2.remove();
      }
  }
  print("A: "+movers.size()+"  "+"B: "+movers2.size()+"\n");
}
void runA(){
  Iterator<Object> it = movers.iterator();
  while(it.hasNext()){
    Object b = (Object) it.next();
    b.run();
    b.applyForce(new PVector(0,random(0,0.3)));
    b.sun(inverse);
    if(b.spawn()) {
      movers2.add(new Object(new PVector(b.location.x,b.location.y), ts, new PVector(random(-3,3),random(-3,3)) ));
    }
    inverse.display();
    //b.applyRepel(inverse);
    if(b.isGone()){
      it.remove();
      }
  }
}
void runB() {
Iterator<Object> it2 = movers2.iterator();
  while(it2.hasNext()){
    Object a = (Object) it2.next();
    a.run();
    a.applyForce(new PVector(0,random(0,0.3)));
    a.sun(inverse);
     if(a.spawn()) {
      movers.add(new Object(new PVector(a.location.x,a.location.y), ts, new PVector(random(-3,3),random(-3,3)) ));
      //runA();
    }
     if(a.isGone()){
      it2.remove();
      }
  }
}

//------------------------------------------------------------

class Repeller {

float locX,locY;

  Repeller(float x,float y){
    locX = x;
    locY = y;
  }
  void repel(PVector f) {
    //Vector force = f.copy();
  }
  float angle;
  void display() {
    noStroke();
    fill(255);
    ellipse(locX,locY,10,10);
  }
}

//------------------------------------------------------------

class Object {
  
PVector location,velocity,acceleration,f;
float lifespan,size,mass = 2.2;
float r,g,b;

  Object(PVector l, float size, PVector v){
    acceleration = new PVector(0,0);
    velocity = v.copy();
    location = l.copy();
    this.size = size;
    lifespan = 500.0;
    r = random(0,255);
    g = random(0,255);
    b = random(0,255);
  }
  void run(){
    display();
    update();
  }
  boolean spawn() {
    float chance = (int)random(1000);
//print("---->"+chance);
    if(chance == 5.0){
    return true;
    }else 
    return false;
  }
  void sun(Repeller r) {
    PVector sun = new PVector(r.locX,r.locY);
    PVector dir = PVector.sub(sun,location);
    //[end]
    // Normalize.
    dir.normalize();
    // Scale.
    dir.mult(0.3);
    // Set to acceleration.
    applyForce(dir);
  }
  void applyForce(PVector f1){
    f = f1.copy();
    f.div(mass);
    acceleration.add(f);
  }
  void applyRepel(Repeller r) {
   // PVector f2 =r.repel(f);
    //applyForce(f2);
  }
  void display(){
    noStroke();
    fill(r,g,b);
    ellipse(location.x-2,location.y-2,size,size); 
  }
  void update(){
    velocity.add(acceleration);
    location.add(velocity); 
    acceleration.mult(0.2);
    lifespan -= 1.5;
    //bounce();
    
  }
  void bounce() {
    if(location.y > height-size){
      velocity.y *= -0.86;
      location.y = height-size;
    }
    if(location.y < 0+size){
      velocity.y *= -0.86;
      location.y = 0+size;
    }
    if(location.x > width-size){
      velocity.x *= -0.86;
      location.x = width-size;
    }
    if(location.x < 0+size){
      velocity.x *= -0.86;
      location.x = 0+size;
    }
  }
  boolean isGone(){
    if(lifespan == 0 /*|| location.x > width || location.y > height || location.x < 0 || location.y < 0*/){
      return true;
    }else{
      return false;
    }
  }
  
}
