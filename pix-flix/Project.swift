//
//  Item.swift
//  pix-flix
//
//  Created by Daniel Almeida on 28/08/2024.
//

import Foundation
import SwiftData

@Model
final class Project {
    var title: String
    var urls: [URL]
    var duration: Double
    var width: Int
    var heigh: Int
    
    init(title: String, duration: Double, width: Int, height: Int) {
        self.title = title
        self.urls = []
        self.duration = duration
        self.width = width
        self.heigh = height
    }
}
