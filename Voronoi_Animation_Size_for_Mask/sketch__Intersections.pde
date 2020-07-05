public static class _Intersections
{
    //
    // Are two lines intersecting?
    //
    //http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    //Notice that there are more than one way to test if two line segments are intersecting
    //but this is the fastest according to https://www.habrador.com/tutorials/math/5-line-line-intersection/
    public static boolean LineLine(PVector l1_p1, PVector l1_p2, PVector l2_p1, PVector l2_p2, boolean shouldIncludeEndPoints)
    {
        //To avoid floating point precision issues we can use a small value
        float epsilon = EPSILON;

        boolean isIntersecting = false;

        float denominator = (l2_p2.y - l2_p1.y) * (l1_p2.x - l1_p1.x) - (l2_p2.x - l2_p1.x) * (l1_p2.y - l1_p1.y);

        //Make sure the denominator is > 0, if so the lines are parallel
        if (denominator != 0f)
        {
            float u_a = ((l2_p2.x - l2_p1.x) * (l1_p1.y - l2_p1.y) - (l2_p2.y - l2_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;
            float u_b = ((l1_p2.x - l1_p1.x) * (l1_p1.y - l2_p1.y) - (l1_p2.y - l1_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;

            //Are the line segments intersecting if the end points are the same
            if (shouldIncludeEndPoints)
            {
                //Is intersecting if u_a and u_b are between 0 and 1 or exactly 0 or 1
                if (u_a >= 0f + epsilon && u_a <= 1f - epsilon && u_b >= 0f + epsilon && u_b <= 1f - epsilon)
                {
                    isIntersecting = true;
                }
            }
            else
            {
                //Is intersecting if u_a and u_b are between 0 and 1
                if (u_a > 0f + epsilon && u_a < 1f - epsilon && u_b > 0f + epsilon && u_b < 1f - epsilon)
                {
                    isIntersecting = true;
                }
            }

        }

        return isIntersecting;
    }



    //Whats the coordinate of an intersection point between two lines in 2d space if we know they are intersecting
    //http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    public static PVector GetLineLineIntersectionPoint(PVector l1_p1, PVector l1_p2, PVector l2_p1, PVector l2_p2)
    {
        float denominator = (l2_p2.y - l2_p1.y) * (l1_p2.x - l1_p1.x) - (l2_p2.x - l2_p1.x) * (l1_p2.y - l1_p1.y);

        float u_a = ((l2_p2.x - l2_p1.x) * (l1_p1.y - l2_p1.y) - (l2_p2.y - l2_p1.y) * (l1_p1.x - l2_p1.x)) / denominator;

        PVector intersectionPoint = PVector.add(l1_p1, PVector.mult((PVector.sub(l1_p2, l1_p1)), u_a));

        return intersectionPoint;
    }
}
