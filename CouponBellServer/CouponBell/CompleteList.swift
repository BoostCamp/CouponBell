//
//  CompleteList.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 16..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import RealmSwift

class CompleteList: Object{
    
    dynamic var count = -1
    dynamic var type = ""
    dynamic var menu = ""
    dynamic var price = 0
    dynamic var orderedDate = NSDate()
    dynamic var completedDate: NSDate?
    dynamic var isCompleted = false
}
