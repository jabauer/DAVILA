/**
 *This file contains the code used to parse the database schema.
  
 *If you need to write your own parser, all it needs to find are
 
 * 1 - the name of every entity in the database
 * 2 - the name and type of every attribute associated with each entity, including primary keys
 * 3 - every relationship in the database along with the name of each foreign key
 
 *Replace the 4 regular expressions in to the code below, 
 *and you should be in business.
 
 *Processing has helper functions for Java Regular Expressions.  The two commands you need are:
   *match() -- http://processingjs.org/reference/match_/
   *matchAll() -- http://processingjs.org/reference/matchAll_/
   
 *You still need to use Java Regex syntax, unfortunately.  Don't forget the extra '\'!
 
 *If you create a new parser, please share it.

*/

/*****
This method will parse output of a Django manage.py sql command
For documentation on using this command see:
https://docs.djangoproject.com/en/dev/ref/django-admin/#sql-appname-appname
 
You can list all the apps you want displayed and then pipe them to a file

For example 
>>python manage.py sql places people organizations > schema.sql

******/
void parseDjangoSql(String[] lines) {
  
   
  for (int i = 0; i < lines.length; i++) {  
    //get names of all Entities in the schema
    //m[0][1] is the name of the Entity
    String[][] m = matchAll(lines[i], "CREATE\\sTABLE\\s\\`(\\w+)\\`");
    
    if (m != null) {
      //finds (and creates) a new Entity
      Entity en = createEntity(m[0][1]);
      
      //finds (and creates) the Entity's Attributes, and adds them to the Entity
      for(int j = i+1; j < lines.length; j++) {
        // stop if the line reads ";"
        String[] end = match(lines[j], ";");
        if (end == null) {
          //get Attribute names and types
          //attr[0][1] = name, attr[0][2] = datatype
          String[][] attr = matchAll(lines[j], "\\s+\\`(\\w+)\\`\\s+(\\w+)");
          //test if attribute is primary key
          String[] priKey = match(lines[j], "PRIMARY");
          if(attr != null && priKey != null) {
            Attribute at = createAttribute("primary key", attr[0][1]);
            en.addAttribute(at);
            at.primary_key = true;
          }
          else if(attr != null && priKey == null) {
            Attribute at = createAttribute(attr[0][2], attr[0][1]);
            en.addAttribute(at);
          }
        } else break;
      }
    }
  }

 for (int i = 0; i < lines.length; i++) {   
   //get all relationships in the schema
   //fk[0][1] = entityTo, fk[0][3] = foreign key, fk[0][4] = entityFrom
   String[][] fk = matchAll(lines[i], "ALTER\\sTABLE\\s`(\\w+)`(.*)FOREIGN\\sKEY\\s\\(`(\\w+)`\\)\\sREFERENCES\\s`(\\w+)`");
    
    if (fk != null) {
      Entity en = findEntity(fk[0][1]);
      en.getForeignKey(fk[0][3]);
      findEntity(fk[0][4]);
      createRelationship(fk[0][4],fk[0][1]);
    }
  }
}

/****
This method will parse the schema.rb file of a Rails 2.x app.
It automatically adds a primary key named "id" to every Entity
It also assumes you are using SQL statements to create foreign key constraints
If this does not match your schema, then make the appropriate adjustments
If you do use this schema, be sure to change the name of the parsed file at
the beginning of the DAVILA.pde file from schema.sql to schema.rb.
****/
void parseRails2fkcSchema(String[] lines) {

  
  for (int i = 0; i < lines.length; i++) {  
    //get names of all Entities in the schema
    //m[0][1] is the name of the Entity
    String[][] m = matchAll(lines[i], "\\s+create_table\\s\"(\\w+)\"");
    
    if (m != null) {
      //finds (and creates) a new Entity
      Entity en = createEntity(m[0][1]);
      
      //Creates the primary key "id" added by Rails to every Entity but not specified in the schema
      Attribute id = createAttribute("primary key", "id");
      id.primary_key = true;
      en.addAttribute(id);
      
      //finds (and creates) the Entity's Attributes, and adds them to the Entity
      for(int j = i+1; j < lines.length; j++) {
       // stop if the line reads "end"
       String[] end = match(lines[j], "\\s+end");
        if (end == null) {
          //get Attribute names and types
          //attr[0][1] = name, attr[0][2] = datatype
          String[][] attr = matchAll(lines[j], "\\s+t.(\\w+)\\s+\"(\\w+)\"");
          if(attr != null) {
            Attribute at = createAttribute(attr[0][1], attr[0][2]);
            en.addAttribute(at);
          }
        } else break;
      }
    }
    
   //get all relationships in the schema, including the foreign keys
   //this parses a SQL 92 foreign key constraint
   //fk[0][1] = entityTo, fk[0][2] = foreign key, fk[0][3] = entityFrom
   String[][] fk = matchAll(lines[i], "\\s+add_foreign_key\\s\"(\\w+)\",\\s\\[\"(\\w+)\"\\],\\s\"(\\w+)\"");
    
    if (fk != null) {
      Entity en = findEntity(fk[0][1]);
      en.getForeignKey(fk[0][2]);
      findEntity(fk[0][3]);
      createRelationship(fk[0][3], fk[0][1]);
    }
  }
}
