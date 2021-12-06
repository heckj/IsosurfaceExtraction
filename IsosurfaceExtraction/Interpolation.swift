//
//  Interpolation.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 12/6/21.
//

import Foundation

/// Linear Interpolation of Double values.
///
/// Precise method, which guarantees v = v1 when t = 1. This method is monotonic only when `v0 * v1 < 0`.
/// Linear interpolation between same values might not produce the same value.
/// Sourced from https://en.wikipedia.org/wiki/Linear_interpolation.
/// - Parameters:
///   - v0: The first boundary value for the interpolation.
///   - v1: The second boundary value for the interpolation.
///   - t: A value between `0` and `1.0` to use to produce an interpolated value.
/// - Returns: The interpolated value at the position provided between two boundary values.
public func lerp(input0 v0: Double, input1 v1: Double, parameter t: Double) -> Double {
    return (1 - t) * v0 + t * v1
    
    
}

/// Determines a normalized offset value for linear interpolation from two values on either side of 0, with 0 being the point to interpolate towards.
/// The provided values are required to have opposite signs (one negative, one positive) in order to use 0 as the marker for the interpolation direction.
/// - Parameters:
///   - f0: The first value.
///   - f1: The second value.
/// - Returns: An offset value between 0 and 1.0 that indicates the relative distance of 0 to the first of the provided points.
public func normalizedOffset(_ f0: Double, _ f1: Double) -> Double {
    let verifiedOppositeSigns = (f0 > 0) != (f1 > 0)
    precondition(verifiedOppositeSigns, "The values being interpolated (\(f0), and \(f1) aren't opposite signs.")
    return (0 - f0) / (f1 - f0)
}
