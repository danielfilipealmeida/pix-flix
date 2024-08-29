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
    
    
    init(for project: Project) {
        self.project = project
        self.currentImageUrl = nil
    }
    
    
    var body: some View {
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
            List(project.urls, id:\.self, selection: self.$currentImageUrl) {
                Text($0.lastPathComponent)
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
    }
}
