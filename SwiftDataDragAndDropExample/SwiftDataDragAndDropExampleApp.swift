//
//  SwiftDataDragAndDropExampleApp.swift
//  SwiftDataDragAndDropExample
//
//  Created by Chuck Hartman on 10/6/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataDragAndDropExampleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
