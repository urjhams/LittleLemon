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
  let subTitle: String?
  let text: String?
  let image: ImageResource?
  let kind: OnboardingKind
  
  init(
    title: String? = nil,
    subTitle: String? = nil,
    text: String? = nil,
    image: ImageResource? = nil,
    kind: OnboardingKind
  ) {
    self.title = title
    self.subTitle = subTitle
    self.text = text
    self.image = image
    self.kind = kind
  }
}

let pages: [OnboardingPage] = [
  .init(
    title: "Welcome to Little Lemon",
    subTitle: "Chicago",
    text: "Explore a menu crafted with fresh ingredients and authentic taste. Every dish is prepared with care to bring joy to your table.",
    image: nil,
    kind: .present
  ),
  .init(
    title: "Little Lemon",
    subTitle: "Chicago",
    text: "Create your account to unlock exclusive offers and personalized recommendations. Start your taste journey with just one tap.",
    image: .hero,
    kind: .login
  )
]

struct OnboardingView: View {
  
  @State private var selection = 0
  
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
            registerForm(
              firstName: $firstName,
              lastName: $lastName,
              email: $email, title:
                page.title, subTitle:
                page.subTitle,
              text: page.text,
              image: page.image
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .tag(index)
          case .present:
            presentForm(
              title: page.title,
              subTitle: page.subTitle,
              text: page.text,
              image: page.image
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .tag(index)
          }
        }
      }
      
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .never))
      
      Button {
        if selection < pages.count - 1 {
          withAnimation { selection += 1 }
        } else {
          register()
        }
      } label: {
        Text(selection < pages.count - 1 ? "Next" : "Register")
          .padding(.horizontal)
      }
      .buttonStyle(.borderedProminent)
      .tint(.mainTheme)
    }
    .frame(maxWidth: .infinity)

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
    email: Binding<String>,
    title: String? = nil,
    subTitle: String? = nil,
    text: String? = nil,
    image: ImageResource? = nil
  ) -> some View {
    VStack {
      VStack(alignment: .leading) {
        Text(title ?? "")
          .font(.largeTitle)
          .foregroundStyle(.title)
        HStack(spacing: 16) {
          VStack(alignment: .leading, spacing: 16) {
            Text(subTitle ?? "")
              .font(.title2)
            Text(text ?? "")
              .font(.body)
          }
          if let image {
            Image(image)
              .resizable()
              .frame(width: 100, height: 120)
              .aspectRatio(contentMode: .fill)
              .clipShape(.rect(cornerRadius: 10))
          }
        }
      }
      .padding([.horizontal, .top])
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 260, alignment: .top)
      .background(.mainTheme)
      
      VStack(spacing: 30) {
        TextField("First Name", text: $firstName)
          .textContentType(.givenName)
        
        TextField("Last Name", text: $lastName)
          .textContentType(.familyName)
        
        TextField("Email", text: $email)
          .textContentType(.emailAddress)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
      }
      .padding([.bottom, .top, .horizontal], 24)
    }
  }
  
  @ViewBuilder
  func presentForm(title: String?, subTitle: String? = nil, text: String?, image: ImageResource?) -> some View {
    VStack(spacing: 24) {
      Text(title ?? "")
        .font(.title)
      Text(subTitle ?? "")
        .font(.title2)
      Text(text ?? "")
        .font(.body)
      if let image {
        Image(image)
      }
    }
    .padding(.horizontal, 24)
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
