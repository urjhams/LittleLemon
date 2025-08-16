//
//  MenuView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

let intro = """
  Welcome to Little Lemon – where exceptional flavors meet warm hospitality. Located in the heart of Chicago, Little Lemon offers a curated dining experience that blends Mozzarella with a modern twist. Our chefs use only the freshest, locally sourced ingredients to craft dishes that delight both the palate and the eye.

  Whether you’re here for a romantic dinner, a family celebration, or a casual meal with friends, you’ll enjoy our cozy ambiance, attentive service, and a menu designed to satisfy every craving. From signature Salad to decadent Pasta, every plate tells a story of passion and culinary craftsmanship.

  Come to Restaurant X and taste the difference.
  """

struct MenuView: View {

  @Environment(\.managedObjectContext) private var viewContext

  @State private var searchText = ""
  @State var loaded = false

  var filteredPredicate: NSPredicate {
    if searchText.isEmpty {
      return NSPredicate(value: true)
    } else {
      return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
  }

  @State private var sortDescriptors: [NSSortDescriptor] = []

  var body: some View {
    ScrollView {
      FetchedObjects(
        predicate: filteredPredicate,
        sortDescriptors: sortDescriptors
      ) { (items: [Dish]) in
          ForEach(items, id: \.title) { item in
            NavigationLink {
              FoodDetailView()
            } label: {
              Text(item.title)
            }

          }
      }
      .searchable(
        text: $searchText,
        placement: .navigationBarDrawer,
        prompt: "search..."
      )
    }
    .task {
      guard !loaded else {
        return
      }
      async let menuList = try? await DataManager.shared.getMenuData()

      guard let list = await menuList else {
        // or show error
        return
      }
      await DataManager.shared.createItems(from: list, context: viewContext)
      
      loaded = true
    }
  }
}

#Preview {
  MenuView()
    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
