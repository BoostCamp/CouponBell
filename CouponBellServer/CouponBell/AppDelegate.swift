//
//  AppDelegate.swift
//  CouponBell
//
//  Created by NEXT on 2017. 2. 6..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NetServiceDelegate, StreamDelegate {

    var window: UIWindow?
    var server: NetService!
    var socket = [Socket]()
    
    var inStream: InputStream?
    var outStream: OutputStream?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create and advertise our server.  We only want the service to be registered on
        // local networks so we pass in the "local." domain.
        
        //publish service for server
        server = NetService.init(domain: "local", type: "_test._tcp", name: "CouponBellServer", port: 3000)
        server.includesPeerToPeer = true
        server.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
        server.delegate = self
        server.publish(options: .listenForConnections)
        print("server Service Published")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

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
            
            while ((inputStream?.hasBytesAvailable) != false){
                let len = inputStream?.read(&buffer, maxLength: buffer.count)
                if(len! > 0){
                    let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    if (output != ""){
                        NSLog("Server Received : %@", output!)
//                        self.msgLabel?.text = output as String?
                    }
                }else{
                    //不然會While跑到死
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
        
        
        print(server.getInputStream(&inStream, outputStream: &outStream))
//        sendMessage(msg: "ABCDE")
        
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("netServiceDidStop : \(sender)")
    }
    
    
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
}

