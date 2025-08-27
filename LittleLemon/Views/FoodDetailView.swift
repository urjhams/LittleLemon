//
//  FoodDetailView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

struct FoodDetailView: View {
  
  let dish: Dish?

  var body: some View {
    ScrollView {
      VStack {
        Image(.bruschetta)
          .resizable()
          .renderingMode(.original)
          .frame(maxWidth: .infinity)
          .aspectRatio(contentMode: .fill)

        Text(dish?.title ?? "")
          .font(.largeTitle)
        Text(dish?.des ?? "")
        Text("\(dish?.price ?? "")$")
      }
    }
    .logoTitleToolbar()
  }
}

#Preview {
  FoodDetailView(dish: nil)
}
