//
//  Cart.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftData

@Model
class CartModel {
    @Relationship(deleteRule: .cascade) var product: Hit?
    
    init(product: Hit? = nil) {
        self.product = product
    }
}
