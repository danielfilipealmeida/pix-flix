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

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(projects) { project in
                    /*
                    NavigationLink {
                        Text(project.title)
                    } label: {
                        Text(project.title)
                    }
                     */
                    NavigationLink(project.title, destination: ProjectDetail(for: project))
                }
                .onDelete(perform: deleteProjects)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addProject) {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select one project.")
        }
    }

    private func addProject() {
        withAnimation {
            let newProject = Project(title: "No Name", duration: 60, width: 320, height: 200)
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
}

#Preview {
    ContentView()
        .modelContainer(for: Project.self, inMemory: true)
}
