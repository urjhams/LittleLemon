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
    }
}

#Preview {
    HomeView()
}
