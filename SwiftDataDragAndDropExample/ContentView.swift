//
//  ContentView.swift
//  SwiftDataDragAndDropExample
//
//  Created by Chuck Hartman on 10/6/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    @State private var selection = Set<Item>()
    @State private var timestamp = Date()
    
    var body: some View {
        
        List(self.items, id: \.self, selection: $selection) { item in
            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .draggable(item.persistentModelID)
                .dropDestination(for: PersistentIdentifier.self) { persistentModelIDs, _ in
                    let targetItem = item   // for clarification
                    for persistentModelID in persistentModelIDs {
                        if let draggedItem: Item = persistentModelID.persistentModel(from: self.modelContext) {
                            print("\(draggedItem.timestamp) dropped on: \(targetItem.timestamp)")
                        }
                    }
                    return true
                }
        }
        HStack {
            Text("Drop one Item here: ")
            Text(self.timestamp, style: .time)
            Text(self.timestamp, style: .date)
            Spacer()
        }
        .dropDestination(for: PersistentIdentifier.self) { persistentModelIDs, _ in
            if persistentModelIDs.count == 1 {
                if let persistentModelID = persistentModelIDs.first,
                   let draggedItem: Item = persistentModelID.persistentModel(from: self.modelContext) {
                    self.timestamp = draggedItem.timestamp
                    return true
                }
            }
            return false
        }
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
