# SwiftDataDragAndDropExample


This project is an example of how to implement drag and drop functionality with SwiftData `PersistentModel` objects in a SwiftUI App. The primary issue that makes this difficult is that SwiftData `PersistentModel` objects are not `Codable` and they are not `Transferable`.

This solution takes a slightly different approach by not trying to drag and drop the `PersistentModel` objects themselves, but instead, dragging and dropping the `PersistentIdentifier` struct from a `PersistentModel` object.  This works well because `PersistentIdentifier` is already `Codeable` and it is very easy to make it `Transferable`.  Also, a `PersistentIdentifier` struct can be used to retrieve its corresponding `PersistentModel` object from the `ModelContext`.

## Steps to Implement SwiftUI Drag and Drop with SwiftData objects

#### Make `PersistentIdentifier` conform to `Transferable`
Open your project settings, select the **Info** tab for your **Target**, then add a new **Exported Type Identifier** with the following properties:
```
Description:    "SwiftData Persistent Model ID"
Identifier:     "com.[your team].persistentModelID"
Conforms To:    "public.data"
```
Create a `UTType` extension with your new **Exported Type Identifier**:
```swift
import UniformTypeIdentifiers

extension UTType {
    static var persistentModelID: UTType { UTType(exportedAs: "com.[your team].persistentModelID") }
}
```
Finally, use the following code to create a `PersistentIdentifier` extension to make it `Transferable`:
```swift
extension PersistentIdentifier: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .persistentModelID)
    }
}
```
#### Extend `PersistentIdentifier` with a generic convenience function
Create `PersistentIdentifier` extension to retrieve the SwiftData `PersistentModel` object for the given `PersistentIdentifier`
```swift
extension PersistentIdentifier {
    public func persistentModel<Model>(from context: ModelContext) -> Model? where Model : PersistentModel {
        return context.model(for: self) as? Model
    }
}
```
#### Add `.draggable()` View modifiers
Supply the View modifier with the `PersistentIdentifier` from the `PersistentModel` object being dragged.
```swift
            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .draggable(item.persistentModelID)
```
#### Add `.dropDestination()` View modifiers
Use the generic `persistentModel()` function from the `PersistentIdentifier` extension to retrieve the `PersistentModel` object being dragged
```swift
            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .dropDestination(for: PersistentIdentifier.self) { persistentModelIDs, _ in
                    let targetItem = item   // for clarification
                    for persistentModelID in persistentModelIDs {
                        if let draggedItem: Item = persistentModelID.persistentModel(from: self.modelContext) {
                            print("\(draggedItem.timestamp) dropped on: \(targetItem.timestamp)")
                        }
                    }
                    return true
                }
```

