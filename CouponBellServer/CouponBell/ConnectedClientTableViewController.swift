//
//  ConnectedClientableViewController.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 17..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import UIKit

class ConnectedClientTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var connectedClients = [ConnectedClient]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        connectedClients = appDelegate.connectedClients
    }
    
    
    
    // MARK: TableView, TableViewDataSource Delegate - START
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return connectedClients.count
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectedClientTableViewCell", for: indexPath) as! ConnectedClientTableViewCell
        let connectedClient = connectedClients[indexPath.row]
        
        cell.userNameLabel.text = connectedClient.client.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let notifyAction = UITableViewRowAction (style: .normal , title: "완료") { ( action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let sendAlarm = UIAlertController(title: "완료", message: "알람 메시지를 보내시겠습니가?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "뒤로가기", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "보내기", style: .default, handler: nil)
            
            sendAlarm.addAction(okAction)
            sendAlarm.addAction(cancelAction)
            
            self.present(sendAlarm, animated: false, completion: nil)
        }
        
        notifyAction.backgroundColor = UIColor.brown
        
        return [notifyAction]
    }
    
    // MARK: TableView, TableViewDataSource Delegate - END

}


//let okAction = UIAlertAction(title: "보내기", style: .default) { ( action: UIAlertAction ) in
//    
//    let cell = tableView.cellForRow(at: indexPath) as! OrderInfoTableViewCell
//    self.dbQuery.changeIsCompletedFromOrderInfoList(orderNumber: Int(cell.userOrderNumberLabel.text!)!)
//    tableView.reloadData()
//    //보내는 기능 추가하기!
//}
