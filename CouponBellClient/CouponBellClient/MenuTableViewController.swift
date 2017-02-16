//
//  MenuTableViewController.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 13..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let dbQuery = DbQuery()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedIndex = -1
    var nowShowingCellIndex = -1
    var prevIndexPath: IndexPath?
    var isOpened = false
    var initial = true
    var tableNum = -1
    var allMenus: Results<Menu>?
    
    override func viewDidLoad(){
///////////////////////////////////////////////////////////////////////////////////////
//        dbQuery.addMenuList(type: "Coffee", product: "Americano", price: 2000)     //
//        dbQuery.addMenuList(type: "Coffee", product: "Espresso", price: 1500)      //
//        dbQuery.addMenuList(type: "Tea", product: "GreenTea", price: 2500)         //
//        dbQuery.addMenuList(type: "Tea", product: "BlackTea", price: 2000)         //
//        dbQuery.addMenuList(type: "Bread", product: "Bagle", price: 2500)          //
///////////////////////////////////////////////////////////////////////////////////////
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allMenus = dbQuery.getAllMenu()
        for menu in allMenus!{
            appDelegate.myOrderList.append(MyOrderList(type: menu.type, product: menu.product, price: menu.price))
        }
        tableView.reloadData()//전체 데이터 다 다시읽기
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allMenus == nil{
            return 0
        }else{
            return allMenus!.count
        }
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        let myOrder = appDelegate.myOrderList[indexPath.row]
        
        // 셀 초기값 표시를 위한 설정
        cell.firstViewProductNameLabel.text = myOrder.product
        cell.firstViewPriceLabel.text = String(describing:myOrder.price!)
        //cell에 현재 선택된 인덱스값 넘겨줌!
        cell.productName = myOrder.product
        cell.count = (myOrder.quantity)
        cell.countLabel.text = String(describing: myOrder.quantity)
        cell.totalPriceLabel.text = String((myOrder.quantity) * (myOrder.price))
        cell.index = indexPath.row
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 140
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPaths = [IndexPath]()
        
        if selectedIndex != -1 {
            indexPaths.append(IndexPath(row:selectedIndex, section: 0))
        }
        indexPaths.append(indexPath)
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        self.tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)//data 바뀌었을 때..
    }
    
    func getFromMenuList() -> Results<Menu>{
        let realm = try! Realm()
        return realm.objects(Menu)
    }
}
