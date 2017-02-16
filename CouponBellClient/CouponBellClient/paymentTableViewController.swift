//
//  paymentTableViewController.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 13..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit
import RealmSwift

class paymentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allMenus: Results<Menu>?
    var totalPrice = 0
    var haveToPay = [MyOrderList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).sendMessage(msg: "abcdefg")
    }
    override func viewWillAppear(_ animated: Bool) {
        for myOrder in appDelegate.myOrderList{
            if myOrder.quantity > 0 {
                haveToPay.append(myOrder)
                totalPrice += (haveToPay.last?.quantity)! * (haveToPay.last?.price)!
            }
        }
        totalPriceLabel.text = String(totalPrice)
        tableView.reloadData()
    }

    @IBAction func goBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print(haveToPay.count)
        return haveToPay.count
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! paymentTableViewCell

        let myOrder = haveToPay[indexPath.row]
        cell.quantityLabel.text = String(myOrder.quantity)
        cell.productNameLabel.text = myOrder.product
        cell.priceLabel.text = String(myOrder.quantity * myOrder.price)

        return cell
    }
}
