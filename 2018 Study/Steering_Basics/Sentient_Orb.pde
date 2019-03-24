class Orb {
  PVector loc,vel,acc;
  float radius,lifespan,mass,col;
  
  Orb(PVector l, PVector v) {
    loc = l.copy ();
    vel = v.copy();
    acc = new PVector(random(-2,2),random(-2,2));
    float r = random(15,30);
    col = 255;
    mass = r/2;
    radius = r;
  }
  
  void attract(Orb b) {
  PVector orb = b.loc.copy();
  PVector direction = PVector.sub(orb,loc);
  direction.normalize();
  direction.limit(1);
  applyForce(direction);
  }
  void repel(Orb b) {
  PVector force = PVector.sub(b.loc.copy(),loc);
  float fV = force.mag();
  float distance = dist(b.loc.x,b.loc.y,this.loc.x,this.loc.y);
  float total_radii = b.radius + radius;
     print("\nDistance: "+distance+"\nCombined Radii: "+total_radii);
  if(/*distance + 20 <= total_radii + total_radii/2 ||*/ fV <= total_radii * 1.5){
    //float f_correction = (total_radii - distance)/2.0;
    
    if(distance < total_radii){
      col = 70;
    }else {
      col = 255;
    }
    print("\n---------------------------Collided at distance : "+distance);
    PVector final_f = force.copy();
    final_f.normalize();  
    final_f.mult(-5);
    final_f.limit(1);
    applyForce(final_f);
    }
  }
  void applyForce(PVector force){
    PVector f = force.copy();
    f.div(mass);
    acc.add(f);
  }
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0.2);  
  }
  void border() {
    if(loc.x > width){
      vel.x *= -0.9;
      loc.x = width;
    }
    if(loc.x < 0){
      vel.x *= -0.9;
      loc.x = 0;
    }
    if(loc.y > height){
      vel.y *= -0.9;
      loc.y = height;
    }
    if(loc.y < 0){
      vel.y *= -0.9;
      loc.y = 0;
    }
  }
  void display() {
    noStroke();
    fill(col);
    ellipse(loc.x,loc.y,radius,radius);
  }
  void run() {
        PVector dir = PVector.sub(new PVector(width/2,height/2),loc);
        dir.normalize();
        dir.mult(0.5);
        //dir.div(mass);
        applyForce(dir);
    display();
    border();
    update();
  }
}
