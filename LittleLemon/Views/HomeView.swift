//
//  HomeView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
      TabView {
        MenuView()
          .tabItem {
            Label("Menu", systemImage: "list.dash")
          }
        
        UserProfileView()
          .tabItem {
            Label("Profile", systemImage: "square.and.pencil")
          }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Image(.profile)
            .resizable()
            .frame(width: 40, height: 40)
            .cornerRadius(20)
        }
      }
    }
}

#Preview {
    HomeView()
      .environment(AuthStore(defaults: .init(suiteName: "preview")!))
      .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
