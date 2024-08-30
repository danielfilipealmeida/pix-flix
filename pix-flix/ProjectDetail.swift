//
//  ProjectDetail.swift
//  pix-flix
//
//  Created by Daniel Almeida on 29/08/2024.
//

import SwiftUI

struct ProjectDetail: View {
    var project: Project
    @State private var currentImageUrl: URL? = nil
    let allowedExtensions: [String] = ["jpeg", "jpg", "gif", "png"]
    @Environment(\.openWindow) private var openWindow
    
    
    init(for project: Project) {
        self.project = project
        self.currentImageUrl = nil
    }
    
    
    var body: some View {
        VStack {
            HStack {
                if currentImageUrl != nil {
                    AsyncImage(url: currentImageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }.frame(minWidth: 400)
                } else {
                    Text("Select an url from the list to view it.")
                        .frame(minWidth: 400)
                }
                List(selection: self.$currentImageUrl) {
                    ForEach(project.urls, id:\.self) { url in
                        Text(url.lastPathComponent)
                    }
                    .onMove(perform: move)
                }
                .frame(minWidth: 400)
                .dropDestination(for: URL.self) { items, location in
                    let fm = FileManager.default
                    for item in items {
                        if !fm.fileExists(atPath: item.path) {
                            continue
                        }
                        if !allowedExtensions.contains(item.pathExtension.lowercased()) {
                            continue
                        }
                        
                        project.urls.append(item)
                    }

                    return true
                }
            }
            
            HStack(spacing: 20) {
                Spacer()
                Button("Configuration", systemImage: "wrench.and.screwdriver.fill", action: setProjectConfiguration).controlSize(.regular)
                Button("Encode", systemImage: "play.circle.fill", action: encode).controlSize(.regular)
            }
            .padding(.trailing, 15)
            .frame(minHeight: 50)
            
            
        }
        
    }
    
    func move(from source:IndexSet, to destination:Int) {
        project.urls.move(fromOffsets: source, toOffset: destination)
    }
    
    func encode() {
        let duration = Configuration.duration
        let resolution = Configuration.resolution
        print(duration.wrappedValue)
        print(resolution.wrappedValue)
    }
    
    func setProjectConfiguration() {
        openWindow(id: "preferences")
    }
}
