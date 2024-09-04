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
            Spacer()
            if currentImageUrl != nil {
                
                AsyncImage(url: currentImageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }.frame(minWidth: 400, alignment: .top)
            } else {
                Text("Select an url from the list to view it.")
                    .frame(minWidth: 400)
            }
            Spacer()
            List(selection: self.$currentImageUrl) {
                ForEach(project.urls, id:\.self) { url in
                    Text(url.lastPathComponent).lineLimit(1).truncationMode(.middle)
                }
                .onMove(perform: move)
            }
            .frame(width: 400)
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
        }.frame(alignment: .top)
    }
    
    
    /// Handle reordering of elements of the list
    /// - Parameters:
    ///   - source: the element being moved
    ///   - destination: the element which position will be taken
    ///
    func move(from source:IndexSet, to destination:Int) {
        project.urls.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    VStack {
        let fm: FileManager = FileManager.default
        let project: Project = .init(title: "Test Project", duration: 60, width: 640, height: 480)
        do {
            project.urls = try fm.contentsOfDirectory(atPath: fm.currentDirectoryPath).compactMap { URL.init(fileURLWithPath: $0)}
        }
        catch {
            
        }
        
        return ProjectDetail(for: project)
    }
    
}
