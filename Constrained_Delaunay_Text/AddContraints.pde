import java.util.ArrayDeque;
import java.util.Queue;

HEData AddConstraints(HEData triangleData, ArrayList<float[]> constraints, boolean shouldRemoveTriangles){
  ArrayList<HalfEdge> uniqueEdges = triangleData.GetUniqueEdges();
  for (int i=0; i<constraints.size(); i++) {
    float[] c_p1 = constraints.get(i);
    float[] c_p2 = constraints.get((i+1)%constraints.size());
    
    if (IsEdgeInListOfEdges(uniqueEdges, c_p1, c_p2))
    {
        continue;
    }
    
    Queue<HalfEdge> intersectingEdges = FindIntersectingEdges_BruteForce(uniqueEdges, c_p1, c_p2);
    ArrayList<HalfEdge> newEdges = RemoveIntersectingEdges(c_p1, c_p2, intersectingEdges);
    
    //Step 4. Try to restore delaunay triangulation 
    //Because we have constraints we will never get a delaunay triangulation
    RestoreDelaunayTriangulation(c_p1, c_p2, newEdges);
  }
  if (shouldRemoveTriangles)
  {
      RemoveSuperfluousTriangles(triangleData, constraints);
  }
  
  return triangleData;
}

//Is an edge between p1 and p2 a constraint?
boolean IsEdgeAConstraint(float[] p1, float[] p2, List<float[]> constraints)
{
  for (int i = 0; i < constraints.size(); i++)
  {
    float[] c_p1 = constraints.get(i);
    float[] c_p2 = constraints.get((i + 1)%constraints.size());

    if (AreTwoEdgesTheSame(p1, p2, c_p1, c_p2))
    {
      return true;
    }
  }

  return false;
}

//
// Remove all triangles that are inside the constraint
//

//This assumes the vertices in the constraint are ordered clockwise
void RemoveSuperfluousTriangles(HEData triangleData, ArrayList<float[]> constraints)
{
  //This assumes we have at least 3 vertices in the constraint because we cant delete triangles inside a line
  if (constraints.size() < 3)
  {
      return;
  }

  ArrayList<HEFace> trianglesToBeDeleted = FindTrianglesWithinConstraint(triangleData, constraints);

  //Delete the triangles
  for (HEFace t : trianglesToBeDeleted)
  {
    DeleteTriangleFace(t, triangleData, true);
  }
}

ArrayList<HalfEdge> RemoveIntersectingEdges(float[] v_i, float[] v_j, Queue<HalfEdge> intersectingEdges)
{
  ArrayList<HalfEdge> newEdges = new ArrayList<HalfEdge>();

  int safety = 0;

  //While some edges still cross the constrained edge, do steps 3.1 and 3.2
  while (intersectingEdges.size() > 0)
  {
    safety += 1;

    if (safety > 100000)
    {
        println("Stuck in infinite loop when fixing constrained edges");
        break;
    }

    //Step 3.1. Remove an edge from the list of edges that intersects the constrained edge
    HalfEdge e = intersectingEdges.poll();

    //The vertices belonging to the two triangles
    float[] v_k = e.v.pos;
    float[] v_l = e.prevEdge.v.pos;
    float[] v_3rd = e.nextEdge.v.pos;
    //The vertex belonging to the opposite triangle and isn't shared by the current edge
    float[] v_opposite_pos = e.oppositeEdge.nextEdge.v.pos;

    //Step 3.2. If the two triangles don't form a convex quadtrilateral
    //place the edge back on the list of intersecting edges (because this edge cant be flipped) 
    //and go to step 3.1
    if (!IsQuadrilateralConvex(v_k, v_l, v_3rd, v_opposite_pos))
    {
      intersectingEdges.add(e);
      continue;
    }
    else
    {
      //Flip the edge like we did when we created the delaunay triangulation
      FlipTriangleEdge(e);

      //The new diagonal is defined by the vertices
      float[] v_m = e.v.pos;
      float[] v_n = e.prevEdge.v.pos;

      //If this new diagonal intersects with the constrained edge, add it to the list of intersecting edges
      if (IsCrossingEdge(v_i, v_j, v_m, v_n))
      {
          intersectingEdges.add(e);
      }
      //Place it in the list of newly created edges
      else
      {
          newEdges.add(e);
      }
    }
  }

  return newEdges;
}

//
// Try to restore the delaunay triangulation by flipping newly created edges
//

