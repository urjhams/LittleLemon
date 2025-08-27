//
//  Dish+CoreDataProperties.swift
//  LittleLemon
//
//  Created by Quân Đinh on 16.08.25.
//
//

import Foundation
import CoreData


extension Dish {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
    return NSFetchRequest<Dish>(entityName: "Dish")
  }
  
  @NSManaged public var cat: String
  @NSManaged public var des: String
  @NSManaged public var img: String
  @NSManaged public var price: String
  @NSManaged public var title: String
  
}

extension Dish {
  static let sample: Dish = Dish(entity: Dish.entity(), insertInto: nil)
}

extension Dish : Identifiable {
  
  private static func request() -> NSFetchRequest<NSFetchRequestResult> {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
      entityName: String(describing: Self.self))
    request.returnsDistinctResults = true
    request.returnsObjectsAsFaults = true
    return request
  }
  
  static func save(_ context: NSManagedObjectContext) {
    guard context.hasChanges else { return }
    do {
      try context.save()
      print("successful save the context")
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
  static func exists(title: String, _ context: NSManagedObjectContext) -> Bool? {
    let request = Dish.request()
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
    request.predicate = predicate
    
    do {
      guard
        let results = try context.fetch(request) as? [Dish]
      else {
        return nil
      }
      return results.count > 0
    } catch (let error) {
      print(error.localizedDescription)
      return false
    }
  }
  
  class func deleteAll(_ context: NSManagedObjectContext) {
    let request = Self.request()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    
    do {
      guard
        let persistentStoreCoordinator = context.persistentStoreCoordinator
      else {
        return
      }
      try persistentStoreCoordinator.execute(deleteRequest, with: context)
      save(context)
      
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
}
