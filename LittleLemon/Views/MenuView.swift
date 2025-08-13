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
  var body: some View {
    VStack {
      ScrollView {
        Text("Little Lemon")
          .font(.largeTitle)
        Label("Chicago", systemImage: "globe.europe.africa")
          .font(.title3)
        Text(intro)
      }
      .padding()
    }
  }
}

#Preview {
  MenuView()
}
