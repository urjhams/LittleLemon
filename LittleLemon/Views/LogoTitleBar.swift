//
//  LogoTitleBar.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import SwiftUI

struct LogoTitleToolbar: ViewModifier {
  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(.logo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(minWidth: 139, minHeight: 30)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
  }
}

extension View {
  func logoTitleToolbar() -> some View {
    self.modifier(LogoTitleToolbar())
  }
}
