//
//  ContentView.swift
//  pix-flix
//
//  Created by Daniel Almeida on 28/08/2024.
//

import SwiftUI
import SwiftData



/// Parses a string with the format `<width>x<height>`and returns a size object
/// - Parameter resolution: description string
/// - Returns: parsed size
func getSizeFromResolutionString(_ resolution: String) -> CGSize {
    let resolutionArray: [String] = resolution.components(separatedBy: "x")
    if resolutionArray.count < 2 {
        return CGSize(width: 0.0, height: 0.0)
    }
    
    return CGSize(
        width: (!resolutionArray[0].isEmpty ? Double(resolutionArray[0]) : 0.0)!,
        height: (!resolutionArray[1].isEmpty ? Double(resolutionArray[1]) : 0.0)!
    )
}



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]
    
    @State var newProjectName: String = ""
    @State var renameProjectName: String = ""
    @State var isCreatingNewProject: Bool = false
    @State var isEditingProjectName: Bool = false
    
    @State private var currentSelectedProject: Project?
    
    var body: some View {
        VStack {
            NavigationSplitView {
                List(selection: $currentSelectedProject){
                    ForEach(projects, id:\.self) { project in
                        NavigationLink(project.title, value: project)
                    }
                    .onDelete(perform: deleteProjects)
                }
                .onChange(of: currentSelectedProject) {
                    if currentSelectedProject == nil {
                        return
                    }
                    renameProjectName = currentSelectedProject!.title
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button("New Project", systemImage: "plus") {
                            isCreatingNewProject.toggle()
                        }.alert("Create new Project", isPresented: $isCreatingNewProject) {
                            TextField("New name", text: $newProjectName)
                            Button("Cancel") {
                                isCreatingNewProject.toggle()
                            }
                            Button(action: addProject) {
                                Text("Create new Project")
                            }
                        }.frame(maxWidth: 300)
                    }
                    ToolbarItem {
                        Button("Rename", systemImage: "pencil") {
                            if currentSelectedProject == nil {
                                return
                            }
                            isEditingProjectName.toggle()
                        }.alert("Edit Project name", isPresented: $isEditingProjectName) {
                            TextField("New name", text: $renameProjectName)
                            Button("Cancel") {
                                isEditingProjectName.toggle()
                            }
                            Button(action: changeProjectName) {
                                Text("Change Project name")
                            }
                        }.frame(maxWidth: 300)
                    }
                }
            } detail: {
                if let project = currentSelectedProject  {
                    ProjectDetail(for: project)
                }
                else {
                    Text("Select one project.")
                }
            }
            
            MenuBarView(currentSelectedProject: $currentSelectedProject)
            
        }
        
    }

    private func addProject() {
        withAnimation {
            // Note, this code is just here for learning purposes.
            // when encoding the video, the duration and dimensions will be ignored
            // and the preferences will be used instead
            let duration:Double = Configuration.duration.wrappedValue
            let resolution:CGSize = getSizeFromResolutionString(Configuration.resolution.wrappedValue)
           let newProject = Project(
                title: newProjectName,
                duration: duration,
                width: Int(resolution.width),
                height: Int(resolution.height)
            )
            modelContext.insert(newProject)
        }
    }

    private func deleteProjects(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(projects[index])
            }
        }
    }
    
    private func changeProjectName() {
        if currentSelectedProject == nil {
            return
        }
        withAnimation {
            currentSelectedProject!.title = renameProjectName
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Project.self, inMemory: true)
}
