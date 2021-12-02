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

    func testEuclidMeshSummary() throws {
        let mesh = Euclid.Mesh([])
        XCTAssertEqual(mesh.summary,
                       "polys: 0 in X[inf…-inf], Y[inf…-inf], Y[inf…-inf], watertight? ✔")
    }
    
    func testVoxelEvaluation0_0_0() {
        print(" =============== testVoxelEvaluation 0,0,0")
        let sample: IsoSurfaceDataSource = IsosurfaceExtraction.exampleData()
        let x = marching_cubes_single_cell(data: sample, x: 0.0, y: 0.0, z: 0.0, material: UIColor.red, homeworkMode: true)
        XCTAssertEqual(x.polygons.count, 1)
        // print(" = " + x.summary)
        print(" =============== testVoxelEvaluation 0,0,0")
    }
    
    func testVoxelEvaluation0_0_1() {
        print(" = 0,0,1")
        let sample: IsoSurfaceDataSource = IsosurfaceExtraction.exampleData()
        let x = marching_cubes_single_cell(data: sample, x: 0.0, y: 0.0, z: 1.0, material: UIColor.red)
        XCTAssertEqual(x.polygons.count, 3)
        print(" = " + x.summary)
//        = 0,0,1
//       [1.5, 1.0857864376269049, 0.7679491924311228, 1.0857864376269049, 0.5, 0.2639320225002102, 0.05051025721682212, 0.2639320225002102]
//       ["✔", "✔", "✗", "✔", "✗", "✗", "✗", "✗"]
//       faces: [[2, 9, 1], [11, 9, 2], [8, 9, 11]]
//       verts identified by this face: [" [0.5,1.0,1.0] ", " [1.0,0.0,1.5] ", " [1.0,0.5,1.0] "]
//       polygon vertices: 3 in X[0.5…1.0], Y[0.0…1.0], Y[1.0…1.5], convex? ✔
//       verts identified by this face: [" [0.0,1.0,1.5] ", " [1.0,0.0,1.5] ", " [0.5,1.0,1.0] "]
//       polygon vertices: 3 in X[0.0…1.0], Y[0.0…1.0], Y[1.0…1.5], convex? ✔
//       verts identified by this face: [" [0.0,0.0,1.5] ", " [1.0,0.0,1.5] ", " [0.0,1.0,1.5] "]
//       polygon vertices: 3 in X[0.0…1.0], Y[0.0…1.0], Y[1.5…1.5], convex? ✔
//        = polys: 3 in X[0.0…1.0], Y[0.0…1.0], Y[1.0…1.5], watertight? ✗

    }
    func testVoxelEvaluation0_0_2() {
        print(" = 0,0,2")
        let sample: IsoSurfaceDataSource = IsosurfaceExtraction.exampleData()
        let x = marching_cubes_single_cell(data: sample, x: 0.0, y: 0.0, z: 2.0, material: UIColor.red)
        XCTAssertEqual(x.polygons.count, 0)
        print(" = " + x.summary)
//        = 0,0,2
//       [0.5, 0.2639320225002102, 0.05051025721682212, 0.2639320225002102, -0.5, -0.6622776601683795, -0.8166247903553998, -0.6622776601683795]
//       ["✗", "✗", "✗", "✗", "✗", "✗", "✗", "✗"]
//       faces: []
//        = polys: 0 in X[inf…-inf], Y[inf…-inf], Y[inf…-inf], watertight? ✔
    }

    func testWorkit() throws {
        let mesh = marching_cubes(data: IsosurfaceExtraction.exampleData() as IsoSurfaceDataSource, material: UIColor.gray)
        print(mesh.summary)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
