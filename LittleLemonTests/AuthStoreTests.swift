//
//  AuthStoreTests.swift
//  LittleLemonTests
//
//  Created by Quân Đinh on 13.08.25.
//

import Testing
import Foundation

@testable import LittleLemon

@MainActor
struct AuthStoreTests {
  
  private func makeSUT() -> (AuthStore, UserDefaults, String) {
    let suiteName = "AuthStoreTests-\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: suiteName)!
    defaults.removePersistentDomain(forName: suiteName)
    let sut = AuthStore(defaults: defaults)
    return (sut, defaults, suiteName)
  }
  
  @Test("Initial login state should be false when no key saved")
  func initialLoginStateFalse() {
    let (sut, defaults, suiteName) = makeSUT()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    
    #expect(sut.isLoggedIn == false)
  }
  
  @Test("Register saves user info and sets loggedIn true")
  func registerSavesUserInfo() throws {
    let (sut, defaults, suiteName) = makeSUT()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    
    try sut.register(firstName: "Alice", lastName: "Nguyen", email: "alice@example.com")
    
    #expect(defaults.string(forKey: AuthStore.firstNameKey) == "Alice")
    #expect(defaults.string(forKey: AuthStore.lastNameKey) == "Nguyen")
    #expect(defaults.string(forKey: AuthStore.emailKey) == "alice@example.com")
    #expect(sut.isLoggedIn)
    #expect(defaults.bool(forKey: AuthStore.loggedInKey))
  }
  
  @Test("Register throws when fields empty")
  func registerThrowsWhenFieldsEmpty() {
    let (sut, _, _) = makeSUT()
    
    #expect(throws: Error.self) {
      try sut.register(firstName: "", lastName: "A", email: "a@b.com")
    }
    #expect(throws: Error.self) {
      try sut.register(firstName: "A", lastName: "", email: "a@b.com")
    }
    #expect(throws: Error.self) {
      try sut.register(firstName: "A", lastName: "B", email: "")
    }
  }
  
  @Test("Register throws when email invalid")
  func registerThrowsInvalidEmail() {
    let (sut, _, _) = makeSUT()
    
    #expect(throws: Error.self) {
      try sut.register(firstName: "A", lastName: "B", email: "invalid.email")
    }
  }
  
  @Test("GetInfo returns correct values")
  func getInfoReturnsValue() {
    let (sut, defaults, suiteName) = makeSUT()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    
    defaults.set("Bob", forKey: AuthStore.firstNameKey)
    defaults.set("Tran", forKey: AuthStore.lastNameKey)
    defaults.set("bob@example.com", forKey: AuthStore.emailKey)
    
    #expect(sut.getInfo(forKey: AuthStore.firstNameKey) == "Bob")
    #expect(sut.getInfo(forKey: AuthStore.lastNameKey) == "Tran")
    #expect(sut.getInfo(forKey: AuthStore.emailKey) == "bob@example.com")
  }
  
  @Test("Logout removes all keys and sets loggedIn false")
  func logoutRemovesAllKeys() throws {
    let (sut, defaults, suiteName) = makeSUT()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    
    try sut.register(firstName: "A", lastName: "B", email: "a@b.com")
    #expect(sut.isLoggedIn)
    
    sut.logout()
    
    #expect(defaults.string(forKey: AuthStore.firstNameKey) == nil)
    #expect(defaults.string(forKey: AuthStore.lastNameKey) == nil)
    #expect(defaults.string(forKey: AuthStore.emailKey) == nil)
    #expect(sut.isLoggedIn == false)
    #expect(defaults.bool(forKey: AuthStore.loggedInKey) == false)
  }
  
  @Test("Login state persists across instances with same suite")
  func loginStatePersistsAcrossInstances() throws {
    let (sut, defaults, suiteName) = makeSUT()
    defer { defaults.removePersistentDomain(forName: suiteName) }
    
    try sut.register(firstName: "A", lastName: "B", email: "a@b.com")
    #expect(sut.isLoggedIn)
    
    let sut2 = AuthStore(defaults: defaults)
    #expect(sut2.isLoggedIn)
  }
}
