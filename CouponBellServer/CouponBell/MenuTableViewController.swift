//
//  MenuTableViewController.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 7..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class MenuTableViewController: UITableViewController{
    @IBOutlet var tView: UITableView!
    
    ////////////////////수정////////////////////////////////
    var allMenu: Results<Menu>?
    var dbQuery = DbQuery()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        allMenu = dbQuery.getFromMenuList()
        tView.reloadData()//전체 데이터 다 다시읽기
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    // MARK: 테이블뷰 설정
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if allMenu == nil{
            return 0
        }
        
        return allMenu!.count
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let menu = self.allMenu?[(indexPath as NSIndexPath).row]
        cell.groupLabel.text = menu?.type
        cell.beverageLabel.text = menu?.product
        cell.priceLabel.text = String(describing: menu!.price)
        
        return cell
    }
}




//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuDetailViewController") as! MeenuDetailViewController
//        detailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailViewController, animated: true)
//    }


//        dbQuery.addToMenuList(type: "Coffee", product: "Americano", price: 2000)
//        dbQuery.addToMenuList(type: "Coffee", product: "Espresso", price: 1500)
//        dbQuery.addToMenuList(type: "Tea", product: "GreenTea", price: 2500)
//        dbQuery.addToMenuList(type: "Tea", product: "BlackTea", price: 2000)
//        dbQuery.addToMenuList(type: "Bread", product: "Bagle", price: 2500)
