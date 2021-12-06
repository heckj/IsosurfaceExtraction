//
//  SampleData.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 12/6/21.
//

import Foundation

struct exampleData: IsoSurfaceDataSource {
    func isovalue(x: Double, y: Double, z: Double) -> Double {
        return 2.5 - sqrt(x*x + y*y + z*z)
    }
}
