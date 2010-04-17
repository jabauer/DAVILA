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
