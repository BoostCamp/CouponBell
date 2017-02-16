//
//  CartTableViewController.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 13..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import UIKit

class CartTableVewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //재사용가능한 셀 있는 지 살펴보고 없으면 새로운 셀 만든다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 100
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
    }    
}
