import java.util.HashSet;
import java.util.List;

class ObjectBuffer{
  int connector_table_size = 2017;
  ArrayList[] connectorTable = new ArrayList[connector_table_size];
  int dim;
  Vertex currentVertex;
  List<Vertex> inputVertices = new ArrayList<Vertex>();
  float maxDist = Float.NEGATIVE_INFINITY;
  Vertex furthestVertex;
  ArrayList<Simplex> unprocessedFaces = new ArrayList<Simplex>();
  //To detect invalid input in advance and reduce processing
  ArrayList<Vertex> singularVertices = new ArrayList<Vertex>();
  //faces that need to be change
  ArrayList<Simplex> affectedFaces = new ArrayList<Simplex>();
  //To store unconfirmed cone face data
  ArrayList<DeferredSimplex> coneFaces = new ArrayList<DeferredSimplex>();
  
  ObjectBuffer(int dim){
    this.dim = dim;
    for(int i = 0; i < connector_table_size; i++){
      connectorTable[i] = new ArrayList<SimplexConnector>();
    }
  }
  
  void addInput(ArrayList<Vertex> input, boolean assignIds, boolean checkInput){
    inputVertices = new ArrayList<Vertex>(input);
    
    if(assignIds){
      for(int i = 0; i < input.size(); i++){
        inputVertices.get(i).id = i;
      }
    }
    
    //Check for duplicates
    if(checkInput){
      HashSet<Integer> set = new HashSet<Integer>();

      for (int i = 0; i < input.size(); i++)
      {
        if (input.get(i) == null) throw new IllegalArgumentException("Input has a null vertex");
        if (input.get(i).dim != dim) throw new IllegalArgumentException("Input vertex is not the correct dimension"+input.get(i).dim);
        if (set.contains(input.get(i).id)) throw new IllegalArgumentException("Input vertex id is not unique"+input.get(i).id);
        else set.add(input.get(i).id);
      }
    }
  }
}

class DeferredSimplex{
  Simplex face;
  Simplex pivot;
  Simplex oldFace;
  int faceIndex;
  int pivotIndex;
  
  DeferredSimplex(Simplex face, int faceIndex, Simplex pivot, int pivotIndex, Simplex oldFace){
    this.face = face;
    this.faceIndex = faceIndex;
    this.pivot = pivot;
    this.pivotIndex = pivotIndex;
    this.oldFace = oldFace;
  }
}