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
      VStack(spacing: 0) {
        HeroHeader()
        
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
          Section {
            FetchedObjects(
              predicate: filteredPredicate,
              sortDescriptors: sortDescriptors
            ) { (dishs: [Dish]) in
              ForEach(dishs, id: \.objectID) { dish in
                NavigationLink {
                  FoodDetailView()
                } label: {
                  MenuRow(title: dish.title)
                }
                Divider().padding(.leading, 24)
              }
            }
          } header: {
            FiltersHeader()
              .background(.regularMaterial)
          }
        }
      }
    }
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer,
      prompt: "search..."
    )
    .tint(.title)
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


private struct HeroHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Little Lemon")
        .font(.largeTitle)
        .foregroundStyle(.title)
        .padding(.bottom, -4)
      
      HStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 16) {
          Text("Chicago")
            .font(.title2)
          Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
            .font(.body)
        }
        Image(.hero)
          .resizable()
          .scaledToFill()
          .frame(width: 140, height: 140)
          .clipShape(.rect(cornerRadius: 16))
          .clipped()
      }
    }
    .padding([.horizontal, .top])
    .foregroundStyle(.white)
    .frame(maxWidth: .infinity)
    .frame(height: 260, alignment: .top)
    .background(.mainTheme)
  }
}

private struct FiltersHeader: View {
  let filters = ["Starters", "Mains", "Desserts", "Drinks"]
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("ORDER FOR DELIVERY!")
        .font(.headline)
        .padding([.top, .horizontal], 16)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(filters, id: \.self) { filtered in
            Text(filtered)
              .padding(.horizontal, 16)
              .padding(.vertical, 10)
              .background(Rectangle().fill(Color(.systemGray5)).cornerRadius(16))
          }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 16)
      }
    }
    .background(Color.clear)
  }
}

private struct MenuRow: View {
  let title: String
  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.title3).fontWeight(.semibold)
          .foregroundStyle(.mainTheme)
        Text("Description…")
          .foregroundStyle(.secondary)
          .lineLimit(2)
        Text("$--")
          .font(.headline)
          .foregroundStyle(.mainTheme)
          .padding(.top, 4)
      }
      Spacer(minLength: 12)
      Rectangle()
        .frame(width: 96, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .opacity(0.15)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
  }
}
