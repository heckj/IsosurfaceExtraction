//
//  IsosurfaceExtractionTests.swift
//  IsosurfaceExtractionTests
//
//  Created by Joseph Heck on 12/1/21.
//

import XCTest
import Euclid
@testable import IsosurfaceExtraction


class MarchingCubesTests: XCTestCase {

    func testLerp1() throws {
        let result = lerp(input0: 0, input1: 1, parameter: 0.5)
        XCTAssertEqual(0.5, result, accuracy: 0.001)
    }
    
    func testLerp2() throws {
        let result = lerp(input0: 0, input1: 1, parameter: 0.999)
        XCTAssertEqual(0.999, result, accuracy: 0.001)
    }

    func testEuclidBoundsSummary() throws {
        let bounds = Euclid.Bounds()
        XCTAssertEqual(bounds.summary,
                       "X[inf…-inf], Y[inf…-inf], Y[inf…-inf]")
    }
    
    func testWorkit() throws {
        marching_cubes(data: IsosurfaceExtraction.exampleData() as IsoSurfaceDataSource)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
