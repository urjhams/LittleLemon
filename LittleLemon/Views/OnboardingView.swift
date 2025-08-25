//
//  OnboardingView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 11.08.25.
//

import SwiftUI

enum OnboardingKind {
  case present
  case login
}

struct OnboardingPage: Identifiable {
  let id = UUID()
  let title: String?
  let text: String?
  let image: String?
  let kind: OnboardingKind
  
  init(
    title: String? = nil,
    text: String? = nil,
    image: String? = nil,
    kind: OnboardingKind
  ) {
    self.title = title
    self.text = text
    self.image = image
    self.kind = kind
  }
}

struct OnboardingView: View {
  
  @State private var selection = 0
  
  private let pages: [OnboardingPage] = [
    .init(
      title: "Welcome",
      text: "This is your new app!",
      image: "star",
      kind: .present
    ),
    .init(
      title: "Track",
      text: "Keep track of your progress.",
      image: "chart.bar",
      kind: .present
    ),
    .init(kind: .login)
  ]
  
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

      TabView(selection: $selection) {
        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
          switch page.kind {
          case .login:
            registerForm(firstName: $firstName, lastName: $lastName, email: $email)
              .tag(index)
          case .present:
            presentForm(title: page.title, text: page.text, image: page.image)
              .tag(index)
          }
        }
      }
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .always))
      Button {
        if selection < pages.count - 1 {
          withAnimation { selection += 1 }
        } else {
          register()
        }
      } label: {
        Text(selection < pages.count - 1 ? "Next" : "Register")
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
  
  @ViewBuilder
  func registerForm(
    firstName: Binding<String>,
    lastName: Binding<String>,
    email: Binding<String>
  ) -> some View {
    VStack {
      TextField("First Name", text: $firstName)
        .textContentType(.givenName)
      
      TextField("Last Name", text: $lastName)
        .textContentType(.familyName)
      
      TextField("Email", text: $email)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
    }
  }
  
  @ViewBuilder
  func presentForm(title: String?, text: String?, image: String?) -> some View {
    VStack {
      Text(title ?? "")
      Text(text ?? "")
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
