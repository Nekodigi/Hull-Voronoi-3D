//data related half edge(can duplicate in same place)
class HEData{
  ArrayList<HEVertex> vertices = new ArrayList<HEVertex>();
  ArrayList<HEFace> faces = new ArrayList<HEFace>();
  ArrayList<HalfEdge> edges = new ArrayList<HalfEdge>();
  //simplex should be triangle
  HEData(ArrayList<Simplex> triangles){
    OrientTrianglesClockwise(triangles);
    
    for(Simplex t : triangles){
      HEVertex v1 = new HEVertex(t.vertices[0].pos);
      HEVertex v2 = new HEVertex(t.vertices[1].pos);
      HEVertex v3 = new HEVertex(t.vertices[2].pos);
      
      HalfEdge he1 = new HalfEdge(v1);
      HalfEdge he2 = new HalfEdge(v2);
      HalfEdge he3 = new HalfEdge(v3);
      
      he1.nextEdge = he2;
      he2.nextEdge = he3;
      he3.nextEdge = he1;
  
      he1.prevEdge = he3;
      he2.prevEdge = he1;
      he3.prevEdge = he2;
      
      //The vertex needs to know of an edge going from it
      v1.edge = he2;
      v2.edge = he3;
      v3.edge = he1;

      //The face the half-edge is connected to
      HEFace face = new HEFace(he1);

      //Each edge needs to know of the face connected to this edge
      he1.face = face;
      he2.face = face;
      he3.face = face;


      //Add everything to the lists
      edges.add(he1);
      edges.add(he2);
      edges.add(he3);

      faces.add(face);

      vertices.add(v1);
      vertices.add(v2);
      vertices.add(v3);
    }
    
    //Step 4. Find the half-edges going in the opposite direction of each edge we have 
    //Is there a faster way to do this because this is the bottleneck?
    for (HalfEdge e : edges)
    {
      HEVertex goingToVertex = e.v;
      HEVertex goingFromVertex = e.prevEdge.v;

      for (HalfEdge eOther :edges)
      {
        //Dont compare with itself
        if (e == eOther)
        {
          continue;
        }

        //Is this edge going between the vertices in the opposite direction
        if (equal(goingFromVertex.pos, eOther.v.pos) && equal(goingToVertex.pos, eOther.prevEdge.v.pos))
        {
          e.oppositeEdge = eOther;

          break;
        }
      }
    }
  }
  
  ArrayList<HalfEdge> GetUniqueEdges()
  {
    ArrayList<HalfEdge> uniqueEdges = new ArrayList<HalfEdge>();

    for (HalfEdge e : edges)
    {
      float[] p1 = e.v.pos;
      float[] p2 = e.prevEdge.v.pos;

      boolean isInList = false;

      for (int j = 0; j < uniqueEdges.size(); j++)
      {
        HalfEdge testEdge = uniqueEdges.get(j);

        float[] p1_test = testEdge.v.pos;
        float[] p2_test = testEdge.prevEdge.v.pos;

        if ((equal(p1, p1_test) && equal(p2, p2_test)) || (equal(p2, p1_test) && equal(p1, p2_test)))
        {
          isInList = true;

          break;
        }
      }

      if (!isInList)
      {
          uniqueEdges.add(e);
      }
    }

    return uniqueEdges;
  }
  
  ArrayList<Simplex> toSimplexes(){//!simplex don't linked
    ArrayList<Simplex> triangles = new ArrayList<Simplex>();
    for(HEFace face : faces){
      Simplex t = new Simplex(3);
      t.vertices[0] = new Vertex(0, face.edge.v.pos);
      t.vertices[1] = new Vertex(0, face.edge.nextEdge.v.pos);
      t.vertices[2] = new Vertex(0, face.edge.nextEdge.nextEdge.v.pos);
      triangles.add(t);
    }
    return triangles;
  }
}


        

class HalfEdge{//Half edge
  HEVertex v;
  HEFace face;
  HalfEdge nextEdge;
  HalfEdge oppositeEdge;
  HalfEdge prevEdge;
  
  HalfEdge(HEVertex v){
    this.v = v;
  }
}

class HEVertex{
  float[] pos;
  HalfEdge edge;
  
  HEVertex(float[] pos){
    this.pos = pos;
  }
}

class HEFace{
  HalfEdge edge;
  
  HEFace(HalfEdge edge){
    this.edge = edge;
  }
}
