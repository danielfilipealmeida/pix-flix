//
//  pix_flixApp.swift
//  pix-flix
//
//  Created by Daniel Almeida on 28/08/2024.
//

import Foundation
import SwiftUI
import SwiftData


@main
struct pix_flixApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var currentProject: Project?
    
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        Settings {
            SettingsView()
        }
    }
    
}
