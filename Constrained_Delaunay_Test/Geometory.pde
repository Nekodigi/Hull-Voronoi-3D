//pre check
boolean isIntersect(float[] s1, float[] e1, float[] s2, float[] e2){
  float det0 = (e1[0] - s1[0])*(s2[1] - e1[1]) - (e1[1] - s1[1])*(s2[0] - e1[0]);
  float det1 = (e1[0] - s1[0])*(e2[1] - e1[1]) - (e1[1] - s1[1])*(e2[0] - e1[0]);
  return det0<0 && det1>=0 || det0>=0&&det1<0;
}

PVector intersection(float[] p1s, float[] p1e, float[] p2s, float[] p2e, boolean check) {
  if(check && !isIntersect(p1s, p1e, p2s, p2e))return null;
  float x1 = p1s[0];float y1 = p1s[1];
  float x2 = p1e[0];float y2 = p1e[1];
  float x3 = p2s[0];float y3 = p2s[1];
  float x4 = p2e[0];float y4 = p2e[1];
  //float vx1 = x1 - x2;float vy1 = y1 - y2;
  //float vx2 = x3 - x4;float vy2 = y3 - y4;
  float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  //float den = vx1 * vy2 - vy1 * vx2;
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
  //return intersectionV2(p1s, p1s.sub(p1e), p2s, p2s.sub(p2e));
}
//is edge clossing edge
boolean IsCrossingEdge(float[] s1, float[] e1, float[] s2, float[] e2){
  if(equal(s1, s2) || equal(s1, e2) || equal(e1, s2) || equal(e1, e2))return false;
  return intersection(s1, e1, s2, e2, true) != null;
}

boolean IsQuadrilateralConvex(float[] a, float[] b, float[] c, float[] d)
{
  boolean isConvex = false;

  //Convex if the convex hull includes all 4 points - will require just 4 determinant operations
  //In this case we dont kneed to know the order of the points, which is better
  //We could split it up into triangles, but still messy because of interior/exterior angles
  //Another version is if we know the edge between the triangles that form a quadrilateral
  //then we could measure the 4 angles of the edge, add them together (2 and 2) to get the interior angle
  //But it will still require 8 magnitude operations which is slow
  //From: https://stackoverflow.com/questions/2122305/convex-hull-of-4-points
  boolean abc = IsTriangleOrientedClockwise(a, b, c);
  boolean abd = IsTriangleOrientedClockwise(a, b, d);
  boolean bcd = IsTriangleOrientedClockwise(b, c, d);
  boolean cad = IsTriangleOrientedClockwise(c, a, d);

  if (abc && abd && bcd & !cad)
  {
      isConvex = true;
  }
  else if (abc && abd && !bcd & cad)
  {
      isConvex = true;
  }
  else if (abc && !abd && bcd & cad)
  {
      isConvex = true;
  }
  //The opposite sign, which makes everything inverted
  else if (!abc && !abd && !bcd & cad)
  {
      isConvex = true;
  }
  else if (!abc && !abd && bcd & !cad)
  {
      isConvex = true;
  }
  else if (!abc && abd && !bcd & !cad)
  {
      isConvex = true;
  }


  return isConvex;
}

boolean IsTriangleOrientedClockwise(float[] p1, float[] p2, float[] p3){
  boolean isClockWise = true;

  float determinant = p1[0] * p2[1] + p3[0] * p1[1] + p2[0] * p3[1] - p1[0] * p3[1] - p3[0] * p2[1] - p2[0] * p1[1];

  if (determinant > 0f)
  {
    isClockWise = false;
  }

  return isClockWise;
}
