import java.util.Arrays;
import java.util.ArrayDeque;
import java.util.Deque;

class ConvexHull{
  int dim;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Simplex> simplexes = new ArrayList<Simplex>();
  float[] centroid;
  ObjectBuffer buffer;
  
  ConvexHull(int dim){
    this.dim = dim;
    centroid  = new float[dim];
  }
  
  //region GENERATE--------------------------------------------------------------
  
  void Generate(ArrayList<Vertex> input){
    boolean assignIds = true; boolean checkInput = false;
    
    clear();//clear centroid, vertices, simplexes
    buffer = new ObjectBuffer(dim);
    
    if(input.size() < dim + 1) return;//points validation confilmation
    
    buffer.addInput(input, assignIds, checkInput);//register all input points
    
    initConvexHull();//Please look source
    
    //Expand the convex hull and faces.
    while(buffer.unprocessedFaces.size() > 0){
      Simplex currentFace = buffer.unprocessedFaces.get(0);
      buffer.currentVertex = currentFace.furthestVertex;
      
      updateCenter();//refer buffer.currentVertex
      //the affected faces get tagged. the face has furthest point same side as normal.
      tagAffectedFaces(currentFace);//tagged face will delete and replace by new face
      
      //create the cone from the currentVertex and the affected faces horizon.
      if(!buffer.singularVertices.contains(buffer.currentVertex) && createCone())
        commitCone();
      else
        handleSingular();
        
      //need to reset the tags
      for(int i = 0; i < buffer.affectedFaces.size(); i++){buffer.affectedFaces.get(i).tag = 0;};
    }
    
    for(int i = 0; i < simplexes.size(); i++){
      Simplex wrap = simplexes.get(i);
      wrap.tag = i;//set data simplexes
      wrap.calcCentroid();
    }
    buffer = null;
  }
  
  void clear(){
    centroid = new float[dim];
    simplexes.clear();
    vertices.clear();
  }
  
  //region INITIALIZATION-------------------------------------
  //find the (dimension+1) initial points and create the simplexes
  void initConvexHull(){
    ArrayList<Vertex> extremes = findExtremes();//Bipolar vertex on each axis
    ArrayList<Vertex> initialPoints = findInitialPoints(extremes);//Returns furthest extreme pair ...(Returns dimension+1 extremes)

    for(int i = 0; i < initialPoints.size(); i++){
      buffer.currentVertex = initialPoints.get(i);
      updateCenter();//refer buffer.currentVertex
      vertices.add(buffer.currentVertex);//add vertex to completed vertices
      buffer.inputVertices.remove(buffer.currentVertex);//remove vertex from input vertices
    }
    //Create initial simplexes           //Record adjacent face at oppsite vertex of the face
    Simplex[] faces = initFaceDatabase();//Calculate normal distance between origin and first vertex. And flip the normal to point outward from the origin
    
    for(int i = 0; i < faces.length; i++){
      findBeyondVertices(faces[i]);
      if(faces[i].beyondVertices.size() == 0)
        simplexes.add(faces[i]);
      else
        buffer.unprocessedFaces.add(faces[i]);
    }
  }
  
  // Finds the extremes in all axis.
  ArrayList<Vertex> findExtremes(){
    ArrayList<Vertex> extremes = new ArrayList<Vertex>(2 * dim);
    
    for(int i = 0; i < dim; i++){
      float min = Float.POSITIVE_INFINITY, max = Float.NEGATIVE_INFINITY;
      int minInd = 0, maxInd = 0;
      
      for(int j = 0; j < buffer.inputVertices.size(); j++){
        float v = buffer.inputVertices.get(j).pos[i];
        
        if(v < min){
          min = v;
          minInd = j;
        }
        if(v > max){
          max = v;
          maxInd = j;
        }
      }
      
      if(minInd != maxInd){
        extremes.add(buffer.inputVertices.get(minInd));
        extremes.add(buffer.inputVertices.get(maxInd));
      }else
        throw new IllegalArgumentException();
    }
    return extremes;
  }
  
  float getSqrDistSum(Vertex pivot, ArrayList<Vertex> initialPoints){
    float sum = 0;
    for(int i = 0; i < initialPoints.size(); i++){
      sum += sqrDist(initialPoints.get(i).pos, pivot.pos);
    }
    return sum;
  }
  
