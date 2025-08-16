//
//  DataManager.swift
//  LittleLemon
//
//  Created by Quân Đinh on 14.08.25.
//

import Foundation
import CoreData

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
  
  func createItems(from menuList: MenuList, context: NSManagedObjectContext) {
    Dish.create(from: menuList.menu, context: context)
  }
}

extension Dish {
  static func create(from items: [Item], context: NSManagedObjectContext) {
    for item in items {
      if let existed = Self.exists(title: item.title, context), existed {
        print("existed")
        continue
      }
      let newItem = Self.init(context: context)
      newItem.title = item.title
      newItem.des = item.des
      newItem.price = item.price
      newItem.img = item.img
      newItem.cat = item.cat
    }
    
    save(context)
  }
}
