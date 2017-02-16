//
//  DbQuery.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 16..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import RealmSwift

class DbQuery{
    //추가
    //수정
    let realm = try! Realm()
    
    ///////////////////OrderList/////////////////////
    
    func getAllMenu() -> Results<Menu>{
        return realm.objects(Menu.self)
    }
    
    
    
    func addMenuList(type: String, product: String, price: Int){
        let menu = Menu()
        menu.price = price
        menu.product = product
        menu.type = type
        
        try! realm.write{
            realm.add(menu)
            print("add succeed")
        }
    }
    
    func updateMenu(orderNumber: Int){
        //수정 구현
    }
    
    func delFromOrderInfoList(){
        //del 구현
    }
}
