void FlipTriangleEdge(HalfEdge e)
{
    //The data we need
    //This edge's triangle edges
    HalfEdge e_1 = e;
    HalfEdge e_2 = e_1.nextEdge;
    HalfEdge e_3 = e_1.prevEdge;
    //The opposite edge's triangle edges
    HalfEdge e_4 = e_1.oppositeEdge;
    HalfEdge e_5 = e_4.nextEdge;
    HalfEdge e_6 = e_4.prevEdge;
    //The 4 vertex positions
    float[] aPos = e_1.v.pos;
    float[] bPos = e_2.v.pos;
    float[] cPos = e_3.v.pos;
    float[] dPos = e_5.v.pos;

    //The 6 old vertices, we can use
    HEVertex a_old = e_1.v;
    HEVertex b_old = e_1.nextEdge.v;
    HEVertex c_old = e_1.prevEdge.v;
    HEVertex a_opposite_old = e_4.prevEdge.v;
    HEVertex c_opposite_old = e_4.v;
    HEVertex d_old = e_4.nextEdge.v;

    //Flip

    //Vertices
    //Triangle 1: b-c-d
    HEVertex b = b_old;
    HEVertex c = c_old;
    HEVertex d = d_old;
    //Triangle 1: b-d-a
    HEVertex b_opposite = a_opposite_old;
    b_opposite.pos = bPos;
    HEVertex d_opposite = c_opposite_old;
    d_opposite.pos = dPos;
    HEVertex a = a_old;


    //Change half-edge - half-edge connections
    e_1.nextEdge = e_3;
    e_1.prevEdge = e_5;

    e_2.nextEdge = e_4;
    e_2.prevEdge = e_6;

    e_3.nextEdge = e_5;
    e_3.prevEdge = e_1;

    e_4.nextEdge = e_6;
    e_4.prevEdge = e_2;

    e_5.nextEdge = e_1;
    e_5.prevEdge = e_3;

    e_6.nextEdge = e_2;
    e_6.prevEdge = e_4;

    //Half-edge - vertex connection
    e_1.v = b;
    e_2.v = b_opposite;
    e_3.v = c;
    e_4.v = d_opposite;
    e_5.v = d;
    e_6.v = a;

    //Half-edge - face connection
    HEFace f1 = e_1.face;
    HEFace f2 = e_4.face;

    e_1.face = f1;
    e_3.face = f1;
    e_5.face = f1;

    e_2.face = f2;
    e_4.face = f2;
    e_6.face = f2;

    //Face - half-edge connection
    f1.edge = e_3;
    f2.edge = e_4;

    //Vertices connection, which should have a reference to a half-edge going away from the vertex
    //Triangle 1: b-c-d
    b.edge = e_3;
    c.edge = e_5;
    d.edge = e_1;
    //Triangle 1: b-d-a
    b_opposite.edge = e_4;
    d_opposite.edge = e_6;
    a.edge = e_2;

    //Opposite-edges are not changing!
    //And neither are we adding, removing data so we dont need to update the lists with all data
}
