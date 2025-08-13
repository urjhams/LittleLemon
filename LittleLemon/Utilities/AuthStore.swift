//
//  AuthStore.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

@Observable @MainActor
public final class AuthStore {
  static let firstNameKey = "com.little.lemon.firstName"
  static let lastNameKey = "com.little.lemon.lastName"
  static let emailKey = "com.little.lemon.email"
  static let loggedInKey = "com.little.lemon.isLoggedIn"
  
  @ObservationIgnored private let defaults: UserDefaults
  
  var isLoggedIn: Bool = false {
    didSet { defaults.set(isLoggedIn, forKey: Self.loggedInKey) }
  }
  
  public init(defaults: UserDefaults = .standard) { self.defaults = defaults }
  static let shared = AuthStore()
  
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
    
    defaults.set(firstName, forKey: Self.firstNameKey)
    defaults.set(lastName, forKey: Self.lastNameKey)
    defaults.set(email, forKey: Self.emailKey)
    isLoggedIn = true
  }
  
  func getInfo(forKey key: String) -> String? {
    defaults.string(forKey: key)
  }
  
  func logout() {
    defaults.removeObject(forKey: Self.firstNameKey)
    defaults.removeObject(forKey: Self.lastNameKey)
    defaults.removeObject(forKey: Self.emailKey)
    isLoggedIn = false
  }
}
