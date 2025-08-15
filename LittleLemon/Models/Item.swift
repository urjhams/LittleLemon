//
//  MenuItem.swift
//  LittleLemon
//
//  Created by Quân Đinh on 14.08.25.
//

import Foundation

struct Item: Decodable {
  let title: String
  let des: String
  let img: String
  let price: String
  let cat: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case des = "description"
    case img = "image"
    case price
    case cat = "category"
  }
}
