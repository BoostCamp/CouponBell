//
//  ViewController.swift
//  NetServiceTest
//
//  Created by NEXT on 2017. 2. 8..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetServiceDelegate, NetServiceBrowserDelegate, StreamDelegate {
    var server: NetService!
    var receivedService = [NetService]()
    var browser: NetServiceBrowser!
    var host:String?
    var port:Int?
    @IBOutlet weak var connectStateLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var portNumberLabel: UILabel!
    
    var inputStream: InputStream?
    var outputStream: OutputStream?

    let socket : Socket? = Socket()
//    var socketPort: SocketPort?
    
    var inoutStreams = (UIApplication.shared.delegate as! AppDelegate).inoutStreams
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK : PUBLISH SCAN STOP Service buttons
    // Publish Service
    @IBAction func publishBtn(_ sender: Any) {
        print(UIDevice.current.name)
        server = NetService.init(domain: "local", type: "_test._tcp", name: UIDevice.current.name, port: 3000)
        server.includesPeerToPeer = true
        server.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
        server.delegate = self
        server.publish(options: .listenForConnections)
        
        
        ///////////////////////
        ///서버 유지를 위해 시도중///
        ///////////////////////
        self.inoutStreams.append(InOutStream(service: self.server))
        //앞에서 설정함!
//        self.inoutStreams.last?.server.includesPeerToPeer = true
//        self.inoutStreams.last?.server.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
//        self.inoutStreams.last?.server.delegate = self
//        self.inoutStreams.last?.server.publish(options: .listenForConnections)
    }
    
    // Scan Service
    @IBAction func searchBtn(_ sender: Any) {

        self.browser = NetServiceBrowser()
        self.browser.includesPeerToPeer = true
        browser.delegate = self
        browser.searchForServices(ofType: "_test._tcp", inDomain: "local")
    }
    
    @IBAction func connectBtn(_ sender: Any) {
    
        self.initSocket(self.getIPV4StringfromAddress(server.addresses!) as CFString , port: UInt32(server.port))
    }

    
    @IBAction func disConnectBtn(_ sender: Any) {
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        sendMessage(msg: "ABCD")
    }
    
//    @IBAction func sendFromServerBtn(_ sender: Any){
//        sendMessageFromServer(msg: "ABCD")
//    }
    
    @IBAction func receiveBtn(_ sender: Any) {
    }
    
    @IBAction func printBtn(_ sender: Any) {
        let buf = [UInt8](repeating: 0, count: 3)
        let len: NSInteger = 0
//        len = (inputStream?.read(&buf, maxLength: 1024))!
        var getString : NSString?
        if(len>0){
            getString = NSString(bytes: buf, length: len, encoding:  String.Encoding.utf8.rawValue)
            print(getString as! String)
            msgLabel.text = getString as? String
            
        }else{
            print(len)
            msgLabel.text = "fail"
        }
    }
    
    
    // Mark: Stream Delegate
    
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
                        self.msgLabel?.text = output as String?
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
    
    // MARK : NetServiceBrowser Delegate
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserWillSearch")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserDidStopSearch")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool){
        connectStateLabel.text = service.name
        print("findservice")
        self.receivedService.append(service)
        server = service
//            NetService.init(domain: service.domain, type: service.type, name: service.name, port: Int32(service.port))
        updateInterface()
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


    
    // MARK: NetService Delegate
    
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

        portNumberLabel.text = String(CFSocketGetDefaultNameRegistryPortNumber())
        inoutStreams.last?.server.stop()
//        print(CFSocketGetDefaultNameRegistryPortNumber())
//        SocketPort.init(port: CFSocketGetDefaultNameRegistryPortNumber())
        
        
//        sendMessageFromServer(msg: "ABCDEF", outStream: outputStream)
        
        
//        inoutStreams.last?.socket?.inputStream?.delegate = self
//        inoutStreams.last?.socket?.outputStream?.delegate = self
//        inoutStreams.last?.socket?.inputStream = inputStream
//        inoutStreams.last?.socket?.outputStream = outputStream
//    
//        inoutStreams.last?.socket?.inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
//        inoutStreams.last?.socket?.outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
//
//        inoutStreams.last?.socket?.inputStream?.open()
//        inoutStreams.last?.socket?.outputStream?.open()
        
        
        
//        setStreams(inputStream: inputStream, outputStream: outputStream)
        
//        socket?.inputStream = inputStream
//        socket?.outputStream = outputStream
//        SocketPort(tcpPort: <#T##UInt16#>)
//        socketPort = SocketPort(tcpPort: UInt16(sender.port))
//        initSocketCommunication()
//        inoutStreams.last?.socket?.initSocketCommunication(socket: (socketPort?.socket)!)
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("netServiceDidStop : \(sender)")
    }


    // get IP Adress
    
    func updateInterface () {
        if server.port == -1 {
            print("\(server.name)" + " Not yet resolved")
            server.delegate = self
            server.resolve(withTimeout: 10)
        }
    }
    
    func getIPV4StringfromAddress(_ address: [Data] ) -> String{
        
        if  address.count == 0{
            return "0.0.0.0"
        }
        
        let data = address.first! as NSData
        
        var ip1 = UInt8(0)
        data.getBytes(&ip1, range: NSMakeRange(4, 1))
        
        var ip2 = UInt8(0)
        data.getBytes(&ip2, range: NSMakeRange(5, 1))
        
        var ip3 = UInt8(0)
        data.getBytes(&ip3, range: NSMakeRange(6, 1))
        
        var ip4 = UInt8(0)
        data.getBytes(&ip4, range: NSMakeRange(7, 1))
        
        let ipStr = String(format: "%d.%d.%d.%d",ip1,ip2,ip3,ip4)
        
        return ipStr
    }


    //init socket
    
    func initSocket( _ ipString :CFString , port : UInt32 ){
        socket?.initSockerCommunication(ipString, port: port)
        print("HOST \(ipString) and the port : \(port)" )
        socket?.setStreamDelegate(self)
    }
    

    //send message
    
    func sendMessage(msg: String){
        guard let outputStream = socket?.getOutputStream() else {
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
    
    func sendMessageFromServer(msg: String , outStream: OutputStream?){
        guard let outputStream = outStream else {
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

    
    // open streams
    func openStreams(inoutStream: InOutStream){
        
    }
}






