//
//  Item.swift
//  SwiftDataDragAndDropExample
//
//  Created by Chuck Hartman on 10/6/23.
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
