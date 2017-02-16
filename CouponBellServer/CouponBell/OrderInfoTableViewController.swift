//
//  OrderInfoTableViewController.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 8..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit
import RealmSwift

class OrderInfoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var orderInfos: Results<OrderInfo>?
    var dbQuery = DbQuery()
    
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    @IBAction func sendBtn(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).sendMessage(msg: "abcde")
    }
    override func viewWillAppear(_ animated: Bool) {
        //db에 저장된 정보들 불러오기
        if self.restorationIdentifier == "preparing"{
            orderInfos = dbQuery.getFromOrderInfoList(isCompleted: false)
        }else{
            orderInfos = dbQuery.getFromOrderInfoList(isCompleted: true)
        }
        
        //전체 데이터 다 다시읽기
        tableView.reloadData()
    }
    
    // MARK: 테이블뷰 설정
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderInfos == nil{
            return 0
        }
        return self.orderInfos!.count
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoTableViewCell", for: indexPath)as! OrderInfoTableViewCell
        
        let item = self.orderInfos?[(indexPath as NSIndexPath).row]
        
        cell.userMenuLabel.text = item!.menu
        cell.userStateLabel.text = String(describing: item!.isCompleted)
        cell.userOrderDateLabel.text = String(describing: item!.orderedDate)
        cell.userOrderNumberLabel.text = String(describing: item!.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("delete")
        } else if editingStyle == .insert{
            print("insert")
        } else if editingStyle == .none {
            print("none")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let notifyAction = UITableViewRowAction (style: .normal , title: "완료") { ( action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let sendAlarm = UIAlertController(title: "완료", message: "알람 메시지를 보내시겠습니가?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "뒤로가기", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "보내기", style: .default) { ( action: UIAlertAction ) in
                
                let cell = tableView.cellForRow(at: indexPath) as! OrderInfoTableViewCell
                self.dbQuery.changeIsCompletedFromOrderInfoList(orderNumber: Int(cell.userOrderNumberLabel.text!)!)
                tableView.reloadData()
                //보내는 기능 추가하기!
            }
            
            sendAlarm.addAction(okAction)
            sendAlarm.addAction(cancelAction)
            
            self.present(sendAlarm, animated: false, completion: nil)
        }
        
        notifyAction.backgroundColor = UIColor.brown
        
        return [notifyAction]
    }
    
//    func addToOrderInfoList(count: Int, type: String, menu: String, price: Int, isCompleted: Bool){
//        let realm = try! Realm()
//        let orderInfo = OrderInfo()
//        orderInfo.count = count
//        orderInfo.type = type
//        orderInfo.menu = menu
//        orderInfo.orderedDate = NSDate()
//        orderInfo.isCompleted = false
//        try! realm.write{
//            realm.add(orderInfo)
//            print("add succeed")
//        }
//    }
    
//    func getFromOrderInfoList(identifier: String) -> Results<OrderInfo>{
//        let realm = try! Realm()
//        
//        let allLists = realm.objects(OrderInfo.self)
//        if identifier == "preparing" {
//            return allLists.filter("isCompleted == false")
//        }else{
//            return allLists.filter("isCompleted == true")
//        }
//    }
}







//addToOrderInfoList(count: 1, type: "Coffee", menu: "Americano", price: 2000, isCompleted: false)
//addToOrderInfoList(count: 2, type: "Coffee", menu: "Espresso", price: 1500, isCompleted: false)
//addToOrderInfoList(count: 3, type: "Tea", menu: "BlackTea", price: 2000, isCompleted: false)
//addToOrderInfoList(count: 4, type: "Tea", menu: "GreenTea", price: 2500, isCompleted: false)
