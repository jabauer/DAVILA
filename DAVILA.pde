/**   
 * <p>DAVILA, using the <a href="http://toxiclibs.org">toxiclibs</a> physics library <br/>
 * <a href="http://www.jeanbauer.com">www.jeanbauer.com</a><br/>
 * Spring 2010</p>
 */

/* 
 * Copyright (c) 2013 Jean Bauer 
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, see <http://www.gnu.org/licenses/>
 */

/*
 *This is the main sketch.  It contains most of the methods for creating/modifying class objects.
 *It also contains the global variable declarations, setup() and draw() methods,
 *and the methods for mouse and keyboard based interactions.
 
 *See README.TXT for more information.
 */

/*
  These variables are necessary for Processing.js to work with toxiclibs.js,
    but the Processing IDE will choke on them.
  Only uncomment the following lines in the file you will put on your website.

var  VerletPhysics2D = toxi.physics2d.VerletPhysics2D,
     VerletParticle2D = toxi.physics2d.VerletParticle2D,
     VerletSpring2D = toxi.physics2d.VerletSpring2D,
     VerletMinDistanceSpring2D = toxi.physics2d.VerletMinDistanceSpring2D,
     GravityBehavior = toxi.physics2d.behaviors.GravityBehavior,
     Vec2D = toxi.geom.Vec2D,
     Rect = toxi.geom.Rect; 
*/

//Import relevant portions of the toxiclibs physics library
import toxi.geom.*;
import toxi.math.*;

import toxi.physics2d.constraints.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;

//Import the pdf rendering library for Processing
import processing.pdf.*;

//reference to the physics world
VerletPhysics2D physics;

//These ArrayLists are used to hold all Entity and Relationship Objects
ArrayList entities;
ArrayList relationships;

//These Arrays are used for parsing the database schema and customization file
String[] schema;
String[] custom;

HashMap entityTable = new HashMap(); //allows lookup of Entity objects by name

Entity rolloverItem; //if the mouse is hovering over the displayed Entity it becomes rolloverItem

boolean record; // used to start and stop recording a snapshot as a pdf file
boolean hover; // true if the mouse is hovering over the attribution link (see in draw() below)

//two fonts
PFont regular, bold; 

void setup( ) {  
  size(1200, 900);
  smooth();
  frameRate(30);
  regular = createFont("Vera.ttf", 12);
  bold = createFont("VeraBd.ttf", 12);

  //choose your schema file
  //If you called it schemaDump.sql and placed it in the data folder there is nothing to change
  schema = loadStrings("data/schemaDump.sql");
  //chose your customization file 
  //If you called it customize.csv and placed it in the data folder there is nothing to change
  custom = loadStrings("data/customize.csv");
  //If you don't have a customization file yet, you can use this one instead
  //custom = loadStrings("data/testBlank.csv");
  

  entities = new ArrayList();
  relationships = new ArrayList();

  //Initialize the  physics
  physics = new VerletPhysics2D( );
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.5)));
  //physics.setGravity(new Vec2D(0, 0.5)); //this line is the old way of setting gravity, used prior to toxiclibs 0020

  //This is the center of the world
  Vec2D center = new Vec2D(width/2, height/2);
  //these are the world's dimensions (a vector point out from the center in both directions)
  Vec2D extent = new Vec2D(width/2.5, height/2.5);

  //Set the world's bounding box
  physics.setWorldBounds(Rect.fromCenterExtent(center, extent));

  //code located in Parser.pde
  parseMySQLDump(schema);
}

//This method actually draws the sketch
void draw( ) {

  //this creates the file for storing a snapshot as a pdf
  //the file will be saved in the sketch folder as "diagramTIMESTAMP.pdf"
  if (record) {
    String timestamp = str(year()) + str(month()) + str(day()) + str(hour()) + str(minute()) + str(second());
    beginRecord(PDF, "diagram" + timestamp + ".pdf");
  } 
  //update the physics world
  physics.update( );

  background(255);

  rolloverItem = null;


  stroke(200);
  //draw an arrow between each entity pair that shares a relationship
  for (int i = 0; i < relationships.size(); i++) {
    strokeWeight(1);
    Relationship r = (Relationship) relationships.get(i);
    Entity from = r.getFrom();
    Entity to = r.getTo();

    if (!from.hidden && !to.hidden) {    
      pushMatrix();
      float a = atan2(r.b.y - r.a.y, r.b.x - r.a.x);
      line(r.a.x + cos(a) * (from.w /2), r.a.y + sin(a) * (from.h /2), r.b.x - cos(a) * (to.w /2), r.b.y - sin(a)*(to.h /2));

      translate(r.b.x - cos(a) * (to.w /2), r.b.y - sin(a) * (to.h /2));
      rotate(a-HALF_PI);
      fill(100);
      triangle(-5, -10, 0, 0, 5, -10);

      popMatrix();
    }
  } 

  //display all Entities as rectangle
  for (int i = 0; i < entities.size(); i++) {
    Entity p = (Entity) entities.get(i);
    //either with full information or simply the name
    if(!p.hidden) {
      if(p.expanded) {
        p.displayAnnotation();
      } 
      else if (p.moduleCollapsed) {
        p.displayModule();
      } 
      else {
        p.display();
      }
    }
  } 

  //Display Information about the Diagram/ Project
  displayInfo(custom);


  //Attribution
  //Creates text for an attribution link
  textMode(SHAPE);
  textFont(regular);
  rectMode(CORNER);
  fill(255);
  String AText = "Generated with DAVILA";
  float w = textWidth(AText + 10);
  float h = textAscent() + textDescent() + 5;
  rect(width-5 - w, height-5 - h, w, h);
  fill(100);
  textAlign(RIGHT);
  text(AText, width-10, height-10);

  //this saves the pfd snapshot
  if (record) {
    endRecord( );
    record = false;
  }
}

