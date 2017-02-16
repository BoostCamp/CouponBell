//
//  Menu.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 13..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//
//    var type: String
//    var product: String
//    var price: Int
//    var numberClientOrdered: Int
//    
//    static let TypeKey = "TypeKey"
//    static let ProductKey = "MenuKey"
//    static let PriceKey = "PriceKey"
//    static let NumberClientOrderedKey = "NumberClientOrderedKey"

    

import Foundation
import RealmSwift

class Menu: Object{
    dynamic var type = ""
    dynamic var product = ""
    dynamic var price = 0
}

//dynamic var count = 0
//dynamic var orderedDate = NSDate()
//dynamic var completedDate: NSDate?
//dynamic var isCompleted = false
