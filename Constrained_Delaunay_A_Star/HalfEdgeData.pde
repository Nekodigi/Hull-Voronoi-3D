//data related half edge(can duplicate in same place)
class HEData{
  ArrayList<HEVertex> vertices = new ArrayList<HEVertex>();
  ArrayList<HEFace> faces = new ArrayList<HEFace>();
  ArrayList<HalfEdge> edges = new ArrayList<HalfEdge>();
  ObjectBuffer buffer;
  
  //simplex should be triangle
  HEData(ArrayList<Simplex> triangles){
    buffer = new ObjectBuffer(3);
    
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
  
  boolean contains(ArrayList<Vertex> posIds, float[] target){
    for(Vertex posId : posIds){
      if(posId.pos[0] == target[0] && posId.pos[1] == target[1]){
        return true;
      }
    }
    return false;
  }
  
  int indexOf(ArrayList<Vertex> posIds, float[] target){
    for(int i = 0; i<posIds.size(); i++){
      Vertex posId = posIds.get(i);
      if(posId.pos[0] == target[0] && posId.pos[1] == target[1]){
        return i;
      }
    }
    return -1;
  }
  
  SimplexVertices toSimplexes(){//!simplex don't linked
    ArrayList<Simplex> triangles = new ArrayList<Simplex>();
    ArrayList<Vertex> posIds = new ArrayList<Vertex>();//so blute force
    int i = 0;
    for(HEVertex vertex : vertices){
      if(!contains(posIds, vertex.pos)){
        posIds.add(new Vertex(i++, vertex.pos));
      }
    }
    for(HEFace face : faces){
      Simplex t = new Simplex(3);
      float[] p1 = face.edge.v.pos;
      float[] p2 = face.edge.nextEdge.v.pos;
      float[] p3 = face.edge.nextEdge.nextEdge.v.pos;//println(indexOf(posIds, p1));
      t.vertices[0] = posIds.get(indexOf(posIds, p1));
      t.vertices[1] = posIds.get(indexOf(posIds, p2));
      t.vertices[2] = posIds.get(indexOf(posIds, p3));
      
      triangles.add(t);
      for(int j = 0; j < 3; j++){
        SimplexConnector connector = new SimplexConnector(t, j, 3);//connector is a class for searching the corresponding face at high speed with hash
        connectFace(connector);
      }
    }
    
    
    
    return new SimplexVertices(triangles, posIds);
  }
  
  void connectFace(SimplexConnector connector){
    int index = connector.hashCode % buffer.connector_table_size;
    ArrayList<SimplexConnector> list = buffer.connectorTable[index];
    //check foreach connector
    for(int i = 0; i < list.size(); i++){
      SimplexConnector current = list.get(i);
      if(SimplexConnector.areConnectable(connector, current, 3)){
        list.remove(current);
        SimplexConnector.connect(current, connector);
        return;
      }
    }
    list.add(connector);
  }
}

class SimplexVertices{
  ArrayList<Simplex> simplexes = new ArrayList<Simplex>();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  
  SimplexVertices(ArrayList<Simplex> simplexes, ArrayList<Vertex> vertices){
    this.simplexes = simplexes;
    this.vertices = vertices;
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
