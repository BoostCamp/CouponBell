//
//  GetUserNameViewController.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 20..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import UIKit

class GetUserNameViewController: UIViewController{
    
    @IBOutlet weak var getUserNameTextField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    @IBAction func getUserNameBtn(_ sender: Any) {
        UserDefaults.standard.set(getUserNameTextField.text, forKey: "ClientName")
        dismiss(animated: true, completion: nil)
    }
}
