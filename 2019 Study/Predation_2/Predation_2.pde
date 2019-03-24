ArrayList<Orb> o = new ArrayList<Orb>();
Predator pred;
int window_size = 600;

void setup()  {
  size(1200,600);
  pred = new Predator(width/2,height/2);
}

void draw()  {
  background(90);
  stroke(255);
  
  //spawn predator
  pred.run();
  
  //spawn/remove triangle objects
  for(int i = 0; i < o.size(); i++)  {
    o.get(i).run();
    pred.steer(o.get(i));
    if(keyPressed)  {
      if(key == 'c' || key == 'C')  {
        o.remove(i);
      }
    }
  }
  
  //triangle steer's away from x object
  for(int i = o.size()-1; i > 0; i--)  {
      o.get(i).steer(pred);          
  }
  //remove triangle is eaten
  for(int i = o.size()-1; i > 0; i--)  {
    if (o.get(i).isEaten(pred))  {
        o.remove(i);
      }
  }
  
  for(int j =0; j < o.size(); j++)  {
      if (o.get(j).isEaten(pred))  {
        o.remove(j);
      }
  }
  
}
//******************************************************************************************************************
// Control Methods

void mouseDragged()  {
  
  o.add(new Orb(mouseX, mouseY));
  
}
void keyPressed()  {
  
  for(int i = o.size()-1; i >= 0; i--)  {
  if(keyPressed)  {
      if(key == 's' || key == 'S')  {
        o.get(i).col = 90;
        o.get(i).bool = !o.get(i).bool;
        pred.col = 90;
        pred.bool = !pred.bool;
      }
    }
  }
  
}

//******************************************************************************************************************
// Predator Class

class Predator  {

  PVector pos,vel,acc;
  
  float size = 14;
  float col = 60;
  float max_speed = 5;
  float eat_space = 160;
  
  boolean bool = false;
  
  Predator(float x, float y)  {
    
  pos = new PVector(x,y);
  vel = new PVector();
  acc = new PVector();
    
  }
  
  void display()  {
    noStroke();
    
    noFill();
    if(bool == true) {fill(col,col,col,44);  col = 60; }
    ellipse(pos.x,pos.y,eat_space,eat_space);
    
    fill(200,40,40);
    float theta = vel.heading() + PI/2;
    
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    
    beginShape();   
    vertex(0,-size*1.7);
    vertex(-size,size*1.7);
    vertex(size,size*1.7);
    endShape();
    popMatrix();
    
  }
  
  void update()  {
    
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    
    vel.limit(max_speed);
    
  }
  
  void applyForce(PVector force)  {
    
    force.div(size);
    force.mult(0.8);
    acc.add(force);
    
  }
  
  void steer(Orb o)  {
    
    PVector desired_vel = PVector.sub(o.pos,pos);
    desired_vel.normalize();
    desired_vel.mult(6);
    
    float distance = dist(pos.x,pos.y,o.pos.x,o.pos.y);
    if(distance <= eat_space)  {
      applyForce(desired_vel);
    }
    
  }
  
  float x_off = random(-3000,3000);
  float y_off = random(-3000,3000);
  float x,y,n_x,n_y;
  float dir_val = 5;
  
  void movement()  {
    
    n_x = noise(x_off);
    x = map(n_x,0,1,-dir_val,dir_val);
    x_off += 0.0369;
    
    n_y = noise(y_off);
    y = map(n_y,0,1,-dir_val,dir_val);
    y_off += 0.0369;
    
    PVector new_dir = new PVector(x,y);
    //new_dir.normalize();
    //new_dir.limit(max_acc);
    applyForce(new_dir);
    
    //println(x+"  "+x_off,y_off);
  }
  
  void border()  {
    if(pos.x > width)  {
      pos.x = 0;
    }
    if(pos.x < 0)  {
      pos.x = width;
    }
    if(pos.y > height)  {
      pos.y = 0;
    }
    if(pos.y < 0)  {
      pos.y = height;
    }
  }
  
  void run()  {
    
    display();
    update();
    border();
    movement();
    
  }
  
}

//******************************************************************************************************************
// Orb Class

class Orb  {
  PVector pos,vel,acc;

  boolean bool = false;
  
  float size = 7;
  float col = 60;
  float max_speed = 5;
  float safe_space = 120;
  
  Orb(float x, float y)  {
    
    pos = new PVector(x,y);
    vel = new PVector();
    acc = new PVector();
    
  }

  void display()  {
    noStroke();
    
    noFill();
    if(bool == true) {fill(col,col,col,44);  col = 60; }
    ellipse(pos.x,pos.y,safe_space,safe_space);

    fill(255);
    
    float theta = vel.heading() + PI/2;
    
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    
    beginShape();
    vertex(0,-size*1.4);
    vertex(-size,size*1.4);
    vertex(size,size*1.4);
    endShape();
    popMatrix();
  
  }
  
  void update()  {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    
    vel.limit(max_speed); 
  }
  
  void applyForce(PVector force)  {
    force.div(size);
    force.mult(0.8);
    acc.add(force);

  }

  void steer(Predator o)  {
    PVector desired_vel = PVector.sub(pos,o.pos);
    desired_vel.normalize();
    desired_vel.mult(5);
    
    float distance = dist(pos.x,pos.y,o.pos.x,o.pos.y);
    if(distance <= safe_space)  {
      applyForce(desired_vel);
    }
    
  }
  
    float x_off = random(-5000,5000);
    float y_off = random(-5000,5000);
    float x,y,n_x,n_y;
    float dir_val = 5;
    
  void movement()  {

    
    n_x = noise(x_off);
    x = map(n_x,0,1,-dir_val,dir_val);
    x_off += 0.0369;
    
    n_y = noise(y_off);
    y = map(n_y,0,1,-dir_val,dir_val);
    y_off += 0.0369;
    
    PVector new_dir = new PVector(x,y);
    //new_dir.normalize();
    //new_dir.limit(max_acc);
    applyForce(new_dir);
    
    //println(x+"  "+x_off,y_off);
  }
    
  void border()  {
    if(pos.x > width)  {
      pos.x = 0;
    }
    if(pos.x < 0)  {
      pos.x = width;
    }
    if(pos.y > height)  {
      pos.y = 0;
    }
    if(pos.y < 0)  {
      pos.y = height;
    }
  }  
  
    boolean isEaten(Predator o)  {
    float distance = dist(pos.x,pos.y,o.pos.x,o.pos.y);
    if(distance <= (size + o.size)*2)  {
      println("is Eaten");
      return true;
    } 
    return false;
  }
  
  void run()  {
    display();
    update();
    border();
    movement();
  }
  
}
