//
//  IsoSurfaceDataSource.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 12/6/21.
//

import Foundation

/// A protocol that provides a consistent interface to retrieve density values for isosurface extraction.
public protocol IsoSurfaceDataSource {
    func isovalue(x: Double, y: Double, z:Double) -> Double;
}

