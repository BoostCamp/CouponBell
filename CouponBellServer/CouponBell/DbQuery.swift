//
//  DbQuery.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 16..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import RealmSwift

class DbQuery{
    let realm = try! Realm()
    
    ///////////////////OrderList/////////////////////
    
    func getFromOrderInfoList(isCompleted: Bool) -> Results<OrderInfo>{
        
        let allLists = realm.objects(OrderInfo.self)
        return allLists.filter(("isCompleted == \(isCompleted)"))
    }
    
   
    
    func addToOrderInfoList(count: Int, type: String, menu: String, price: Int, isCompleted: Bool){
        let orderInfo = OrderInfo()
        orderInfo.count = count
        orderInfo.type = type
        orderInfo.menu = menu
        orderInfo.orderedDate = NSDate()
        orderInfo.isCompleted = false
        try! realm.write{
            realm.add(orderInfo)
            print("add succeed")
        }
    }
    
    func changeIsCompletedFromOrderInfoList(orderNumber: Int){
        let allLists = realm.objects(OrderInfo.self)
        let list = allLists[orderNumber]
        try! realm.write{
            list.isCompleted = !list.isCompleted
        }
    }
    
    func delFromOrderInfoList(){
        //del 구현
    }
    
    
    ///////////////////Menu/////////////////////
    
    func getFromMenuList() -> Results<Menu>{
        return realm.objects(Menu.self)
    }
    
    
    func addToMenuList(type: String, product: String, price: Int){
        let menu = Menu()
        menu.type = type
        menu.product = product
        menu.price = price
        
        try! realm.write{
            realm.add(menu)
            print("add succeed")
        }
    }
    
    
    
    
}

