ArrayList<Blob> blob = new ArrayList<Blob>();
float score = 0;
float x_time = 500;
float y_time = -500;

void setup()  {
  size(900,500);
  noCursor();
  //frameRate(10); 
}

void draw()  {
  background(90);
  
  //display and run simulation/game
  for(int i = 0; i < blob.size(); i++)  {
    blob.get(i).run();
    float size = blob.get(i).coll_size;
    float d = dist(mouseX,mouseY,blob.get(i).pos.x,blob.get(i).pos.y);
    //Changes color of orb when mouse is hovered
    blob.get(i).col = 105;
    
    if(d >= blob.get(i).coll_size -(blob.get(i).coll_size/2))  {
      blob.get(i).col = 255; 
      
      score += 0.06;
      //if goal is reached reset score  
      if(score >= height-20){
        //reset score bar
        score = 0;
        //increase orb size an add one more orb
        for(int j = blob.size()-1; j > 0;  j--)  {
          blob.get(j).coll_size = size + 20;
          }
        blob.add(new Blob(random(0,width),random(0,height)));
      }
    }
    //gameover
    else  {
      blob.get(i).col = 0;
      score = 0;
    }

  }
  
  //blob bounce when colliding with other blob
  for(int i = 0; i < blob.size(); i++)  {
    for(int j = blob.size()-1; j > 0; j--)  {
      //if( blob.get(i) != blob.get(j) ){
        blob.get(i).collide(blob.get(j));
      //}
    }
  }
  
  //game progress bar
  noStroke();
  fill(20,20,200);
  rect(20,height-20,20,-score);
  
  // moveing cirle for score multiplier using perlin noise
  x_time += 0.004;
  y_time += 0.004;
  fill(230,180,109,100);
  ellipse(randomX(),randomY(),90,90);
  
  float d = dist(mouseX,mouseY,randomX(),randomY());
  if(d <= 50){
    score += 2;
    /* might be useful for other game idea
    x_time = random(500);
    y_time = random(500);
    */
  }
    
  //visual for mouse location
  fill(200,30,30);
  ellipse(mouseX,mouseY,10,10);
  
}

//*************************************************************************************
// perlin noise coordinates
float randomX(){
  float x_off,x;
  x_off = noise(x_time);
  x = map(x_off,0,1,20,width-20);
  
  return x;
}
float randomY(){
  float y_off,y;
  y_off = noise(y_time);
  y = map(y_off,0,1,20,height-20);
  
  return y;
}
//***********************************************************************************
//mouse and keyboard functions
void mousePressed(){
  for(int i = 0; i < 2; i++){
  blob.add(new Blob(mouseX,mouseY));
  println("X coordinate: "+mouseX+"   Y coordinate: "+mouseY);
  }
}

void keyPressed()  {
   if(key == 's' || key == 'S')  {
      println("Array size of Blob : "+blob.size());
      for(int i = blob.size()-1; i >= 0;  i--)  {
        blob.get(i).bool = !(blob.get(i).bool);
        println(blob.get(i).bool);
        }
    }
   if(key == 'x' || key =='X') {
     if(blob.size() > 1){
      println("Blob Array is cleared.");
      for(int i = blob.size()-1; i >= 0;  i--)  {
        blob.remove(i);
        }
     }
   }
   if(key == 'h' || key =='H') {
      println("HARD MODE");
      for(int i = blob.size()-1; i >= 0;  i--)  {
        blob.get(i).difficulty = !blob.get(i).difficulty;
      }
   }
   
  }
  
//********************************************************************************************
//Orb class

class Blob  {
  PVector pos,vel,acc;
  
  float size = 7;
  float coll_size = 50;
  float max_speed = 8;
  float col = 0;
  
  boolean bool = false;
  boolean difficulty = false;
  
  Blob(float x,float y)  { 
    
      pos = new PVector(x,y);
      acc = new PVector();
      vel = new PVector(random(-max_speed,max_speed),0);
  }
  //for debugging
  void displayGuide()  {

  //green line    
    stroke(30,220,30);
    line(mouseX,mouseY,pos.x,pos.y);
    
    float theta = vel.heading() + PI/2;
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    
//    draw line
    stroke(220,30,30);
    beginShape();
    vertex(0,-50);
    vertex(0,50);
    endShape();
    
//    draw triangle
    fill(255,255,255,200);
    noStroke();
    beginShape();
    vertex(0,-size*1.4);
    vertex(-size,size*1.4);
    vertex(size,size*1.4);
    endShape();
    
    popMatrix();
  }
  
  void display()  {
    if(bool == true)  {
    displayGuide();
    }
  // draw circle
    stroke(170);
    fill(col,col,col,60);   
    ellipse(pos.x,pos.y,coll_size,coll_size);
        
  }
  
  void update()  {
    
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    vel.limit(max_speed);

  }
  
  void applyForce(PVector force)  {
    force.div(size);
    force.mult(0.4);
    acc.add(force); 
    
  }
  
  void collide(Blob b)  {
    PVector d_vel = PVector.sub(pos, b.pos);
    d_vel.normalize();
    d_vel.mult(20);

    float distance = dist(pos.x,pos.y,b.pos.x,b.pos.y);
    if(distance <= coll_size)  {
      applyForce(d_vel);
    }
        
  }
  
  float drag = -0.27;
  void physics()  {
    //gravity
    applyForce(new PVector(0,1));
    
    //bouncyness
    float elasticity = -100;

    if(pos.y >= height-coll_size/2)  {
      applyForce(new PVector(0,drag-drag));
      acc.y *= elasticity * 0.4;
      pos.y = height-coll_size/2;
    }
  
    if(pos.x >= width-coll_size/2)  {
      applyForce(new PVector(drag*-1,0));
      acc.x *= -100 * max_speed/3;
      pos.x = width-coll_size/2;
    }
    
    if(pos.x <= 0 + coll_size/2)  {
      applyForce(new PVector(drag,0));
      acc.x *= -100 * max_speed/3;
      pos.x = 0 +coll_size/2;
    }
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
    //changes orb behavior on walls
    if(difficulty == true)
      border();
    else 
      physics();
     }
     
  }
