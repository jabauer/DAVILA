import processing.core.*; 
import processing.xml.*; 

import toxi.geom.*; 
import toxi.physics2d.*; 
import processing.pdf.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class DAVILA extends PApplet {

/**   
 * <p>DAVILA, using the <a href="http://toxiclibs.org">toxiclibs</a> physics library <br/>
 * <a href="http://www.jeanbauer.com">www.jeanbauer.com</a><br/>
 * Spring 2010</p>
 */

/* 
 * Copyright (c) 2010 Jean Bauer 
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

//Import relevant portions of the toxiclibs physics library



//Import the pdf rendering library for Processing


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

public void setup( ) {  
  size(1000, 700);
  smooth();
  frameRate(30);
  regular = createFont("Vera.ttf", 12);
  bold = createFont("VeraBd.ttf", 12);

  //choose your schema file
  //If you called it schema.rb and placed it in the data folder there is nothing to change
  schema = loadStrings("schema.rb");
  //chose your customization file 
  //If you called it customize.csv and placed it in the data folder there is nothing to change
  custom = loadStrings("customize.csv");

  entities = new ArrayList();
  relationships = new ArrayList();

  //Initialize the  physics
  physics = new VerletPhysics2D( );
  physics.setGravity(new Vec2D(0, 0.5f));

  //This is the center of the world
  Vec2D center = new Vec2D(width/2, height/2);
  //these are the world's dimensions (a vector point out from the center in both directions)
  Vec2D extent = new Vec2D(width/2.5f, height/2.5f);

  //Set the world's bounding box
  physics.setWorldBounds(Rect.fromCenterExtent(center, extent));

  //code located in Parser.pde
  parseRails2fkcSchema(schema);
}

//This method actually draws the sketch
public void draw( ) {

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
public void displayInfo(String[] lines) {
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
public Entity createEntity(String name) {
  Entity p = new Entity(Vec2D.randomVector(), .1f, name);
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
public Entity findEntity(String name) {
  Entity p = (Entity) entityTable.get(name);
  if (p == null) {
    createEntity(name);
  }
  return p;
}

//creates an Attribute
public Attribute createAttribute(String type, String name) {
  Attribute at = new Attribute(type, name);
  return at;
}

//creates a Relationship
//This method generates two types of Springs
//A VerletSpring2D between the two Entities in the relationships
//and a MinDistanceSpring to avoid overlap (doesn't work perfectly in all cases)
public void createRelationship(String entityFrom, String entityTo) {
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
        VerletSpring2D s = new VerletMinDistanceSpring2D(p1, p, 200, .01f);
        physics.addSpring(s);
      }
    }
  }
}

//The following methods handle user interactions via mouse and keyboard

public void mousePressed( ) {
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
public void mouseDragged( ) {
  if (rolloverItem != null) {
    rolloverItem.x = mouseX;
    rolloverItem.y = mouseY;
  }
}

public void mouseReleased( ) {
  rolloverItem = null;
}

public void keyPressed( ) {
  //Press the spacebar to capture a snapshot of the sketch as a pdf file (see record in draw())
  if (key == ' ') {
    record = true;
  }
}

public boolean overLink(float x, float y, int w, int h ) {
  if (mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h) {
    return true;
  } else {
    return false;
  }
}

/* 

The Attribute class is pretty straightforward.  Each Attribute has a String for name and a String for datatype.
There is also a boolean value indicating whether or not this attribute is a foreign or primary key.  
New Attributes are created the function createAttribute (found in the main sketch).

Every Entity has an arrayList of the Attributes associated with that Entity.
Attributes are added to an Entity with the function addAttribute and foreign keys are located
with the function getForeignKey (both functions are methods of the Entity Class).

*/


class Attribute {
  String type;
  String name;
  boolean foreign_key;
  boolean primary_key;
 
 Attribute(String type, String name) {
   this.type = type;
   this.name = name;
   this.foreign_key = foreign_key;
   this.primary_key = primary_key;
 } 
}
/**
  * The Entity class extends the VerletParticle2D class in the toxiclibs physics library.
  * This class contains all the information about an entity in the databases, including
    * the Entity's name
    * a list of Attributes associated with that Entity
    * the module that Entity belongs to
    * the colorcoding based on that module
    * whether or not this Entity is the central Entity of that module
    
   * The Entity Class also includes functions for getting relevant information from the CSV file
   * Adding Attributes to the Entity
   * and displaying the Entity in both an abbreviated and expanded form
   
   * Methods to create Entities are found in the main sketch
    

*/


class Entity extends VerletParticle2D {
  
  String name;             //parsed from schema
  ArrayList attributes;    //parsed from schema
  String module;           //parsed from CSV file
  String moduleColor;      //parsed from CSV file
  String annotation;       //parsed from CSV file
  boolean central;         //parsed from CSV file
  float w, h;              //width and height of rectangle used to display information
  boolean expanded;        //determines how much information about an Entity is displayed
  boolean hidden;         //determines if the Entity will be displayed or not
  boolean moduleCollapsed;  //determines if the Entity will display the name of the module
  
  Entity(Vec2D pos, float g, String name) {
    super(pos, g); //g for gravity
    this.name = name;
    attributes = new ArrayList();
    this.module = module;
    this.moduleColor = moduleColor;
    this.h = h;
    this.w = w;
  }
  
  //This function parses the CSV file and uses the data entered about an Entity to 
  //populate the module and annotation fields
  public void assignModule(String[] lines) {
    for (int i= 0; i < lines.length; i++) {
      String[] pieces = split(lines[i], "|");
      if (name.equals(pieces[0])) {
        module = pieces[1];
        annotation = pieces[2];
      }
    }
  }
  
  
  
  //parses CSV file to assign each Entity the color associated with its module
  //also determines if the Entity is the central entity of its module
  public void colorCode (String[] lines) {
    central = false;
    for (int i= 0; i < lines.length; i++) {
      String[] pieces = split(lines[i], "|");
      if (pieces[0].equals("module") && module.equals(pieces[1])) {
        moduleColor = pieces[2];
        moduleColor = "FF" + moduleColor.substring(1);
        if (pieces[3] != null & name.equals(pieces[3])) {
          central = true;
        }
      }
    }
  } 
  
  //Adds an Attribute to the arrayList of Attributes associated with this Entity
  public void addAttribute(Attribute a) {
    attributes.add(a);
  }
  
  //Runs through the arrayList of Attributes and makes the appropriate Attribute a foreign key
  //sets boolean value and changes string type
  public void getForeignKey(String foreignkey) {
    for (int i = 0; i < attributes.size(); i++) {
      Attribute a = (Attribute) attributes.get(i);
      if (a.name.equals(foreignkey)) {
        a.foreign_key = true;
        a.type = "foreign key";
      }
    }
  }
  
  //displays and Entity as its name in a rectangle
  //the rectange is color coded based on the Entity's module
  public void display() {
    noStroke();
    textMode(SHAPE);
    
    //if the Entity is the central Entity of its module
    //the name is displayed in BOLD 
    if(central) {
      textFont(bold);
    } else {
      textFont(regular);
    }
    fill(unhex(moduleColor), 200);
    
    //The rectangle is sized based on the height and width of the Entity's name
    rectMode(CORNER);
    w = textWidth(name) + 20;
    h = textAscent(  ) + textDescent(  ) + 8;
    rect(x - w/2, y - h/2, w, h);

    fill(0);
    textAlign(CENTER, CENTER); 
    text(name, x, y);
     
    //allows for mouse based interaction (see mouseInside() below)  
    if (mouseInside()) {
      rolloverItem = this;
    } 
  }
    
  //Displays the central Entity of a module in a larger color coded rectangle
  //along with the name of the module  
  public void displayModule() {
    noStroke();
    textMode(SHAPE);
    textFont(bold);
    fill(unhex(moduleColor), 200);
    
    //The rectangle is sized based on the height and width of the module's name or the Entity's name
    //which ever is longer
    rectMode(CORNER);
    float Nw = textWidth(name);
    float Mw = textWidth(module);
    if (Nw > Mw) {
      w = textWidth(name) + 20;
    } else {
      w = textWidth(module) + 20;
    }
    float textHeight = textAscent(  ) + textDescent(  ) + 8;
    String moduleStatement = name + " (" + module + " module)";
    h = (round(textWidth(moduleStatement)/w)+1)*textHeight;
    rect(x - w/2, y - h/2, w, h);

    fill(0);
    textAlign(CENTER, CENTER); 
    text(moduleStatement, x - w/2 , y - h/2, w, h);
     
    //allows for mouse based interaction (see mouseInside() below)  
    if (mouseInside()) {
      rolloverItem = this;
    } 
  }
  
  //Displays all information about the Entity in a rectangle
  //Displays name, annotation, and all Attributes (name and type)
  //border of rectangle color coded based on Entity's module
  public void displayAnnotation() {
    textMode(SHAPE);
    rectMode(CORNER);
    
    //if the Entity is the central Entity of its Module the border is 2.5 times thicker
    if (central) {
      strokeWeight(10);
    } else {
      strokeWeight(4);
    }
    stroke(unhex(moduleColor), 200);
    fill(255, 100);
    
    //default width set to 200px
    w = 200;
    //resizes the display box if the attribute names and types would overlap
    for (int i = 0; i < attributes.size(); i++){
      Attribute a = (Attribute) attributes.get(i);
      float attW = textWidth(a.type) + textWidth(a.name) + 60;
      if (w < attW) {
        w = attW;
      }
    }
    
    //determins the height of the annotation box based on 
    //the length of the annotation divided by the width
    float lineHeight = textAscent(  ) + textDescent(  ) + 5;
    int lineNum = round((textWidth(annotation)/(w-30)))+1;
    int boldHeight = 30; //this accounts for the height of the name
    float textHeight = (lineNum)*(lineHeight);
    
    //determines the height of the Attributes list
    float attHeight = (attributes.size()+1)*(lineHeight);
    
    //adds up all the elements to get the height of the rectangle
    h = textHeight + attHeight + boldHeight;
    
    //resizes the display box if it is too tall to fit in the screen
    //but will not allow a display box to take up more than 1/2 of the screen width
    //if your display box is still too tall, 
    //increase the height of the sketch (use size(width, height) in setup()
    //or consider being more concise in your annotation :~)
    while (h > height - 50) {
      if (w < width*.5f) {
      w += 5;
      lineNum = round((textWidth(annotation)/(w-30)))+1; 
      textHeight = (lineNum)*(lineHeight);
      h = textHeight + attHeight + boldHeight;
      } else break;
    }
    rect(x - w/2, y - h/2, w, h);
    
    //renders the name
    textAlign(CENTER, TOP);
    textFont(bold);
    fill(unhex(moduleColor));
    text(name, x, y-(h/2 - 10));
    
    //renders the annotation
    textAlign(LEFT, TOP);
    textFont(regular);
    fill(0);
    text(annotation, x-(w/2 - 10), y-(h/2 - boldHeight), w-20, textHeight); 
    
    //renders each of the atttributes, their name and datatype
    textAlign(LEFT, BOTTOM);
    for (int i = 0; i < attributes.size(); i++){
      Attribute a = (Attribute) attributes.get(i);
      if(a.foreign_key || a.primary_key) {
        textFont(bold);
        fill(unhex(moduleColor));
      } else {
        textFont(regular);
        fill(0);
      }
      text(a.name, x-(w/2 - 10), y-(h/2 - (textHeight + boldHeight) - (i+1)*(lineHeight)));
      text(a.type, x+((w/2 - textWidth(a.type)) - 10), y-(h/2 - (textHeight + boldHeight) - (i+1)*(lineHeight)));
    }

    //allows for mouse based interaction (see mouseInside() below)  
    if (mouseInside()) {
      rolloverItem = this;
    }
  }
  
  public boolean mouseInside( ) {
    //true if the mouse is within the rectangle used to display the Entity
    return (mouseX > x - w/2 && mouseX < x + w/2 &&
            mouseY > y - h/2 && mouseY < y + h/2);
  } 
}
/**
 *This file contains the code used to parse the database schema.
 *If you need to write your own parser, all it needs to find are
 
 * 1 - the name of every entity in the database
 * 2 - the name and type of every attribute associated with each entity, including primary keys
 * 3 - every relationship in the database along with the name of each foreign key
 
 *Replace the 4 regular expressions in to the code below, 
 *and you should be in business.
 
 *If you create a new parser, please share it.

*/

//This method will parse the schema.rb file of a Rails 2.x app.
//It automatically adds a primary key named "id" to every Entity
//It also assumes you are using SQL statements to create foreign key constraints
//If this does not match your schema, then make the appropriate adjustments
public void parseRails2fkcSchema(String[] lines) {

  
  for (int i = 0; i < lines.length; i++) {  
    //get names of all Entities in the schema
    //group(1) is the name of the Entity
    Pattern p = Pattern.compile("\\s+create_table\\s\"(\\w+)\"");
    Matcher m = p.matcher(lines[i]);
    
    if (m.lookingAt( )) {
      //finds (and creates) a new Entity
      Entity en = createEntity(m.group(1));
      
      //Creates the primary key "id" added by Rails to every Entity but not specified in the schema
      Attribute id = createAttribute("primary key", "id");
      id.primary_key = true;
      en.addAttribute(id);
      
      //finds (and creates) the Entity's Attributes, and adds them to the Entity
      for(int j = i+1; j < lines.length; j++) {
        // stop if the line reads "end"
        Pattern end = Pattern.compile("\\s+end");
        Matcher e = end.matcher(lines[j]);
        if (!e.lookingAt()) {
          //get Attribute names and types
          //group(1) = datatype, group(2) = name
          Pattern attr = Pattern.compile("\\s+t.(\\w+)\\s+\"(\\w+)\"");
          Matcher a = attr.matcher(lines[j]);
          if(a.lookingAt( )) {
            Attribute at = createAttribute(a.group(1), a.group(2));
            en.addAttribute(at);
          }
        } else break;
      }
    }
    
   //get all relationships in the schema, including the foreign keys
   //this parses a SQL 92 foreign key constraint
   //group(1) = entityTo, group(2) = foreign key, group(3) = entityFrom
   Pattern q = Pattern.compile("\\s+add_foreign_key\\s\"(\\w+)\",\\s\\[\"(\\w+)\"\\],\\s\"(\\w+)\"");
   Matcher n = q.matcher(lines[i]);
    
    if (n.lookingAt( )) {
      Entity en = findEntity(n.group(1));
      en.getForeignKey(n.group(2));
      findEntity(n.group(3));
      createRelationship(n.group(3), n.group(1));
    }
  }
}
/* 

The Relationship Class links two Entities.  It is actually an extension of the toxiclibs VerletSpring2D Class.
Since VerletSpring2D only takes in the center position of each Entity (treating it as a particle), 
the Relationship class was needed to ensure that all information about each Entity was retained.

Relationships are created using the createRelationship method found in the main sketch.

*/


class Relationship extends VerletSpring2D {
  Entity entityFrom;
  Entity entityTo;
  
  Relationship(VerletParticle2D from, VerletParticle2D to, float len) {
    super(from, to, len, .01f);
    this.entityFrom = entityFrom;
    this.entityTo = entityTo;
  }
  
  public Entity getFrom() {
    return entityFrom;
  }
  
  public Entity getTo() {
    return entityTo;
  }
  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "DAVILA" });
  }
}
