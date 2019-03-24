class Vehicle {
  PVector loc,vel,acc,d_vel;
  float life,radius,mass;
  float angle,vVel,vAcc;
  float maxspeed = 10;
  float maxforce = 1.3;
  
  Vehicle(PVector l) {
    loc = l.copy();
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    mass = random(15,35);
  }
//-----------------------
  void steer(PVector target) {
    PVector desired_vel = PVector.sub(target,loc);
    float distance = desired_vel.mag(); 
    desired_vel.normalize(); 
    if(distance < 100){
      float n = map(distance,0,100,0,maxspeed);
      desired_vel.mult(n);
    }else {
      desired_vel.mult(maxspeed);
    }
    
    PVector steer = PVector.sub(desired_vel,vel);
    steer.limit(maxforce);
    
    applyForce(steer);
  }
  void applyForce(PVector force) {
    force.div(mass);
    acc.add(force);
  }  
  void display(){
    angle = vel.heading();
    fill(175);
    stroke(0);
    pushMatrix();
    rectMode(CENTER);
    translate(loc.x,loc.y);
    rotate(angle);
    rect(0,0,mass*2,mass);
    popMatrix();
  }
  void update() {
    vel.add(acc);
    vel.limit(maxspeed);
    loc.add(vel);
    acc.mult(0.8);
  }
  void run(){
    display();
    update();
    applyForce(new PVector(0,0.4));
  }

//---------------------
}
int size = 5;
Vehicle v;
ArrayList<Orb> o = new ArrayList<Orb>();
void setup() {
  size(600,600);
  v = new Vehicle(new PVector(0,0));
  for(int i = 0; i < size; i++){
  o.add( new Orb(new PVector(random(1,width),random(1,height)),new PVector (-1,1)) );
  }
}

void draw() {
  background(0);
  
  for(int i = 0; i < o.size(); i++){    
    for(int j = 0; j < o.size(); j++) {
      if(i != j) {
        o.get(i).repel(o.get(j));
      }
    }
    o.get(i).run();
    v.run();
    v.steer(o.get(i).loc);   
  }
}
