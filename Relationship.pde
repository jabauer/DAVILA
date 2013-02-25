/* 

The Relationship Class links two Entities.  It is actually an extension of the toxiclibs VerletSpring2D Class.
Since VerletSpring2D only takes in the center position of each Entity (treating it as a particle), 
the Relationship class was needed to ensure that all information about each Entity was retained.

Relationships are created using the createRelationship method found in the main sketch.

*/


class Relationship extends toxi.physics2d.VerletSpring2D {
  Entity entityFrom;
  Entity entityTo;
  
  Relationship(VerletParticle2D from, VerletParticle2D to, float len) {
    super(from, to, len, .01);
    this.entityFrom = entityFrom;
    this.entityTo = entityTo;
  }
  
  Entity getFrom() {
    return entityFrom;
  }
  
  Entity getTo() {
    return entityTo;
  }
  
}

/*These next 2 lines are needed for the javascript application, but the Processing IDE will choke on them.
Only uncomment in the file you put on your website

Relationship.prototype = new toxi.physics2d.VerletSpring2D();
Relationship.prototype.constructor = Relationship; 
*/
