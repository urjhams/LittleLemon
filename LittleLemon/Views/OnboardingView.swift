//
//  OnboardingView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 11.08.25.
//

import SwiftUI

public final class OnboardingManager {
  static let firstNameKey = "com.little.lemon.firstName"
  static let lastNameKey = "com.little.lemon.lastName"
  static let emailKey = "com.little.lemon.email"
  
  private init() {}
  static let shared = OnboardingManager()
  
  func register(
    firstName: String,
    lastName: String,
    email: String
  ) throws {
    guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty else {
      throw "First name, last name, and email must not empty"
    }
    
    guard email.contains("@") else {
      throw "Invalid email format"
    }
    
    UserDefaults.standard.set(firstName, forKey: Self.firstNameKey)
    UserDefaults.standard.set(lastName, forKey: Self.lastNameKey)
    UserDefaults.standard.set(email, forKey: Self.emailKey)
  }
  
  func getInfo(forKey key: String) -> String? {
    UserDefaults.standard.string(forKey: key)
  }
}

private enum Route: Hashable {
  case home
}

struct OnboardingView: View {
  
  @State var firstName = ""
  @State var lastName = ""
  @State var email = ""
  @State var showError = false
  
  @State private var errorMessage = "" {
    didSet {
      showError = true
    }
  }
  
  @State private var path = NavigationPath()
    
  var body: some View {
    NavigationStack(path: $path) {
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
      .navigationTitle("Onboarding")
      
      .navigationDestination(for: Route.self) {
        switch $0 {
        case .home:
          HomeView()
        }
      }
      
      .alert("Error", isPresented: $showError) {
        Button("Close", role: .cancel) {}
      } message: {
        Text(errorMessage)
      }
    }
  }
  
  
  func register() {
    do {
      try OnboardingManager
        .shared
        .register(firstName: firstName, lastName: lastName, email: email)
      
      path.append(Route.home)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}

#Preview {
  OnboardingView()
}
