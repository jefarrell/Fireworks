/*

/// Firework Attraction ///
   Any key reverses attraction behavior
     "D" adds gravity
     "G" removes gravity
     "F" reverses fading
   Use the mouse!
   
*/

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int PARTICLES = 300;

VerletPhysics2D physics;
AttractionBehavior mouseAttractor;

Vec2D mousePos;

ArrayList<AttractionBehavior> behaviors = new ArrayList<AttractionBehavior>();

GravityBehavior gb;

boolean fading = true;

void setup() {
  background(0);
  size(800, 550, P2D);


  //physics
  physics = new VerletPhysics2D();
  //drag
  physics.setDrag(0.09);
  //boundaries
  physics.setWorldBounds(new Rect(0, 0, width, height));
  //gravity
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.00)));

  gb = new GravityBehavior(new Vec2D(0, 0.01));
  physics.addBehavior(gb);
}

void addParticle(float x, float y) {

  VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().addSelf(x, y));
  // VerletParticle2D p1 = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(width / 2, 0));
  physics.addParticle(p);
  // add a negative attraction force field around the new particle
  AttractionBehavior ab = new AttractionBehavior(p, 20, -0.01f, -0.2f);
  physics.addBehavior(ab);
  behaviors.add(ab);
}

void draw() {
  if (fading) {
    fill(0, 10);
    rect(0, 0, width, height);
    noStroke();
  }

  //RELEASE ME
  fill(255,150);
  if (physics.particles.size() <  PARTICLES) {
    addParticle(width/2, height/3);
  }

  //PARTICLEZ
  physics.update();
  for (VerletParticle2D p : physics.particles) {
    ellipse(p.x, p.y, 2, 2);
  }
}


void mousePressed() {
  // physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.03)));
  // gb = new GravityBehavior(new Vec2D(0, 0.09));
  // physics.addBehavior(gb);


  mousePos = new Vec2D(mouseX, mouseY);
  // create a new positive attraction force field around the mouse position (radius=250px)
  mouseAttractor = new AttractionBehavior(mousePos, 250, 1.9f);
  physics.addBehavior(mouseAttractor);
}

void mouseDragged() {
  // mouse attraction
  mousePos.set(mouseX, mouseY);
}

void mouseReleased() {
  // remove attraction
  physics.removeBehavior(mouseAttractor);
}

//frame saver
void keyPressed() {
  for (AttractionBehavior ab : behaviors) {
    float strength = ab.getStrength();
    strength *= -1;
    ab.setStrength(strength);
    //ab.radius = 5;
  } 

  if (key == 'd' ) {
    physics.addBehavior(gb);
  }

  if (key == 'g') {
    physics.removeBehavior(gb);
  }

  if (key == 's') {
    saveFrame(random(1, 1000000) + ".png");
  } 
  else if (key == 'f') {
    fading = !fading;
  }
}

