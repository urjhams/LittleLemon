//
//  MenuView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

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

  @State private var sortDescriptors: [NSSortDescriptor] = [
    NSSortDescriptor(
      key: "title",
      ascending: true,
      selector: #selector(NSString.localizedStandardCompare)
    )
  ]

  var body: some View {
    ScrollView {
      FetchedObjects(
        predicate: filteredPredicate,
        sortDescriptors: sortDescriptors
      ) { (dishs: [Dish]) in
          ForEach(dishs, id: \.title) { dish in
            NavigationLink {
              FoodDetailView()
            } label: {
              Text(dish.title)
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
    .redacted(reason: loaded ? [] : .placeholder)
  }
}

#Preview {
  MenuView()
    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
