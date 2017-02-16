//
//  MyOrderList.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 16..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//
import UIKit

class MyOrderList{
    
    let type: String!
    let product: String!
    let price: Int!
    var quantity = 0
    
    
    // MARK: init
    
    init(type: String!, product: String!, price: Int!){
        self.type = type
        self.product = product
        self.price = price
    }
}



