//
//  MenuRow.swift
//  LittleLemon
//
//  Created by Quân Đinh on 27.08.25.
//

import SwiftUI
import CachedAsyncImage

struct MenuRow: View {
  let dish: Dish
  
  var body: some View {
    
      VStack(alignment: .leading, spacing: -8) {
        Text(dish.title)
          .font(.title3)
          .fontWeight(.semibold)
          .foregroundStyle(.black)
          .padding(.horizontal, 16)
          .padding(.top, 16)
        
        HStack(alignment: .top, spacing: 8) {
          VStack(alignment: .leading, spacing: 8) {
            Text(dish.des)
              .foregroundStyle(.mainTheme)
              .multilineTextAlignment(.leading)
              .lineLimit(2)
            Text("\(dish.price) $")
              .font(.title3)
              .fontWeight(.semibold)
              .foregroundStyle(.mainTheme)
              .padding(.top, 4)
          }
          
          Spacer(minLength: 12)
          
          CachedAsyncImage(url: URL(string: dish.img)) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .frame(width: 72, height: 72)
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .clipped()
            case .failure(_):
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundStyle(.secondary)
            @unknown default:
              EmptyView()
            }
          }
        }
        .padding([.horizontal, .vertical], 16)
      }
  }
}