//This process is similar to when we created the original delaunay triangulation
//This step can maybe be skipped if you just want a triangulation and Ive noticed its often not flipping any triangles
void RestoreDelaunayTriangulation(float[] c_p1, float[] c_p2, ArrayList<HalfEdge> newEdges)
{
  int safety = 0;

  int flippedEdges = 0;

  //Repeat 4.1 - 4.3 until no further swaps take place
  while (true)
  {
    safety += 1;

    if (safety > 100000)
    {
      println("Stuck in endless loop when delaunay after fixing constrained edges");

      break;
    }

    boolean hasFlippedEdge = false;

    //Step 4.1. Loop over each edge in the list of newly created edges
    for (int j = 0; j < newEdges.size(); j++)
    {
      HalfEdge e = newEdges.get(j);

      //Step 4.2. Let the newly created edge be defined by the vertices
      float[] v_k = e.v.pos;
      float[] v_l = e.prevEdge.v.pos;

      //If this edge is equal to the constrained edge, then skip to step 4.1
      //because we are not allowed to flip a constrained edge
      if ((equal(v_k, c_p1) && equal(v_l, c_p2)) || (equal(v_l, c_p1) && equal(v_k, c_p2)))
      {
        continue;
      }

      //Step 4.3. If the two triangles that share edge v_k and v_l don't satisfy the delaunay criterion,
      //so that a vertex of one of the triangles is inside the circumcircle of the other triangle, flip the edge
      //The third vertex of the triangle belonging to this edge
      float[] v_third_pos = e.nextEdge.v.pos;
      //The vertice belonging to the triangle on the opposite side of the edge and this vertex is not a part of the edge
      float[] v_opposite_pos = e.oppositeEdge.nextEdge.v.pos;

      //Test if we should flip this edge
      if (ShouldFlipEdge(v_l, v_k, v_third_pos, v_opposite_pos))
      {
        //Flip the edge
        hasFlippedEdge = true;

        FlipTriangleEdge(e);

        flippedEdges += 1;
      }
    }

    //We have searched through all edges and havent found an edge to flip, so we cant improve anymore
    if (!hasFlippedEdge)
    {
      println("Found a constrained delaunay triangulation in " + flippedEdges + " flips");

      break;
    }
  }
}

Queue<HalfEdge> FindIntersectingEdges_BruteForce(List<HalfEdge> uniqueEdges, float[] c_p1, float[] c_p2)
{
    //Should be in a queue because we will later plop the first in the queue and add edges in the back of the queue 
    Queue<HalfEdge> intersectingEdges = new ArrayDeque<HalfEdge>();

    //Loop through all edges and see if they are intersecting with the constrained edge
    for (int i = 0; i < uniqueEdges.size(); i++)
    {
        //The edges the triangle consists of
        HalfEdge e = uniqueEdges.get(i);

        //The position the edge is going to
        float[] e_p1 = e.v.pos;
        //The position the edge is coming from
        float[] e_p2 = e.prevEdge.v.pos;

        //Is this edge intersecting with the constraint?
        if (IsCrossingEdge(e_p1, e_p2, c_p1, c_p2))
        {
            //If so add it to the queue of edges
            intersectingEdges.add(e);
        }
    }

    return intersectingEdges;
}

