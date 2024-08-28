//
//  Item.swift
//  pix-flix
//
//  Created by Daniel Almeida on 28/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
