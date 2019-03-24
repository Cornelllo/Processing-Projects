ArrayList<Blob> blob = new ArrayList<Blob>();
float score = 0;
void setup()  {
  size(900,500);
  //frameRate(10);
  
}

void draw()  {
  background(90);
  
  for(int i = 0; i < blob.size(); i++)  {
    
    blob.get(i).run();
    float size = blob.get(0).coll_size;
    //Changes color of orb when mouse is hovered
    float d = dist(mouseX,mouseY,blob.get(0).pos.x,blob.get(0).pos.y);
    blob.get(0).col = 105;
    if(d <= blob.get(0).coll_size -(blob.get(0).coll_size/2))  {
      blob.get(0).col = 255; 
      
      score += 0.8;
      //if goal is reached reset score  
      if(score >= height-20){
        score = 0;
        blob.get(0).coll_size = size -20;
      }
    }
    //gameover
    else  {
      blob.get(0).col = 150;
      score=0;
    }

  }
  
  for(int i = 0; i < blob.size(); i++)  {
    for(int j = blob.size()-1; j > 0; j--)  {
      if( blob.get(i) != blob.get(j) ){
        blob.get(i).collide(blob.get(j));
      }
    }
  }
  
  //game progress bar
  noStroke();
  fill(20,20,200);
  rect(20,height-20,20,-score);
  println(score);
  
}

void mousePressed(){
  blob.add(new Blob(mouseX,mouseY));
  println("X coordinate: "+mouseX+"   Y coordinate: "+mouseY);
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
   
  }
//********************************************************************************************

class Blob  {
  PVector pos,vel,acc;
  float size = 7;
  float coll_size =170;
  float max_speed = 5;
  boolean bool = false;
  float col = 150;
  Blob(float x,float y)  { 
    
      pos = new PVector(x,y);
      acc = new PVector(random(-5,5),0);
      vel = new PVector();
  }
  
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
  
  float drag = -0.27;
  void physics()  {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    vel.limit(max_speed);
    applyForce(new PVector(0,1));
    //bouncyness
    float elasticity = -100;

    if(pos.y >= height-coll_size/2)  {
      applyForce(new PVector(0,drag-drag));
      acc.y *= elasticity;
      pos.y = height-coll_size/2;
    }
  
    if(pos.x >= width-coll_size/2)  {
      applyForce(new PVector(drag*-1,0));
      acc.x *= -100;
      pos.x = width-coll_size/2;
    }
    
    if(pos.x <= 0 + coll_size/2)  {
      applyForce(new PVector(drag,0));
      acc.x *= -100;
      pos.x = 0 +coll_size/2;
    }

  }
  
  void applyForce(PVector force)  {
    force.div(size);
    force.mult(0.4);
    acc.add(force); 
    
  }
  
  void collide(Blob b)  {
    PVector d_vel = PVector.sub(pos, b.pos);
    d_vel.normalize();
    d_vel.mult(25);

    float distance = dist(pos.x,pos.y,b.pos.x,b.pos.y);
    if(distance <= coll_size)  {
      applyForce(d_vel);
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
    physics();
    //border();
  }
  
 
}
