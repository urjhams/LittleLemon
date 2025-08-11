//
//  LittleLemonApp.swift
//  LittleLemon
//
//  Created by Quân Đinh on 11.08.25.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
