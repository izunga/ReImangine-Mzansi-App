//
//  ARSceneView.swift
//  ReImagine_Mzanzi_2
//
//  Created by Inzwi Zunga on 2025/04/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARSceneView: UIViewRepresentable {
    let arObject: Entity

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Set up AR session configuration
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]  // Detect horizontal planes
        
        // Run AR session with configuration
        arView.session.run(config, options: [])
        
        // Set the AR session delegate to the coordinator
        arView.session.delegate = context.coordinator
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Update AR view as needed
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(arObject: arObject)
    }

    // MARK: - Coordinator class
    class Coordinator: NSObject, ARSessionDelegate {
        var arObject: Entity

        init(arObject: Entity) {
            self.arObject = arObject
        }

        // AR session delegate method
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    let planeEntity = ModelEntity(mesh: MeshResource.generatePlane(width: 0.3, height: 0.3))
                    planeEntity.position = [planeAnchor.transform.columns.3.x, planeAnchor.transform.columns.3.y, planeAnchor.transform.columns.3.z]
                    
                    let anchorEntity = AnchorEntity(world: planeAnchor.transform)
                    anchorEntity.addChild(planeEntity)
                    
                    if let arView = session.delegate as? ARView {
                        arView.scene.addAnchor(anchorEntity)
                    }
                    
                    arObject.position = planeEntity.position
                    anchorEntity.addChild(arObject)
                }
            }
        }
    }
}
