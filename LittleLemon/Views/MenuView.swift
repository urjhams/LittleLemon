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
  
  @State var filters = [String]()
  
  @State private var selectedFilter: String? = nil
  
  var filteredPredicate: NSPredicate {
    var predicates: [NSPredicate] = []
    
    if !searchText.isEmpty {
      predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
    }
    
    if let selected = selectedFilter {
      predicates.append(NSPredicate(format: "cat == %@", selected))
    }
    
    if predicates.isEmpty {
      return NSPredicate(value: true)
    } else if predicates.count == 1 {
      return predicates[0]
    } else {
      return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
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
                  FoodDetailView(dish: dish)
                } label: {
                  MenuRow(dish: dish)
                }
                Divider().padding(.leading, 24)
              }
            }
          } header: {
            FiltersHeader(filters: $filters, selected: $selectedFilter)
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
      var filters: [String] = []
      list.menu.forEach { menu in
        if !filters.contains(menu.cat) {
          filters.append(menu.cat)
        }
      }
      
      self.filters = filters
      
      loaded = true
    }
    .redacted(reason: loaded ? [] : .placeholder)
  }
}

#Preview {
  MenuView()
    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}


private struct FiltersHeader: View {
  @Binding var filters: [String]
  @Binding var selected: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("ORDER FOR DELIVERY!")
        .font(.headline)
        .padding([.top, .horizontal], 16)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(filters, id: \.self) { filter in
            let isSelected = (selected == filter)
            Text(filter)
              .padding(.horizontal, 16)
              .padding(.vertical, 10)
              .background(
                Capsule()
                  .fill(isSelected ? Color("MainThemeColor") : Color(.systemGray5))
              )
              .foregroundStyle(isSelected ? .white : .primary)
              .onTapGesture {
                if selected == filter {
                  selected = nil
                } else {
                  selected = filter
                }
              }
          }
        }
        .padding(.bottom, 16)
      }
      .contentMargins(.horizontal, 16, for: .scrollContent)
    }
    .background(Color.clear)
  }
}
