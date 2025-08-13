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
        OnboardingView()
          .tabItem {
            Label("Home", systemImage: "house")
          }
        MenuView()
          .tabItem {
            Label("Menu", systemImage: "list.dash")
          }
        
        UserProfileView()
          .tabItem {
            Label("Profile", systemImage: "person.crop.circle")
          }
      }
    }
}

#Preview {
    HomeView()
}