  ArrayList<Vertex> findInitialPoints(ArrayList<Vertex> extremes){
    ArrayList<Vertex> initialPoints = new ArrayList<Vertex>();
    Vertex first = null; Vertex second = null;
    float maxDist = 0;
    
    for(int i = 0; i < extremes.size() - 1; i++){
      Vertex a = extremes.get(i);
      for(int j = i + 1; j < extremes.size(); j++){
        Vertex b = extremes.get(j);
        float dist = sqrDist(a.pos, b.pos);
        
        if(dist > maxDist){
          first = a;
          second = b;
          maxDist = dist;
        }
      }
    }
    
    initialPoints.add(first);//record furthest extreme pair
    initialPoints.add(second);
    
    for(int i = 2; i <= dim; i++){
      float maximum = EPSILON;
      Vertex maxPoint = null;
      
      for(int j = 0; j < extremes.size(); j++){
        Vertex extreme = extremes.get(j);
        if(initialPoints.contains(extreme)) continue;
        
        float distS = getSqrDistSum(extreme, initialPoints);
        
        if(distS > maximum){
          maximum = distS;
          maxPoint = extreme;
        }
      }
      
      if(maxPoint != null)
        initialPoints.add(maxPoint);
      else
        throw new IllegalArgumentException("Singular input data error");
    }
    return initialPoints;
  }
  
  //create the faces from (dimension + 1) vertices 
  Simplex[] initFaceDatabase(){
    Simplex[] faces = new Simplex[dim + 1];
    
    for(int i = 0; i < dim + 1; i++){
      Vertex[] vertices_ = getNotIth(vertices, i).toArray(new Vertex[vertices.size() - 1]);//skips the i-th vertex. oppsite simplex
      Simplex newFace = new Simplex(dim);
      Arrays.sort(vertices_, new VertexIdComparator());//to make vertices [0] different
      newFace.vertices = vertices_;
      
      calculateFacePlane(newFace);//Calculate normal, distance between origin and fast vertex. And flip the normal to point outward from centroid
      faces[i] = newFace;
    }
    //update the adjacency (check all pair of faces)
    for(int i = 0; i < dim; i++){
      for(int j = i + 1; j < dim + 1; j++){
        updateAdjacency(faces[i], faces[j]);//record adjacent face at oppsite vertex of the face
      }
    }
    return faces;
  }
  
  //Calculates the normal and offset of the hyper-plane given by the face's vertices.
  boolean calculateFacePlane(Simplex face){
    face.normal = calcNormal(face.vertices);
    
    if(Float.isNaN(face.normal[0])){
      return false;
    }
    
    float offset = 0;
    float centerDistance = 0;
    offset = faceDist(face.vertices[0].pos, face);//distance between origin and face
    centerDistance = faceDist(centroid, face);
    face.offset = -offset;
    centerDistance -= offset;
    
    if(centerDistance > 0){//flip normal
      face.normal = mult(face.normal, -1);
      face.offset = -face.offset;
      face.isNormalFlipped = true;
    }else face.isNormalFlipped = false;
    return true;//Finally, normal points outword from the centroid
  }
  
  void updateAdjacency(Simplex L, Simplex R){
    Vertex[] Lv = L.vertices;
    Vertex[] Rv = R.vertices;
    int i;
    //reset marks on the face
    L.setAllVerticesTag(0);
    R.setAllVerticesTag(1);
    
    //find the 1st vertex is not touching R
    for(i = 0; i < dim; i++) if(Lv[i].tag == 0) break;
    
    //all vertices were touching
    if(i == dim) return;
    
    //check if only 1 vertex wasn't touching bacause we'll get face oppsite 1 vertex
    for(int j = i + 1; j < dim; j++) if(Lv[j].tag == 0) return;
    
    //if we are here, the two faces share an edge
    L.adjacent[i] = R;
    
    //update the adj. face on the other face - find the vertex that remains marked
    L.setAllVerticesTag(0);
    for(i = 0; i < dim; i++){
      if(Rv[i].tag == 1) break;//because we'll get face oppsite 1 vertex
    }
    R.adjacent[i] = L;
  }
  
