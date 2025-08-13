//
//  OnboardingView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 11.08.25.
//

import SwiftUI

struct OnboardingView: View {
  
  @Environment(AuthStore.self) private var auth

  @State var firstName = ""
  @State var lastName = ""
  @State var email = ""
  @State var showError = false

  @State private var errorMessage = "" {
    didSet {
      showError = true
    }
  }

  var body: some View {
    VStack(spacing: 20) {

      TextField("First Name", text: $firstName)
        .textContentType(.givenName)

      TextField("Last Name", text: $lastName)
        .textContentType(.familyName)

      TextField("Email", text: $email)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)

      Button {
        register()
      } label: {
        Text("Register")
      }
      .buttonStyle(.borderedProminent)

    }
    .padding(20)

    .alert("Error", isPresented: $showError) {
      Button("Close", role: .cancel) {}
    } message: {
      Text(errorMessage)
    }
  }

  func register() {
    do {
      try AuthStore
        .shared
        .register(firstName: firstName, lastName: lastName, email: email)
      
      withAnimation {
        auth.isLoggedIn = true
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}

#Preview {
  OnboardingView()
    .environment(AuthStore(defaults: .init(suiteName: "preview")!))
}
