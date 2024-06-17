//
//  Product.swift
//  Xcode Demo
//
//  Created by Arun Sharma on 16/06/24.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}

