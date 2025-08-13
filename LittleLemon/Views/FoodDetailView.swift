//
//  FoodDetailView.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

struct FoodDetailView: View {
    var body: some View {
      ScrollView{
        VStack{
          Image(.bruschetta)
            .resizable()
            .renderingMode(.original)
            .frame(maxWidth: .infinity)
            .aspectRatio(contentMode: .fill)
          
          Text("Food name")
            .font(.largeTitle)
          Text("Description")
          Text("Price: $10")
        }
      }
      .logoTitleToolbar()
    }
}

#Preview {
    FoodDetailView()
}
