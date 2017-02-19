//
//  OrderInfoTableViewController.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 8..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit
import RealmSwift

class OrderInfoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StreamDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    
    var orderInfos: Results<OrderInfo>?
    var dbQuery = DbQuery()
    var selectedIndex = -1
    var myNetwork: MyNetwork?
    
   
    @IBAction func sendBtn(_ sender: Any) {
//        (UIApplication.shared.delegate as! AppDelegate).sendMessage(msg: "abcde")
    }
    
    // MARK: View Life Cycle - START
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myNetwork = MyNetwork.sharedInstance()
        myNetwork?.publishService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //db에 저장된 정보들 불러오기
        if self.restorationIdentifier == "preparing"{
            orderInfos = dbQuery.getFromOrderInfoList(isCompleted: false)
        }else{
            orderInfos = dbQuery.getFromOrderInfoList(isCompleted: true)
        }

        myNetwork?.searchService()

        //전체 데이터 다 다시읽기
        tableView.reloadData()
    }
    
    // View Life Cycle - END

    
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
        
//        print(cell.tableView.frame)
        cell.tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 200
        }else{
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPaths = [IndexPath]()
        let cell = tableView.cellForRow(at: indexPath) as! OrderInfoTableViewCell
        if selectedIndex != -1 {
            indexPaths.append(IndexPath(row:selectedIndex, section: 0))
            
        }
        indexPaths.append(indexPath)
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
            //또 클릭했을 때~~
            
        }else{
            selectedIndex = indexPath.row
        }
        self.tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)//data 바뀌었을 때..
    }
    
    
    // MARK: Stream Delegate - START
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event){
        switch eventCode{
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
        case Stream.Event.openCompleted:
            print("stream opened")
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            var buffer = [UInt8](repeating:0, count:4096)
            
            let inputStream = aStream as? InputStream
            
            
            //통신타입 - 메뉴요청 혹은 주문. 각각 해당하는 컨트롤러
            while ((inputStream?.hasBytesAvailable) != false){
                do{
                    let parsedData = try JSONSerialization.jsonObject(with: inputStream!, options: []) as! [String:Any]
                    print("parsedData!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print(parsedData)
                    rcvData = parsedData
                    print("rcvdata : ")
                    print(self.rcvData)
                    
                } catch let error {
                    print("errorerorewfewoeroero")
                    print(error.localizedDescription)
                }
                //server쪽에 accept쪽 delegate
                let len = inputStream?.read(&buffer, maxLength: buffer.count)
                if(len! > 0){
                    let input = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    if (input != ""){
                        NSLog("Server Received : %@", input!)
                    }
                }else{
                    break
                }
            }
            break
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
        default:
            break
        }
    }
    
    // StreamDelegate - End
}







//addToOrderInfoList(count: 1, type: "Coffee", menu: "Americano", price: 2000, isCompleted: false)
//addToOrderInfoList(count: 2, type: "Coffee", menu: "Espresso", price: 1500, isCompleted: false)
//addToOrderInfoList(count: 3, type: "Tea", menu: "BlackTea", price: 2000, isCompleted: false)
//addToOrderInfoList(count: 4, type: "Tea", menu: "GreenTea", price: 2500, isCompleted: false)
