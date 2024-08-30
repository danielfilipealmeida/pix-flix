//
//  SettingsView.swift
//  pix-flix
//
//  Created by Daniel Almeida on 30/08/2024.
//

import SwiftUI


let screenResolutions = [
    "1920x1080",
    "1366x768",
    "1440x900",
    "1280x720",
    "1600x900",
    "2560x1440",
    "3840x2160",
    "1280x800",
    "1680x1050",
    "1024x768",
    "3200x1800",
    "1360x768",
    "1920x1200",
    "3440x1440",
    "2560x1080"
]

enum Configuration {
    static let duration = AppStorage(wrappedValue: 60.0, "duration")
    static let resolution = AppStorage(wrappedValue: screenResolutions[0], "resolution")
}

struct SettingsView: View {
    let duration = Configuration.duration
    let resolution = Configuration.resolution
    
    var body: some View {
        VStack {
            Section {
                List(selection: resolution.projectedValue) {
                    ForEach(screenResolutions, id:\.self) { resolution in
                        Text(resolution)
                    }
                }
            } header: {
                Text("Output Resolution")
            }
            
            
             Form {
                 TextField("Duration", value: duration.projectedValue, format:.number)
             }
        }.padding(20)
            .frame(minWidth: 350, minHeight: 600)
    }
}

#Preview {
    SettingsView()
}
