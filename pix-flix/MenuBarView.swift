//
//  MenuBarView.swift
//  pix-flix
//
//  Created by Daniel Almeida on 31/08/2024.
//

import SwiftUI


/// Returns all images in an array from an url array
/// - Parameter urls: array of urls pointing to images
/// - Returns: an Array of NSImages
func getNSImageArrayFromURLArray(_ urls: [URL]) -> [NSImage] {
    var output: [NSImage] = .init()
    
    for url in urls {
        guard let image: NSImage = NSImage(contentsOfFile: url.path()) else {
            continue
        }
        output.append(image)
    }
    
    return output
}


struct MenuBarView: View {
    @Environment(\.openWindow) private var openWindow
    @Binding var currentSelectedProject: Project?
    
    
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            Button("Configuration", systemImage: "wrench.and.screwdriver.fill", action: setProjectConfiguration).controlSize(.regular)
            Button("Encode", systemImage: "play.circle.fill", action: encode).controlSize(.regular)
        }
        .padding(.trailing, 15)
        .frame(height: 50)
    }
    
    func encode() {
        if currentSelectedProject == nil {
            return
        }
        
        let duration:Double = Configuration.duration.wrappedValue
        let resolution:CGSize = getSizeFromResolutionString( Configuration.resolution.wrappedValue)
        let images: [NSImage] = getNSImageArrayFromURLArray($currentSelectedProject.wrappedValue!.urls)

        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save video as:"
        panel.nameFieldStringValue = "\(currentSelectedProject!.title).mov"
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [.movie, .mpeg4Movie, .quickTimeMovie]
        if panel.runModal() != .OK {
            return
        }
        
        let outputURL: URL = panel.url!
        let videoCreator: VideoCreator = .init(images: images, outputURL: outputURL, videoSize: resolution, duration: duration)
        videoCreator.run { success in
            if success {
                print("Video created successfully at \(outputURL)")
                exit(0)
              } else {
                print("Failed creating video")
                  exit(-1)
            }
        }
         
    }
    
    func setProjectConfiguration() {
        openWindow(id: "preferences")
    }
}

/*
 #Preview {
 MenuBarView()
 }
 */