  //get vertices that positive side on face(same side as normal)
  void findBeyondVertices(Simplex face){
    face.clearBeyond();
    
    for(int i = 0; i < buffer.inputVertices.size(); i++)
      isBeyond(face, buffer.inputVertices.get(i));
  }
  
  //region PROCESS-----------------------------------------
  //tags all faces seem from the current vertex with 1
  void tagAffectedFaces(Simplex currentFace){//https://www.flickr.com/photos/187510519@N02/49677924438/in/album-72157713549835228/
    buffer.affectedFaces.clear();
    buffer.affectedFaces.add(currentFace);
    Deque<Simplex> traverseStack = new ArrayDeque<Simplex>();
    traverseStack.push(currentFace);
    currentFace.tag = 1;
    while(traverseStack.size() > 0){
      Simplex top = traverseStack.pop();
      
      for(int i = 0; i < dim; i++){
        Simplex adjFace = top.adjacent[i];
        
        if (adjFace == null) throw new NullPointerException("(2) Adjacent Face should never be null");
        //check adjacent face isn't contained affectedFace, And current vertex is positive side of adjacent face
        if(adjFace.tag == 0 && faceDist(buffer.currentVertex.pos, adjFace) >= EPSILON){
          buffer.affectedFaces.add(adjFace);
          adjFace.tag = 1;
          traverseStack.push(adjFace);
        }
      }
    }
  }
  
  boolean createCone(){
    int currentVertexIndex = buffer.currentVertex.id;
    buffer.coneFaces.clear();
    Simplex[] updateBuffer = new Simplex[dim];
    int[] updateIndices = new int[dim];
    //oldFaces = affectedFaces
    for(int fi = 0; fi < buffer.affectedFaces.size(); fi++){
      Simplex oldFace = buffer.affectedFaces.get(fi);
      
      //find the faces that need to be updated
      int updateCount = 0;
      for(int i = 0; i < dim; i++){
        Simplex af = oldFace.adjacent[i];
        
        if(af == null) throw new NullPointerException("(3) Adjacent Face should never be null");
        
        if(af.tag == 0){//tag == 0 when oldFaces does not coutain af
          updateBuffer[updateCount] = af;
          updateIndices[updateCount] = i;
          updateCount++;
        }
      }
      
      for(int i = 0; i < updateCount; i++){
        Simplex adjacentFace = updateBuffer[i];
        int oldFaceAdjacentIndex = 0;
        for(int j = 0; j < dim; j++){
          if(oldFace == adjacentFace.adjacent[j]){
            oldFaceAdjacentIndex = j;//adjFace join oldFace with edge oppsite j th vertex
            break;
          }
        }
        //index of the face that corresponds to this adjacent face
        int forbidden = updateIndices[i];
        
        Simplex newFace = new Simplex(dim);
        Vertex[] vertices_ = newFace.vertices;//refer
        for(int j = 0; j < dim; j++)//vertices.count = dimension - 1
          vertices_[j] = oldFace.vertices[j];
        
        int oldVertexIndex = vertices_[forbidden].id;
        
        int orderedPivotIndex;
        
        //correct the ordering for simplex connector
        if(currentVertexIndex < oldVertexIndex){
          orderedPivotIndex = 0;
          for(int j = forbidden - 1; j >= 0; j--){
            if(vertices_[j].id > currentVertexIndex) vertices_[j + 1] = vertices_[j];
            else{
              orderedPivotIndex = j + 1;
              break;
            }
          }
        }else{
          orderedPivotIndex = dim - 1;
          for(int j = forbidden + 1; j < dim; j++){
            if(vertices_[j].id < currentVertexIndex) vertices_[j - 1] = vertices_[j];
            else{
              orderedPivotIndex = j - 1;
              break;
            }
          }
        }
        
        vertices_[orderedPivotIndex] = buffer.currentVertex;
        
        if(!calculateFacePlane(newFace)){//calculate face data, and check illigal input
          return false;
        }
        
        buffer.coneFaces.add(new DeferredSimplex(newFace, orderedPivotIndex, adjacentFace, oldFaceAdjacentIndex, oldFace));
      }
    }
    return true;
  }
  
