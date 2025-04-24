//
//  ARHelper.swift
//  ReImagine_Mzanzi_2
//
//  Created by Inzwi Zunga on 2025/04/24.
//

import RealityKit
import UIKit

func createARObject(from image: UIImage) -> Entity {
    guard let data = image.pngData() else {
        fatalError("Failed to get PNG data from image")
    }

    // Save image to temp directory
    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("texture.png")
    do {
        try data.write(to: tempURL)
    } catch {
        fatalError("Failed to write image to temp directory: \(error)")
    }

    // Load texture from file URL
    var material = UnlitMaterial()
    do {
        material.baseColor = try .texture(.load(contentsOf: tempURL))
    } catch {
        fatalError("Failed to load texture from file: \(error)")
    }

    // Create plane entity with texture
    let planeMesh = MeshResource.generatePlane(width: 0.3, height: 0.3)
    let modelEntity = ModelEntity(mesh: planeMesh, materials: [material])

    return modelEntity
}

