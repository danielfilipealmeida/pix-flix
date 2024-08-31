//
//  ContentView.swift
//  pix-flix
//
//  Created by Daniel Almeida on 28/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]
    
    @State var newProjectName: String = ""
    @State var renameProjectName: String = ""
    @State var isCreatingNewProject: Bool = false
    @State var isEditingProjectName: Bool = false
    
    @State private var currentSelectedProject: Project?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $currentSelectedProject){
                ForEach(projects, id:\.self) { project in
                    NavigationLink(project.title, value: project)
                }
                .onDelete(perform: deleteProjects)
            }
            .onChange(of: currentSelectedProject) {
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
    }

    private func addProject() {
        withAnimation {
            // Note, this code is just here for learning purposes.
            // when encoding the video, the duration and dimensions will be ignored
            // and the preferences will be used instead
            let duration:Double = Configuration.duration.wrappedValue
            let resolution:String = Configuration.resolution.wrappedValue
            let resolutionArray = resolution.components(separatedBy: "x")
            let newProject = Project(
                title: newProjectName,
                duration: duration,
                width: Int(resolutionArray[0])!,
                height: Int(resolutionArray[1])!
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
