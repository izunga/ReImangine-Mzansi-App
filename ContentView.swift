//
//  ContentView.swift
//  ReImagine_Mzanzi_2
//
//  Created by Inzwi Zunga on 2025/04/24.
//

import SwiftUI
import RealityKit
import ARKit
import PhotosUI

struct ContentView: View {
    @State private var arObject: Entity? = nil
    @State private var showCameraPicker: Bool = false
    @State private var showPromptInput: Bool = false
    @State private var promptText: String = ""
    @State private var selectedItem: PhotosPickerItem? // Holds the selected video item

    var body: some View {
        VStack {
            if let arObject = arObject {
                ARSceneView(arObject: arObject)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Waiting for AR object...")
                    .font(.headline)
                    .padding()
            }
            
            Button("Upload Video") {
                showCameraPicker.toggle()
            }
            .padding()
            .photosPicker(isPresented: $showCameraPicker, selection: $selectedItem) // Corrected usage of photosPicker
            
            // Handle video prompt input
            if showPromptInput {
                TextField("Enter Prompt", text: $promptText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Generate AR Object") {
                    generateARObject()
                }
                .padding()
            }
        }
        .onChange(of: selectedItem) { newItem in
            if let selectedItem = newItem {
                Task {
                    do {
                        if let url = try await selectedItem.loadTransferable(type: URL.self) {
                            handleVideoSelection(url: url)
                        }
                    } catch {
                        print("Failed to load video URL: \(error)")
                    }
                }
            }
        }
    }
    
    // Handle video selection from PhotosPicker
    private func handleVideoSelection(url: URL) {
        // Extract frame from video (just the first frame for now)
        if let image = extractFrameFromVideo(url: url) {
            arObject = createARObject(from: image)
            showPromptInput = true
        }
    }
    
    // Extract a frame from the video (could be extended to extract multiple frames)
    private func extractFrameFromVideo(url: URL) -> UIImage? {
        // Placeholder: Extracting the first frame for simplicity
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to extract image from video: \(error)")
            return nil
        }
    }
    
    // Generate AR object (send prompt and image to Colab, handle AI model response)
    private func generateARObject() {
        // Assuming prompt and frame extraction is done, send this to Colab AI model for processing
        // Example: Send promptText and extracted frame to Colab
        // Placeholder logic (actual API request to Colab would be added here)
        print("Generating AR object with prompt: \(promptText)")
        
        // For now, simulate the response and create a basic AR object
        if let image = extractFrameFromVideo(url: URL(string: "https://example.com/video.mp4")!) {
            arObject = createARObject(from: image)
        }
    }
}

