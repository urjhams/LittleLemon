//
//  LittleLemonApp.swift
//  LittleLemon
//
//  Created by Quân Đinh on 11.08.25.
//

import SwiftUI

@main
struct LittleLemonApp: App {
  
  @State private var auth = AuthStore.shared
  
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      if auth.isLoggedIn {
        NavigationStack {
          HomeView()
        }
        .environment(auth)
      } else {
        NavigationStack {
          OnboardingView()
        }
        .environment(auth)
      }
//      ContentView()
//        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
