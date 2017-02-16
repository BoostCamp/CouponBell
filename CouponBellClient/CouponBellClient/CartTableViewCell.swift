//
//  CartTableViewCell.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 13..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell{
    
    var dataArray: [[String: String]] = [["firstName " : "jangho", "lastName " : "Han"]]
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!

    @IBOutlet weak var secondLabel: UILabel!

    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var showDetails = false{
        didSet{
            secondHeightConstraint.priority = showDetails ? 250 : 999
        }
    }
}

