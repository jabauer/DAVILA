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


class Entity extends toxi.physics2d.VerletParticle2D {
  
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
  void assignModule(String[] lines) {
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
  void colorCode (String[] lines) {
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
  void addAttribute(Attribute a) {
    attributes.add(a);
  }
  
  //Runs through the arrayList of Attributes and makes the appropriate Attribute a foreign key
  //sets boolean value and changes string type
  void getForeignKey(String foreignkey) {
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
  void display() {
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
  void displayModule() {
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
  void displayAnnotation() {
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
      if (w < width*.5) {
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
      if(a.foreign_key || a.primary_key || a.key_key) {
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
  
  boolean mouseInside( ) {
    //true if the mouse is within the rectangle used to display the Entity
    return (mouseX > x - w/2 && mouseX < x + w/2 &&
            mouseY > y - h/2 && mouseY < y + h/2);
  } 
}

/*These next 2 lines are needed for the javascript application, but the Processing IDE will choke on them.
Only uncomment in the file you put on your website

Entity.prototype = new toxi.physics2d.VerletParticle2D();
Entity.prototype.constructor = Entity;
 */