ArrayList<HEFace> FindTrianglesWithinConstraint(HEData triangleData, ArrayList<float[]> constraints)
{
  ArrayList<HEFace> trianglesToDelete = new ArrayList<HEFace>();


  //Step 1. Find a triangle with an edge that shares an edge with the first constraint edge in the list 
  //Since both are clockwise we know we are "inside" of the constraint, so this is a triangle we should delete
  HEFace borderTriangle = null;

  float[] c_p1 = constraints.get(0);
  float[] c_p2 = constraints.get(1);

  //Search through all triangles
  for (HEFace t : triangleData.faces)
  {
    //The edges in this triangle
    HalfEdge e1 = t.edge;
    HalfEdge e2 = e1.nextEdge;
    HalfEdge e3 = e2.nextEdge;

    //Is any of these edges a constraint? If so we have find the first triangle
    if (equal(e1.v.pos, c_p2) && equal(e1.prevEdge.v.pos, c_p1))
    {
        borderTriangle = t;

        break;
    }
    if (equal(e2.v.pos, c_p2) && equal(e2.prevEdge.v.pos, c_p1))
    {
        borderTriangle = t;

        break;
    }
    if (equal(e3.v.pos, c_p2) && equal(e3.prevEdge.v.pos, c_p1))
    {
        borderTriangle = t;

        break;
    }
  }

  if (borderTriangle == null)
  {
    return null;
  }



  //Step 2. Find the rest of the triangles within the constraint by using a flood fill algorithm
  
  //Maybe better to first find all the other border triangles?

  //We know this triangle should be deleted
  trianglesToDelete.add(borderTriangle);

  //Store the triangles we flood filling in this queue
  Queue<HEFace> trianglesToCheck = new ArrayDeque<HEFace>();

  //Start at the triangle we know is within the constraints
  trianglesToCheck.add(borderTriangle);

  int safety = 0;

  while (true)
  {
    safety += 1;

    if (safety > 100000)
    {
        println("Stuck in infinite loop when looking for triangles within constraint");

        break;
    }

    //Stop if we are out of neighbors
    if (trianglesToCheck.size() == 0)
    {
        break;
    }

    //Pick the first triangle in the list and investigate its neighbors
    HEFace t = trianglesToCheck.poll();

    //Investigate the triangles on the opposite sides of these edges
    HalfEdge e1 = t.edge;
    HalfEdge e2 = e1.nextEdge;
    HalfEdge e3 = e2.nextEdge;

    //A triangle is a neighbor within the constraint if:
    //- The neighbor is not an outer border meaning no neighbor exists
    //- If we have not already visited the neighbor
    //- If the edge between the neighbor and this triangle is not a constraint
    if (e1.oppositeEdge != null &&
        !trianglesToDelete.contains(e1.oppositeEdge.face) &&
        !trianglesToCheck.contains(e1.oppositeEdge.face) &&
        !IsEdgeAConstraint(e1.v.pos, e1.prevEdge.v.pos, constraints))//not to search beyond constraint
    {
        trianglesToCheck.add(e1.oppositeEdge.face);

        trianglesToDelete.add(e1.oppositeEdge.face);
    }
    if (e2.oppositeEdge != null &&
        !trianglesToDelete.contains(e2.oppositeEdge.face) &&
        !trianglesToCheck.contains(e2.oppositeEdge.face) &&
        !IsEdgeAConstraint(e2.v.pos, e2.prevEdge.v.pos, constraints))
    {
        trianglesToCheck.add(e2.oppositeEdge.face);

        trianglesToDelete.add(e2.oppositeEdge.face);
    }
    if (e3.oppositeEdge != null &&
        !trianglesToDelete.contains(e3.oppositeEdge.face) &&
        !trianglesToCheck.contains(e3.oppositeEdge.face) &&
        !IsEdgeAConstraint(e3.v.pos, e3.prevEdge.v.pos, constraints))
    {
        trianglesToCheck.add(e3.oppositeEdge.face);

        trianglesToDelete.add(e3.oppositeEdge.face);
    }
  }

  return trianglesToDelete;
}

void DeleteTriangleFace(HEFace t, HEData data, boolean shouldSetOppositeToNull)
{
  //Update the data structure
  //In the half-edge data structure there's an edge going in the opposite direction
  //on the other side of this triangle with a reference to this edge, so we have to set these to null
  HalfEdge t_e1 = t.edge;
  HalfEdge t_e2 = t_e1.nextEdge;
  HalfEdge t_e3 = t_e2.nextEdge;

  //If we want to remove the triangle and create a hole
  //But sometimes we have created a new triangle and then we cant set the opposite to null
  if (shouldSetOppositeToNull)
  {
    if (t_e1.oppositeEdge != null)
    {
      t_e1.oppositeEdge.oppositeEdge = null;
    }
    if (t_e2.oppositeEdge != null)
    {
      t_e2.oppositeEdge.oppositeEdge = null;
    }
    if (t_e3.oppositeEdge != null)
    {
      t_e3.oppositeEdge.oppositeEdge = null;
    }
  }


  //Remove from the data structure

  //Remove from the list of all triangles
  data.faces.remove(t);

  //Remove the edges from the list of all edges
  data.edges.remove(t_e1);
  data.edges.remove(t_e2);
  data.edges.remove(t_e3);

  //Remove the vertices
  data.vertices.remove(t_e1.v);
  data.vertices.remove(t_e2.v);
  data.vertices.remove(t_e3.v);
}