//This method pulls information about the diagram and larger project from the customize.csv file
//It displays this information in the top left-hand of the screen
void displayInfo(String[] lines) {
  textMode(SHAPE);
  int x = 10;
  int y = 20;
  fill(100);
  textFont(bold);
  textAlign(LEFT);
  for (int i= 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], "|");
    if (pieces[0].equals("title")) {
      text(pieces[1], x, y);
      y+=15;
    }
    if (pieces[0].equals("url")) {
      text(pieces[1], x, y);
      y+=15;
    } 
    if (pieces[0].equals("creators")) {
      text(pieces[1], x, y);
      y+=15;
    }
    //Lists the names of each module, color coded for easy identification with their respective entities
    if (pieces[0].equals("module")) {
      String moduleColor = pieces[2];
      moduleColor = "FF" + moduleColor.substring(1);
      fill(unhex(moduleColor));
      textFont(bold);
      text(pieces[1], x, y);
      y += 15;
    }//License information is placed in the lower left corner
    if (pieces[0].equals("license")) {
      textFont(regular);
      fill(100);
      text(pieces[1], x, height-10);
    }
  }
}

//creates a new Entity, assigns it to a module, and gets its color coding
Entity createEntity(String name) {
  Entity p = new Entity(Vec2D.randomVector(), .1, name);
  p.assignModule(custom);
  p.colorCode(custom);
  p.expanded = false;
  p.hidden = false;
  p.moduleCollapsed = false;
  entities.add(p);
  entityTable.put(name, p);
  physics.addParticle(p);
  return p;
}

//finds an entity based on its name 
Entity findEntity(String name) {
  Entity p = (Entity) entityTable.get(name);
  if (p == null) {
    createEntity(name);
  }
  return p;
}

//creates an Attribute
Attribute createAttribute(String type, String name) {
  Attribute at = new Attribute(type, name);
  return at;
}

//creates a Relationship
//This method generates two types of Springs
//A VerletSpring2D between the two Entities in the relationships
//and a MinDistanceSpring to avoid overlap (doesn't work perfectly in all cases)
void createRelationship(String entityFrom, String entityTo) {
  Entity p1 = findEntity(entityFrom);
  Entity p2 = findEntity(entityTo);
  // connect first entity with all others
  // but use different spring types
  for(Iterator i=entities.iterator(); i.hasNext();) {
    Entity p = (Entity)i.next();
    if (p!=p1) {
      Relationship r;
      if (p==p2) {
        // create main connection to target entity
        r = new Relationship(p1, p, 100);
        r.entityFrom = p1;
        r.entityTo = p;
        relationships.add(r);
        physics.addSpring(r);
      }
      else {
        // ensure min distance to all other nodes
        VerletSpring2D s = new VerletMinDistanceSpring2D(p1, p, 200, .01);
        physics.addSpring(s);
      }
    }
  }
}

//The following methods handle user interactions via mouse and keyboard

void mousePressed( ) {
  if (rolloverItem !=null) {
    //Single left click to lock an entity in place
    if (mouseButton == LEFT) {
      rolloverItem.lock();
      //Single right click to unlock
    } 
    if (mouseButton == RIGHT) {
      rolloverItem.unlock();
    }
    //Double left click to toggle expanding an Entity
    if (mouseEvent.getClickCount()==2 && mouseButton == LEFT) {
      rolloverItem.expanded = !rolloverItem.expanded;
    } 
    //Double right click to toggle hiding non-central nodes of a module
    if (mouseEvent.getClickCount()==2 && mouseButton == RIGHT && rolloverItem.central) {
      rolloverItem.moduleCollapsed = !rolloverItem.moduleCollapsed;
      for(Iterator i=entities.iterator(); i.hasNext();) {
        Entity p = (Entity)i.next();
        if (rolloverItem.module.equals(p.module) && (rolloverItem.name.equals(p.name) == false)) {
          p.hidden = !p.hidden;
        }
      }
    }
  }
} 

//Drag an entity to a new location
void mouseDragged( ) {
  if (rolloverItem != null) {
    rolloverItem.x = mouseX;
    rolloverItem.y = mouseY;
  }
}

void mouseReleased( ) {
  rolloverItem = null;
}

void keyPressed( ) {
  //Press the spacebar to capture a snapshot of the sketch as a pdf file (see record in draw())
  if (key == ' ') {
    record = true;
  }
}

boolean overLink(float x, float y, int w, int h ) {
  if (mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h) {
    return true;
  } else {
    return false;
  }
}

