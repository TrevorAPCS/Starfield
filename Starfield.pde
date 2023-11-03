Particle[] particles;
Particle[] thrusters;
int dpX = 250;
int dpY = 400;
int pX = dpX;
int pY = dpY;
boolean right = false;
boolean left = false;
boolean up = false;
boolean down = false;
int health = 100;
int sHealth = 100;
int shieldTimer = 0;
boolean menu = true;
int difficulty = 2;
Button easy;
Button medium;
Button hard;
Button start;
int stars = 100;
int asteroids = 5;
int powerUps = 2;
int eHScore = 0;
int mHScore = 0;
int hHScore = 0;
int score;
int sT = 0;

void setup(){
  size(500, 500);
  easy = new Button(90, 350, 65, 50, "Easy");
  medium = new Button(160, 350, 65, 50, "Medium");
  hard = new Button(230, 350, 65, 50, "Hard");
  start = new Button(300, 350, 110, 50, "Start");
}
void draw(){
  background(0);
  if(menu){
    fill(150);
    rect(50, 50, 400, 400);
    fill(0);
    textSize(35);
    textAlign(CENTER);
    text("Dodge the Asteroids!", 250, 100);
    if(difficulty == 1){
      text("Difficulty: Easy", 250, 300);
    }
    else if(difficulty == 2){
      text("Difficulty: Medium", 250, 300);
    }
    else if(difficulty == 3){
      text("Difficulty: Hard", 250, 300);
    }
    textSize(15);
    text("Easy High score: " + eHScore, 250, 175);
    text("Medium High score: " + mHScore, 250, 210);
    text("Hard High score: " + hHScore, 250, 245);
    easy.show();
    medium.show();
    hard.show();
    start.show();
    if(difficulty == 1){
      asteroids = 3;
      powerUps = 2;
    }
    else if(difficulty == 2){
      asteroids = 5;
      powerUps = 2;
    }
    else if(difficulty == 3){
      asteroids = 5;
      powerUps = 1;
    }
  }
  else{
    for(int i = 0; i < particles.length; i++){
      particles[i].move();
      particles[i].show();
      if(particles[i].x > 530 || particles[i].x < -30 || particles[i].y > 530 || particles[i].y < -30){
        particles[i].reInitialize(250, 150);
      }
    }
    if(left && dpX > 30){
      dpX -= 5;
    }
    if(right && dpX < 470){
      dpX += 5;
    }
    pX = dpX + (int)(Math.random()*3) - 1;
    pY = dpY + (int)(Math.random()*3) - 1;
    fill(50);
    drawShip(pX, pY);
    checkCollision();
    fill(150);
    rect(0, 0, sHealth, 20);
    fill(0, 255, 0);
    rect(0, 0, health, 20);
    if(health == 0){
      if(difficulty == 1){
        if(score > eHScore){
          eHScore = score;
        }
      }
      else if(difficulty == 2){
        if(score > mHScore){
          mHScore = score;
        }
      }
      else if(difficulty == 3){
        if(score > hHScore){
          hHScore = score;
        }
      }
      menu = true;
    }
    for(int i = 0; i < thrusters.length; i++){
      thrusters[i].move();
      thrusters[i].show();
      if((thrusters[i].x > 530 || thrusters[i].x < -30 || thrusters[i].y > 530 || thrusters[i].y < -30)){
        thrusters[i].reInitialize(thrusters[i].originalX + pX - 250, thrusters[i].originalY, (Math.random() * 2 + 1) * PI / 4, (Math.random() * 20) + 5);
        if(health < 50){
          thrusters[i].myOpacity = 500;
          thrusters[i].myColor = 50;
        }
      }
    }
    if(shieldTimer > 0){
      shieldTimer--;
      fill(150);
      rect(400, 0, 100, 25);
      fill(0, 0, 255);
      rect(400, 0, shieldTimer / 5, 25);
    }
    if((int)(millis()/100) > sT){
      score++;
      sT = (int)(millis() / 100);
    }
    fill(255);
    textAlign(CENTER);
    text("Score: " + score, 255, 10);
  }
}
void keyPressed(){
  if(keyCode == LEFT){
    left = true;
  }
  if(keyCode == RIGHT){
   right = true;
  }
}
void keyReleased(){
  if(keyCode == LEFT){
    left = false;
  }
  if(keyCode == RIGHT){
   right = false;
  }
}
void checkCollision(){
  for(int i = 0; i < particles.length; i++){
    if(particles[i] instanceof Asteroid){
      if(particles[i].x - (particles[i].size / 2) <= pX + 25 && particles[i].x + (particles[i].size / 2) >= pX - 25 && particles[i].y - (particles[i].size / 2) <= pY + 20 && particles[i].y + (particles[i].size / 2) >= pY - 30){
        if(particles[i].crashable){
          if(shieldTimer == 0){
            fill(100, 0, 0);
            health -= 10;
          }
          particles[i].reInitialize(250, 150);
        }
      }
    }
    if(particles[i] instanceof PowerUp){
      if(particles[i].x - (particles[i].size / 2) <= pX + 25 && particles[i].x + (particles[i].size / 2) >= pX - 25 && particles[i].y - (particles[i].size / 2) <= pY + 20 && particles[i].y + (particles[i].size / 2) >= pY - 30){
        if(particles[i].crashable){
          if(((PowerUp)particles[i]).type == 0){
            shieldTimer = 500;
            particles[i].reInitialize(250, 150);
          }
          if(((PowerUp)particles[i]).type == 1){
            if(health < sHealth - 20){
              health += 20;
            }
            else{
              health = sHealth;
            }
            particles[i].reInitialize(250, 150);
          }
        }
      }
    }
  }
}
void mousePressed(){
  if(menu){
    if(easy.checkClick()){
      difficulty = 1;
    }
    if(medium.checkClick()){
      difficulty = 2;
    }
    if(hard.checkClick()){
      difficulty = 3;
    }
    if(start.checkClick()){
      score = 0;
      sT = (int)(millis() / 100);
      pX = 255;
      initializeArrays();
      health = sHealth;
      menu = false;
    }
  }
}
void drawShip(int pX, int pY){
  stroke(150);
    beginShape();
    vertex(pX - 22, pY);
    vertex(pX - 27, pY + 20);
    vertex(pX + 27, pY + 20);
    vertex(pX + 22, pY);
    vertex(pX - 22, pY);
    endShape();
    beginShape();
    vertex(pX - 22, pY);
    vertex(pX - 20, pY - 20);
    vertex(pX + 20, pY - 20);
    vertex(pX + 22, pY);
    vertex(pX - 22, pY);
    endShape();
    line(pX - 20, pY - 25, pX - 22, pY - 30);
    line(pX + 20, pY - 25, pX + 22, pY - 30);
    fill(0, 0, 100);
    beginShape();
    vertex(pX - 22, pY - 30);
    vertex(pX - 20, pY - 20);
    vertex(pX + 20, pY - 20);
    vertex(pX + 22, pY - 30);
    vertex(pX - 22, pY - 30);
    endShape();
    beginShape();
    vertex(pX - 22, pY - 30);
    vertex(pX - 20, pY - 25);
    vertex(pX - 22, pY);
    vertex(pX - 25, pY + 10);
    vertex(pX - 22, pY - 30);
    endShape();
    beginShape();
    vertex(pX + 22, pY - 30);
    vertex(pX + 20, pY - 25);
    vertex(pX + 22, pY);
    vertex(pX + 25, pY + 10);
    vertex(pX + 22, pY - 30);
    endShape();
    fill(255, 0, 0);
    fill(100);
    ellipse(pX - 12, pY + 10, 10, 10);
    ellipse(pX + 12, pY + 10, 10, 10);
    if(shieldTimer > 0){
      fill(0, 0, 255, 100);
      ellipse(pX, pY - 10, 60, 60);
    }
}
void initializeArrays(){
  particles = new Particle[asteroids + stars + powerUps];
  thrusters = new Particle[50];
  for(int i = 0; i < stars; i++){
    particles[i] = new Particle(250, 150, (Math.random() * 5) + 3, Math.random() * 2 * Math.PI, (Math.random() * 4) + 1);
  }
  for(int i = stars; i < stars + asteroids; i++){
    particles[i] = new Asteroid(250, 150, (Math.random() * 5) + 3, ((Math.random() * 2 + 1) * PI) / 4, (Math.random() * 3) + 1);
  }
  for(int i = asteroids + stars; i < stars + asteroids + powerUps; i++){
    particles[i] = new PowerUp(250, 150, (Math.random() * 5) + 3, ((Math.random() * 2 + 1) * PI) / 4, (Math.random() * 3) + 1);
  }
  for(int i = 0; i < thrusters.length / 2; i++){
    thrusters[i] = new Particle(pX - 12, pY + 10, (Math.random() * 20) + 5, (Math.random() * 2 + 1) * PI / 4, (Math.random() * 3) + 2, 150, (int)(Math.random() * 100) + 60);
  }
  for(int i = thrusters.length/2; i < thrusters.length; i++){
    thrusters[i] = new Particle(pX + 12, pY + 10, (Math.random() * 20) + 5, (Math.random() * 2 + 1) * PI / 4, (Math.random() * 3) + 2, 150, (int)(Math.random() * 100) + 60);
  }
}
class Particle{
  double angle, speed, x, y, size, defaultSize;
  int myColor;
  int myOpacity;
  boolean crashable;
  boolean hasOpacity;
  int originalX;
  int originalY;
  Particle(int posX, int posY, double s, double r, double sp,  int mc, int opacity){
    x = posX;
    y = posY;
    defaultSize = s;
    size = s;
    angle = r;
    speed = sp;
    myColor = 255;
    crashable = false;
    myColor = mc;
    myOpacity = opacity;
    hasOpacity = true;
    originalX = (int)x;
    originalY = (int)y;
  }
  Particle(int posX, int posY, double s, double r, double sp){
    x = posX;
    y = posY;
    defaultSize = s;
    size = s;
    angle = r;
    speed = sp;
    myColor = 255;
    crashable = false;
    originalX = (int)x;
    originalY = (int)y;
  }
  void move(){
    x += speed * Math.cos(angle);
    y += speed * Math.sin(angle);
    size += 0.01 * speed;
  }
  void show(){
    if(hasOpacity){
      fill(myColor, myOpacity);
      noStroke();
    }
    else{
      fill(myColor);
      stroke(1);
    }
    ellipse((float)x, (float)y, (float)size, (float)size);
  }
  void reInitialize(int xPos, int yPos){
    x = xPos;
    y = yPos;
    size = Math.random() * 5 + 3;
    angle = Math.random() * 2 * Math.PI;
    speed = Math.random() * 4 + 1;
  }
  void reInitialize(int xPos, int yPos, double a, double s){
    x = xPos;
    y = yPos;
    size = s;
    angle = a;
    speed = Math.random() * 4 + 1;
  }
}
class Asteroid extends Particle{
  int type;
  Asteroid(int posX, int posY, double s, double r, double sp){
    super(posX, posY, s, r, sp);
    x = posX;
    y = posY;
    size = s;
    angle = r;
    speed = sp;
    myColor = 100;
    crashable = true;
  }
  void reInitialize(int xPos, int yPos){
    x = xPos;
    y = yPos;
    size = Math.random() * 5 + 3;
    angle = ((Math.random() * 2 + 1) * PI) / 4;
    speed = Math.random() * 3 + 1;
    crashable = true;
  }
  void move(){
    x += speed * Math.cos(angle);
    y += speed * Math.sin(angle);
    size += 0.2 * speed;
  }
  void show(){
    fill(120);
    ellipse((float)x, (float)y, (float)size, (float)size);
  }
}
class PowerUp extends Particle{
  int type;
  boolean active;
  PowerUp(int posX, int posY, double s, double r, double sp){
    super(posX, posY, s, r, sp);
    x = posX;
    y = posY;
    size = s;
    angle = r;
    speed = sp;
    myColor = 100;
    crashable = true;
    type = (int)(Math.random() * 2);
    active = false;
  }
  void reInitialize(int xPos, int yPos){
    x = xPos;
    y = yPos;
    size = Math.random() * 5 + 3;
    angle = ((Math.random() * 2 + 1) * PI) / 4;
    speed = Math.random() * 3 + 1;
    active = false;
    crashable = true;
    type = (int)(Math.random() * 2);
  }
  void move(){
    if((int)(Math.random() * 1000) == 0){
      active = true;
    }
    if(active){
      x += speed * Math.cos(angle);
      y += speed * Math.sin(angle);
      size += 0.2 * speed;
    }
  }
  void show(){
    if(active){
      fill(150);
      ellipse((float)x, (float)y, (float)size, (float)size);
      if(type == 0){
        fill(0, 0, 255, 100);
        ellipse((float)x, (float)y, (float)size, (float)size);
      }
      else if(type == 1){
        fill(255, 0, 0, 100);
        ellipse((float)x, (float)y, (float)size, (float)size);
      }
      else if(type == 2){
        fill(0, 255, 0, 100);
        ellipse((float)x, (float)y, (float)size, (float)size);
      }
    }
  }
}
class Button{
  int x, y, sX, sY;
  String bText;
  boolean pressed = false;
  Button(int pX, int pY, int sizeX, int sizeY, String buttonText){
    x = pX;
    y = pY;
    sX = sizeX;
    sY = sizeY;
    bText = buttonText;
  }
  boolean checkClick(){
    if(mouseX >= x && mouseX <= x + sX && mouseY >= y && mouseY <= y + sY){
      return true;
    }
    else{
      return false;
    }
  }
  void show(){
    if(mouseX >= x && mouseX <= x + sX && mouseY >= y && mouseY <= y + sY){
      fill(100);
    }
    else{
      fill(125);
    }
    noStroke();
    rect(x, y, sX, sY);
    fill(0);
    textAlign(CENTER);
    textSize(15);
    text(bText, x + sX/2, y + sY/2);
  }
}
