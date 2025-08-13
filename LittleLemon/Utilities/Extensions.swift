//
//  Extensions.swift
//  LittleLemon
//
//  Created by Quân Đinh on 13.08.25.
//

import Foundation

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
  public var errorDescription: String? {
    self
  }
}
