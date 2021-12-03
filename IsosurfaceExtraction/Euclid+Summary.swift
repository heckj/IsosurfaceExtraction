//
//  Euclid+Summary.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 12/2/21.
//

import Foundation
import Euclid

/// Converts a boolean value into a checkmark or cross-out symbol for a compact text representation.
/// - Parameter value: the value to be compared
/// - Returns: a string with a value of ✔ if true; otherwise ✗
public func check(_ value: Bool) -> String {
    value ? "✔" : "✗"
}

extension Euclid.Bounds {
    
    /// Returns a summary description of the bounds in textual form.
    ///
    /// For example, a default Bounds instance has infinite bounds:
    /// ```
    /// let example = Bounds()
    /// bounds.summary
    /// // X[inf…-inf], Y[inf…-inf], Y[inf…-inf]
    /// ```
    var summary: String {
        get {
            return "X[\(self.min.x)…\(self.max.x)], Y[\(self.min.y)…\(self.max.y)], Y[\(self.min.z)…\(self.max.z)]"
        }
    }
}

extension Euclid.Mesh {
    
    /// Returns a summary description of the bounds in textual form.
    ///
    /// For example, a default Bounds instance has infinite bounds:
    /// ```
    /// let example = Mesh([])
    /// example.summary
    /// // X[inf…-inf], Y[inf…-inf], Y[inf…-inf]
    /// ```
    var summary: String {
        get {
            "polys: \(self.polygons.count) in \(self.bounds.summary), watertight? \(check(self.isWatertight))"
        }
    }
}

extension Euclid.Polygon {
    var summary: String {
        get {
            "vertices: \(self.vertices.count) in \(self.bounds.summary), convex? \(check(self.isConvex))"
        }
    }
}

extension Euclid.Vector {
    var summary: String {
        get {
            " [\(self.x),\(self.y),\(self.z)] "
        }
    }
}
