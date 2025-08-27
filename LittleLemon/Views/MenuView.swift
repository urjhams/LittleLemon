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
      
      VStack(alignment: .leading) {
        Text("Little Lemon")
          .font(.largeTitle)
          .foregroundStyle(.title)
        HStack(spacing: 16) {
          VStack(alignment: .leading, spacing: 16) {
            Text("Chicago")
              .font(.title2)
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
              .font(.body)
          }
          Image(.hero)
            .resizable()
            .frame(width: 100, height: 120)
            .aspectRatio(contentMode: .fill)
            .clipShape(.rect(cornerRadius: 10))
        }
      }
      .padding([.horizontal, .top])
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 260, alignment: .top)
      .background(.mainTheme)
      
      HStack {
        // TODO: tags here
      }
      
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
