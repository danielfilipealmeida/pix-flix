//
//  MenuBarView.swift
//  pix-flix
//
//  Created by Daniel Almeida on 31/08/2024.
//

import SwiftUI

struct MenuBarView: View {
    @Environment(\.openWindow) private var openWindow
    
    
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
        let duration = Configuration.duration
        let resolution = Configuration.resolution
        print(duration.wrappedValue)
        print(resolution.wrappedValue)
    }
    
    func setProjectConfiguration() {
        openWindow(id: "preferences")
    }
}

#Preview {
    MenuBarView()
}
