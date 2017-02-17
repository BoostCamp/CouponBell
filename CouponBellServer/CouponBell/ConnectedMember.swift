//
//  ConnectedMember.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 17..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation

class ConnectedClient{
    var client: NetService!
    var ipAddress: String?
    
    init(client: NetService){
        self.client = client
//        self.ipAddress = ipAddress
    }
}
