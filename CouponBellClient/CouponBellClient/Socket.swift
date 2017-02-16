//
//  Socket.swift
//  CouponBellClient
//
//  Created by NEXT on 2017. 2. 17..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit

enum SocketState : Int {
    case Init = 0
    case connect = 1
    case disconnect = 2
    case errorOccurred = 3
    
}


class Socket: NSObject {
    
    var inputStream  : InputStream?
    var outputStream : OutputStream?
    var runloop      : RunLoop?
    var status       : Int = -1
    var timeout      : Float = 5.0;
    var portNumber   : UInt16?
    weak var mStreamDelegate:StreamDelegate?
    
    func initSocketCommunication( _ host:CFString , port : UInt32 ){
        print()
        print("initSocketCommunication is called")
        DispatchQueue.global().async {
            
            var readstream : Unmanaged<CFReadStream>?
            var writestream : Unmanaged<CFWriteStream>?
            
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readstream, &writestream)
            
            self.portNumber = CFSocketGetDefaultNameRegistryPortNumber() // 2454
            
            self.inputStream = readstream!.takeRetainedValue()
            self.outputStream = writestream!.takeRetainedValue()
            
            self.inputStream?.delegate = self
            self.outputStream?.delegate = self
            
            self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            self.outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            
            self.inputStream?.open()
            self.outputStream?.open()
        }
    }
    
    func initSocketCommunication(socket: CFSocketNativeHandle){
        var readStream : Unmanaged<CFReadStream>?
        var writeStream : Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, socket, &readStream, &writeStream)
        
        //        CFSocket
        //        SocketPort
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream?.open()
        self.outputStream?.open()
    }
    
    
    func setStreamDelegate(_ delegete:StreamDelegate){
        print()
        print("setStreamDelegate is called")
        mStreamDelegate = delegete
    }
    
    func getInputStream() -> InputStream{
        print()
        print("getInputStream is called")
        return self.inputStream!
    }
    
    func getOutputStream() -> OutputStream {
        print()
        print("getoutputstream is called")
        
        return self.outputStream!
    }
}
extension Socket : StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (eventCode){
            
        case Stream.Event.openCompleted:
            self.status = SocketState.connect.rawValue
            break
            
        case Stream.Event.hasBytesAvailable:
            break
            
        case Stream.Event.errorOccurred:
            break
            
        case Stream.Event.endEncountered:
            self.status = SocketState.errorOccurred.rawValue
            break
            
        default:
            print("")
        }
        mStreamDelegate?.stream?(aStream, handle: eventCode)
    }
}
