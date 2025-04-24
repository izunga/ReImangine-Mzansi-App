//
//  VideoProcessing.swift
//  ReImagine_Mzanzi_2
//
//  Created by Inzwi Zunga on 2025/04/24.
//

import AVFoundation
import UIKit

func extractFirstFrame(from videoURL: URL) -> UIImage? {
    let asset = AVAsset(url: videoURL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    do {
        let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
        return UIImage(cgImage: cgImage)
    } catch {
        print("Failed to extract frame: \(error)")
        return nil
    }
}

func processVideoAndSendToColab(videoURL: URL, prompt: String) {
    guard let frame = extractFirstFrame(from: videoURL),
          let imageData = frame.jpegData(compressionQuality: 0.8) else {
        print("Failed to get frame")
        return
    }
    
    let colabURL = URL(string: "http://172.28.0.12:5000")! // <-- Replace with your actual endpoint
    
    var request = URLRequest(url: colabURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let base64String = imageData.base64EncodedString()
    let body: [String: Any] = [
        "image": base64String,
        "prompt": prompt
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data,
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didReceiveGeneratedImage, object: image)
            }
        } else {
            print("Failed to get image: \(error?.localizedDescription ?? "Unknown error")")
        }
    }.resume()
}

extension Notification.Name {
    static let didReceiveGeneratedImage = Notification.Name("didReceiveGeneratedImage")
}

