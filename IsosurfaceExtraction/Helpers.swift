import Foundation

/* Paul Bourke's original C code

// Linearly interpolate the position where an isosurface cuts
// an edge between two vertices, each with their own scalar value
 
 XYZ VertexInterp(isolevel,p1,p2,valp1,valp2)
 double isolevel;
 XYZ p1,p2;
 double valp1,valp2;
 {
    double mu;
    XYZ p;

    if (ABS(isolevel-valp1) < 0.00001)
       return(p1);
    if (ABS(isolevel-valp2) < 0.00001)
       return(p2);
    if (ABS(valp1-valp2) < 0.00001)
       return(p1);
    mu = (isolevel - valp1) / (valp2 - valp1);
    p.x = p1.x + mu * (p2.x - p1.x);
    p.y = p1.y + mu * (p2.y - p1.y);
    p.z = p1.z + mu * (p2.z - p1.z);

    return(p);
 }

 */


/* Imprecise
public func lerp(a: Float, b: Float, t: Float) -> Float {
    
    return a + ( b - a ) * t;
}
*/

// Lerping (linear interpolation) for ...
// https://en.wikipedia.org/wiki/Linear_interpolation
public func lerp(input0 v0: Float, input1 v1: Float, parameter t: Float) -> Float {
    
    return (1 - t) * v0 + t * v1
}
