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

/*****
This method will parse output of a Django manage.py sql command
For documentation on using this command see:
 https://docs.djangoproject.com/en/dev/ref/django-admin/#sql-appname-appname
You can list all the apps you want displayed and then pipe them to a file
For example >>python manage.py sql places people organizations > schema.sql
IMPORTANT NOTE: make sure you order your applications by dependency.
If you try to parse a SQL table with a Foreign Key before you have parsed the
table which that key references, the parser will create a dummy table and you 
will end up with duplicates!  You have been warned.
******/
void parseDjangoSql(String[] lines) {

  
  for (int i = 0; i < lines.length; i++) {  
    //get names of all Entities in the schema
    //group(1) is the name of the Entity
    Pattern p = Pattern.compile("CREATE\\sTABLE\\s\\`(\\w+)\\`");
    Matcher m = p.matcher(lines[i]);
    
    if (m.lookingAt( )) {
      //finds (and creates) a new Entity
      Entity en = createEntity(m.group(1));
      
      //finds (and creates) the Entity's Attributes, and adds them to the Entity
      for(int j = i+1; j < lines.length; j++) {
        // stop if the line reads "end"
        Pattern end = Pattern.compile(";");
        Matcher e = end.matcher(lines[j]);
        if (!e.lookingAt()) {
          //get Attribute names and types
          //group(1) = name, group(2) = datatype
          Pattern attr = Pattern.compile("\\s+\\`(\\w+)\\`\\s+(\\w+)");
          Matcher a = attr.matcher(lines[j]);
          //test if attribute is primary key
          Pattern priKey = Pattern.compile("PRIMARY");
          Matcher pk = priKey.matcher(lines[j]);
          if(a.lookingAt() && pk.find()) {
            Attribute at = createAttribute("primary key", a.group(1));
            en.addAttribute(at);
            at.primary_key = true;
          }
          else if(a.lookingAt( ) && !pk.find()) {
            Attribute at = createAttribute(a.group(2), a.group(1));
            en.addAttribute(at);
          }
        } else break;
      }
    }
    
   //get all relationships in the schema
   //group(1) = entityFrom, group(3) = foreign key, group(4) = entityTo
   Pattern q = Pattern.compile("ALTER\\sTABLE\\s`(\\w+)`(.*)FOREIGN\\sKEY\\s\\(`(\\w+)`\\)\\sREFERENCES\\s`(\\w+)`");
   Matcher n = q.matcher(lines[i]);
    
    if (n.lookingAt( )) {
      Entity en = findEntity(n.group(1));
      en.getForeignKey(n.group(3));
      findEntity(n.group(4));
      createRelationship(n.group(1), n.group(4));
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