  //Commits a cone and adds a vertex to the convex hull.
  void commitCone(){
    //add the current vertex
    vertices.add(buffer.currentVertex);
    
    //fill the adjacency.
    for(int i = 0; i < buffer.coneFaces.size(); i++){
      DeferredSimplex face = buffer.coneFaces.get(i);
      
      Simplex newFace = face.face;
      Simplex adjacentFace = face.pivot;
      Simplex oldFace = face.oldFace;
      int orderedPivotIndex = face.faceIndex;
      
      newFace.adjacent[orderedPivotIndex] = adjacentFace;//set adjacent each other
      adjacentFace.adjacent[face.pivotIndex] = newFace;
      
      //let there be a connection
      for(int j = 0; j < dim; j++){
        if(j == orderedPivotIndex) continue;//because already set adjacent
        SimplexConnector connector = new SimplexConnector(newFace, j, dim);//connector is a class for searching the corresponding face at high speed with hash
        connectFace(connector);
      }
      
      //this could slightly help. Accelerate calculations by narrowing down choices
      if(adjacentFace.beyondVertices.size() < oldFace.beyondVertices.size()){
        findBeyondVertices(newFace, adjacentFace.beyondVertices, oldFace.beyondVertices);
      }else{
        findBeyondVertices(newFace, oldFace.beyondVertices, adjacentFace.beyondVertices);
      }
      
      //this face will definitely lie on the hull
      if(newFace.beyondVertices.size() == 0){
        simplexes.add(newFace);
        buffer.unprocessedFaces.remove(newFace);
        newFace.beyondVertices.clear();
      }else{//add the face to the list
        buffer.unprocessedFaces.add(newFace);
      }
    }
    
    //delete the affected faces.
    for(int fi = 0; fi < buffer.affectedFaces.size(); fi++){
      buffer.unprocessedFaces.remove(buffer.affectedFaces.get(fi));
    }
  }
  
  void connectFace(SimplexConnector connector){
    int index = connector.hashCode % buffer.connector_table_size;
    ArrayList<SimplexConnector> list = buffer.connectorTable[index];
    //check foreach connector
    for(int i = 0; i < list.size(); i++){
      SimplexConnector current = list.get(i);
      if(SimplexConnector.areConnectable(connector, current, dim)){
        list.remove(current);
        SimplexConnector.connect(current, connector);
        return;
      }
    }
    list.add(connector);
  }
  
  void findBeyondVertices(Simplex face, ArrayList<Vertex> beyond, ArrayList<Vertex> beyond1){
    face.clearBeyond();
    Vertex v;
    
    for(int i = 0; i < beyond1.size(); i++)
      beyond1.get(i).tag = 1;
      
    buffer.currentVertex.tag = 0;
    
    for(int i = 0; i < beyond.size(); i++){
      v = beyond.get(i);
      if(v == buffer.currentVertex) continue;
      v.tag = 0;//prevent duplicate check
      isBeyond(face, v);
    }
    
    for(int i = 0; i < beyond1.size(); i++){
      v = beyond1.get(i);
      if (v.tag == 1) isBeyond(face, v);
    }
  }
  
  void handleSingular(){
    rollbackCenter();
    buffer.singularVertices.add(buffer.currentVertex);
    
    //this means that all the affected faces must be on the hull and that all their "vertices beyond" are singular.
    for(int fi = 0; fi < buffer.affectedFaces.size(); fi++){
      Simplex face = buffer.affectedFaces.get(fi);
      ArrayList<Vertex> bv = face.beyondVertices;
      for(int i = 0; i < bv.size(); i++){
        buffer.singularVertices.add(bv.get(i));
      }
      
      simplexes.add(face);
      buffer.unprocessedFaces.remove(face);
      face.beyondVertices.clear();
    }
  }
  
  void isBeyond(Simplex face, Vertex v){
    float dist = faceDist(v.pos, face);
    
    if(dist >= EPSILON){
      if(dist > face.maxDist){
        face.maxDist = dist;
        face.furthestVertex = v;
      }
      face.beyondVertices.add(v);
    }
  }
  
  void updateCenter(){
    int count = vertices.size() + 1;
    centroid = mult(centroid, count - 1);
    centroid = div(add(centroid, buffer.currentVertex.pos), count);
  }
  
  void rollbackCenter(){
    int count = vertices.size() + 1;
    centroid = mult(centroid, count);
    centroid = div(sub(centroid, buffer.currentVertex.pos), count - 1);
  }
}