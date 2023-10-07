//
//  Extensions.swift
//  SwiftDataDragAndDropExample
//
//  Created by Chuck Hartman on 10/7/23.
//

import SwiftUI
import SwiftData

import UniformTypeIdentifiers

extension UTType {
    static var persistentModelID: UTType { UTType(exportedAs: "com.forethegreen.persistentModelID") }
}

extension PersistentIdentifier: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .persistentModelID)
    }
}

extension PersistentIdentifier {
    public func persistentModel<Model>(from context: ModelContext) -> Model? where Model : PersistentModel {
        return context.model(for: self) as? Model
    }
}

