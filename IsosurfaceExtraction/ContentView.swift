//
//  ContentView.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 11/29/21.
//

import SwiftUI
import SceneKit
import Euclid

struct ContentView: View {
    var scene: SCNScene
            
    var cameraNode: SCNNode? {
        scene.rootNode.childNode(withName: "camera", recursively: false)
    }
    
    var body: some View {
        VStack {
            Text("My SceneKit View")
            SceneView(
                    scene: scene,
                    pointOfView: cameraNode,
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
            )
            // These don't appear to be exposed into SwiftUI view land...
            //    scnView.showsStatistics = true
            //    scnView.backgroundColor = .white
        }
    }
}

func provideEuclidScene() -> SCNScene {
    // create a new scene
    let scene = SCNScene()

    // create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.name = "camera"
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)

    // place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)

    // create some geometry using Euclid
    let start = CFAbsoluteTimeGetCurrent()
    let cube = Mesh.cube(size: 0.8, material: UIColor.red)
    let sphere = Mesh.sphere(slices: 120, material: UIColor.blue)
    let mesh = cube.subtract(sphere)
    print("Time:", CFAbsoluteTimeGetCurrent() - start)
    print("Polys:", mesh.polygons.count)

    // create SCNNode
    let geometry = SCNGeometry(mesh)
    let node = SCNNode(geometry: geometry)
    scene.rootNode.addChildNode(node)

    return scene
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(scene: provideEuclidScene())
    }
}
