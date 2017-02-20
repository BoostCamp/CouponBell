//
//  MyNetwork.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 18..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class MyNetwork: NSObject, NetServiceDelegate, NetServiceBrowserDelegate, StreamDelegate {
    
    var server: NetService!
    var socket = [Socket]()
    var connectedClients = [ConnectedClient]()
    var browser: NetServiceBrowser!
    var inStream: InputStream?
    var outStream: OutputStream?
    var rcvData = [String : Any]()
    
    
    // MARK : for singleton design - start
    struct StaticInstance{
        static var instance: MyNetwork?
    }
    
    class func sharedInstance() -> MyNetwork{
        if !(StaticInstance.instance != nil){
            StaticInstance.instance = MyNetwork()
        }
        return StaticInstance.instance!
    }
    // MARK : for singleton design - end

    
    // send message
    func sendMessage(msg: String){
        guard let outputStream = self.outStream else {
            print("Connection not create yet ! =====> Return")
            return
        }
        let data = msg.data(using: String.Encoding.utf8)
        outputStream.open()
        
        let result = data?.withUnsafeBytes { outputStream.write($0, maxLength: (data?.count)!) }
        
        if result == 0 {
            print("Stream at capacity")
        } else if result == -1 {
            print("Operation failed: \(outputStream.streamError)")
        } else {
            print("The number of bytes written is \(result)")
        }
    }
    
    // get IP Adress
    
    func updateInterface () {
        if server.port == -1 {
            print("\(server.name)" + " Not yet resolved")
            server.delegate = self
            server.resolve(withTimeout: 10)
        }
    }
    
    // MARK: init
    func publishService(){
        //publish service for client
        //publish service for server
        server = NetService.init(domain: "local", type: "_test._tcp", name: "CouponBellServer", port: 3000)
        server.includesPeerToPeer = true
        server.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
        server.delegate = self
        server.publish(options: .listenForConnections)
        print("server Service Published")
    }
    
    func searchService(){
        self.browser = NetServiceBrowser()
        self.browser.includesPeerToPeer = true
        browser.delegate = self
        browser.searchForServices(ofType: "_test._tcp", inDomain: "local")
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
                    inputStream?.read(&buffer, maxLength: buffer.count)
                    let input = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    
                    print(input)
//Data(buffer: <#T##UnsafeBufferPointer<SourceType>#>)
//                    let myData = Data(bytes: &buffer)
//                    let pppdata = try JSONSerialization.jsonObject(with: myData as Data
//                        , options: []) as! [String:Any]
//                    print(pppdata)
                    
                    if let dataFromString = input?.data(using: String.Encoding.utf8.rawValue) {
//                        print(dataFromString.base64EncodedString())
//                        print(dataFromString.base64EncodedData())
                        let pppdata = try JSONSerialization.jsonObject(with: dataFromString
                            , options: []) as! [String:Any]
                        print(pppdata)
                        let json = JSON(data: dataFromString)
                        
                        print(json)
                    }
                    
                    
                    let parsedData = try JSONSerialization.jsonObject(with: inputStream!, options: []) as! [String:Any]
                    rcvData = parsedData
                    print("rcvdata : ")
                    print(self.rcvData)
                    
                    if rcvData["RequestType"] as! String == "Order" {
                        let data = rcvData["OrderList"]
                        //주문목롣 db에 전달받은 정보 집어넣기
                        NotificationCenter.default.post(name: .rcvdMessage, object: nil)
                    } else if rcvData["RequestTy8pe"] as! String == "Menu" {
                        //메뉴보내기
                        let clientName = rcvData["ClientName"] as! String
                        for connectedClient in connectedClients {
                            if connectedClient.client.name == clientName {
                                //메뉴 json형태로 변환해서 메뉴 보내기 구현
                                sendMessage(msg: "abcd")
                            }
                        }
                    }
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
    
    
    // MARK: NetServiceDelegate - START
    
    func netServiceWillPublish(_ sender: NetService) {
        print("netServiceWillPublish \(sender)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("netServiceDidPublish \(sender)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("netService : \(sender) didNotPublish Error : \(errorDict)")
    }
    
    func netServiceWillResolve(_ sender: NetService) {
        print("netServiceWillResolve \(sender)")
        updateInterface()
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        //델리게이트 메소드는 서비스에 대해 각 주소를 해석할 때마다 호출됨.
        print("netServiceDidResolveAddress service name \(sender.name) of type \(sender.type)," +
            "port \(sender.port), addresses \(sender.addresses)")
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream){
        print("netService : \(sender) didAcceptConnectionWith Input Stream : \(inputStream) , Output Stream : \(outputStream)")
        
        
        inputStream.delegate = self
        outputStream.delegate = self
        inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        inputStream.open()
        outputStream.open()
        
        
        self.inStream = inputStream
        self.outStream = outputStream
        
        self.inStream?.delegate = self
        self.outStream?.delegate = self
        
        self.inStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inStream?.open()
        self.outStream?.open()
        
        //in, out stream 체크
        print(server.getInputStream(&inStream, outputStream: &outStream))
        print("")
        //        sendMessage(msg: "ABCDE")
        
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("netServiceDidStop : \(sender)")
    }
    
    //NetServiceDelegate - END
    
    
    
    // MARK : NetServiceBrowser Delegate - START
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserWillSearch")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserDidStopSearch")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool){
        print("findservice")
        // 실제 실행할 때는 주석 해제할것
        if service.name != "CouponBellServer" {
            connectedClients.append(ConnectedClient(client: service))
            self.server = service
            updateInterface()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("\(service) was removed")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("netServiceBrowser didNotSearch Error \(errorDict)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print("netServiceBrowser didFindDomain Domain : \(domainString)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        print("netServiceBrowser didRemoveDomain Domain : \(domainString)")
    }
    
    // NetServiceBrowser Delegate - END
}

extension Notification.Name {
    
    static let rcvdMessage = Notification.Name("rcvdMessage")
}
