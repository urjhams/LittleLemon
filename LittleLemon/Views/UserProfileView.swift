//
//  UserProfileView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

struct UserProfileView: View {
  
  @State var firstName = AuthStore
    .shared
    .getInfo(forKey: AuthStore.firstNameKey) ?? ""
  
  @State var lastName = AuthStore
    .shared
    .getInfo(forKey: AuthStore.lastNameKey) ?? ""
  
  @State var email = AuthStore
    .shared
    .getInfo(forKey: AuthStore.emailKey) ?? ""
  
  @Environment(\.presentationMode) var presentation

  var body: some View {
    VStack(spacing: 10) {
      Image(systemName: "person.crop.circle.fill")
        .resizable()
        .frame(maxWidth: 100, maxHeight: 100)
        .aspectRatio(contentMode: .fill)
        .cornerRadius(50)
      Text("Personal Information")
        .font(.title2)
        .fontWeight(.bold)
        .padding(.bottom, 20)
      
      VStack(alignment: .leading, spacing: 10) {
        Text("First Name: \(firstName)")
        Text("Last Name: \(lastName)")
        Text("Email: \(email)")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 24)
      
      Spacer()
      
      Button("Log out") {
        
      }
      Spacer()
        .frame(height: 40)
    }
  }
}

#Preview {
  UserProfileView()
}
