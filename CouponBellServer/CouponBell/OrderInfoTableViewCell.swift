//
//  OrderInfoTableViewCell.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 6..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit
// MARK: - VillainCollectionViewCell: UICollectionViewCell


class OrderInfoTableViewCell: UITableViewCell{
    //Mark: Outlets
    @IBOutlet weak var nenuLabel: UILabel!
    @IBOutlet weak var userMenuLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var userStateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var userOrderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var userOrderDateLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var showDetails = false{
        didSet{
            secondViewHeightConstraint.priority = showDetails ? 250 : 999
        }
    }
}
