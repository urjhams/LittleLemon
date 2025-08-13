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
      ZStack {
        if auth.isLoggedIn {
          NavigationStack { HomeView() }
            .transition(.asymmetric(
              insertion: .move(edge: .trailing).combined(with: .opacity),
              removal:   .move(edge: .trailing).combined(with: .opacity)
            ))
        } else {
          NavigationStack { OnboardingView() }
            .transition(.asymmetric(
              insertion: .move(edge: .leading).combined(with: .opacity),
              removal:   .move(edge: .leading).combined(with: .opacity)
            ))
        }
      }
      .animation(.spring(response: 0.5, dampingFraction: 0.9), value: auth.isLoggedIn)
      .environment(auth)
//      ContentView()
//        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
