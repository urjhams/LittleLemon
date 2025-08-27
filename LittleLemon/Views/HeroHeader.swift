//
//  HeroHeader.swift
//  LittleLemon
//
//  Created by Quân Đinh on 27.08.25.
//

import SwiftUI

struct HeroHeader: View {
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
