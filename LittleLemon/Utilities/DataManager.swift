//
//  DataManager.swift
//  LittleLemon
//
//  Created by Quân Đinh on 14.08.25.
//

import Foundation

public actor DataManager {
  
  var session: URLSession
  
  public init(_ session: URLSession = .shared) {
    self.session = session
  }
  
  public static let shared = DataManager()
  
  func getMenuData() async throws -> MenuList {
    let address = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    let (data, _) = try await session.data(from: URL(string: address)!)
    return try JSONDecoder().decode(MenuList.self, from: data)
  }
}
