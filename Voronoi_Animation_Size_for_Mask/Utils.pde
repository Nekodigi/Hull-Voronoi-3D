import java.util.Comparator;

float[][] extractPos(Vertex ... vertices){
  float[][] result = new float[vertices.length][];
  for(int i = 0; i < vertices.length; i++){
    result[i] = vertices[i].pos;
  }
  return result;
}

ArrayList<Vertex> getNotIth(ArrayList<Vertex> vs, int i){
  ArrayList<Vertex> result = new ArrayList<Vertex>();
  for(int j = 0; j < vs.size(); j++){
    if(j == i){continue;}
    result.add(vs.get(j));
  }
  return result;
}

Simplex[] getAdjHasVertex(Simplex simplex, Vertex v){
  Simplex[] result = new Simplex[simplex.adjacent.length-1];
  for(int j = 0, k = 0; j < simplex.adjacent.length; j++){
    if(simplex.adjacent[j] != null && hasItem(v, simplex.adjacent[j].vertices)){
      result[k++] = simplex.adjacent[j];
    }else continue;
  }
  return result;
}

class VertexIdComparator implements Comparator<Vertex> {
  @Override
  public int compare(Vertex a, Vertex b) {
    return a.id - b.id;
  }
}

boolean hasItem(Vertex v, Vertex[] vertices){
  for(Vertex v_ : vertices){
    if(v_ == v)return true;
  }
  return false;
}

float[] sphereSampling(float u, float theta){//https://mathworld.wolfram.com/SpherePointPicking.html
  float x = sqrt(1-u*u)*cos(theta);
  float y = sqrt(1-u*u)*sin(theta);
  float[] result = {x, y, u};
  return result;
}

ArrayList<Polygon> simplex2Poly(ArrayList<Simplex> simplexes){
  ArrayList<Polygon> result = new ArrayList<Polygon>();
  for(Simplex simplex : simplexes){
    result.add(new Polygon(simplex));
  }
  return result;
}

float lineDistL(PVector c, PVector a, PVector b) {
  PVector ap = PVector.sub(c, a);
  PVector ab = PVector.sub(b, a);
  float l = PVector.dist(a, b);
  ab.normalize(); // Normalize the line
  float scala = ap.dot(ab);
    ab.mult(scala);
    PVector normalPoint = PVector.add(a, ab);
    return PVector.dist(c, normalPoint);
}

float lineDist(PVector c, PVector a, PVector b) {
  PVector ap = PVector.sub(c, a);
  PVector ab = PVector.sub(b, a);
  float l = PVector.dist(a, b);
  ab.normalize(); // Normalize the line
  float scala = ap.dot(ab);
  if(scala <= 0){
    return PVector.dist(c, a);
  }else if(scala >= l){
    return PVector.dist(c, b);
  }
  else{
    ab.mult(scala);
    PVector normalPoint = PVector.add(a, ab);
    return PVector.dist(c, normalPoint);
  }
}

PVector intersection(PVector p1s, PVector p1e, PVector p2s, PVector p2e) {
  float x1 = p1s.x;float y1 = p1s.y;
  float x2 = p1e.x;float y2 = p1e.y;
  float x3 = p2s.x;float y3 = p2s.y;
  float x4 = p2e.x;float y4 = p2e.y;
  float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  if (den == 0) {
    return null;
  }
  
  float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
  float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;
  if (t > 0 && t < 1 && u > 0) {
    PVector pt = new PVector();
    pt.x = x1 + t * (x2 - x1);
    pt.y = y1 + t * (y2 - y1);
    return pt;
  } else {
    return null;
  }
}

 //
    // Is a point intersecting with a polygon?
    //
    //The list describing the polygon has to be sorted either clockwise or counter-clockwise because we have to identify its edges
    //TODO: May sometimes fail because of floating point precision issues
    public static boolean PointPolygon(ArrayList<PVector> polygonPoints, PVector point)
    {
    //Step 1. Find a point outside of the polygon
    //Pick a point with a x position larger than the polygons max x position, which is always outside
    PVector maxXPosVertex = polygonPoints.get(0);

    for (int i = 1; i < polygonPoints.size(); i++)
    {
        if (polygonPoints.get(i).x > maxXPosVertex.x)
        {
            maxXPosVertex = polygonPoints.get(i);
        }
    }

    //The point should be outside so just pick a number to move it outside
    //Should also move it up a little to minimize floating point precision issues
    //This is where it fails if this line is exactly on a vertex
    PVector pointOutside = PVector.add(maxXPosVertex, new PVector(1f, 0.01f));


    //Step 2. Create an edge between the point we want to test with the point thats outside
    PVector l1_p1 = point;
    PVector l1_p2 = pointOutside;

    //Debug.DrawLine(l1_p1.XYZ(), l1_p2.XYZ());


    //Step 3. Find out how many edges of the polygon this edge is intersecting with
    int numberOfIntersections = 0;

    for (int i = 0; i < polygonPoints.size(); i++)
    {
        //Line 2
        PVector l2_p1 = polygonPoints.get(i);

        int iPlusOne = ClampListIndex(i + 1, polygonPoints.size());

        PVector l2_p2 = polygonPoints.get(iPlusOne);

        //Are the lines intersecting?
        if (_Intersections.LineLine(l1_p1, l1_p2, l2_p1, l2_p2, true))
        {
            numberOfIntersections += 1;
        }
    }


    //Step 4. Is the point inside or outside?
    boolean isInside = true;

    //The point is outside the polygon if number of intersections is even or 0
    if (numberOfIntersections == 0 || numberOfIntersections % 2 == 0)
    {
        isInside = false;
    }

    return isInside;
    }
    
    //Clamp list indices
  //Will even work if index is larger/smaller than listSize, so can loop multiple times
  public static int ClampListIndex(int index, int listSize)
  {
      index = ((index % listSize) + listSize) % listSize;

      return index;
  }
