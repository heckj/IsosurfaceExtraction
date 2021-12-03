//
//  MarchingCubesControlView.swift
//  IsosurfaceExtraction
//
//  Created by Joseph Heck on 12/2/21.
//

import SwiftUI

struct MarchingCubesControlView: View {
    @State var adaptiveMode: Bool = false
    @State var threshold: Double = 1.0

    var body: some View {
        VStack {
            Group {
                Toggle("adaptive", isOn: $adaptiveMode)
                HStack {
                    Text("threshold: \(threshold)")
                    Slider(value: $threshold, in: 0.01...3.0) {
                        Text("threshold")
                    }
                }
            }.padding()
            SceneKitView(scene: provideMarchingCubesScene(adaptive: adaptiveMode, threshold: threshold))
        }
    }
}

struct MarchingCubesControlView_Previews: PreviewProvider {
    static var previews: some View {
        MarchingCubesControlView()
    }
}
