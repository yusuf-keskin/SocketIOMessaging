//
//  WebSockerService.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit
import Foundation
import SocketIO

let SOCKET_HOST = "http://192.168.1.133:3001"
let SOCKET_CONNECTUSER = "connectUser"
let SOCKET_USERLIST = "userList"
let SOCKET_EXIT_USER = "exitUser"
let SOCKET_NEW_CHAT_MESSAGE = "newChatMessage"
let SOCKET_CHAT_MESSAGE = "chatMessage"

protocol SocketServiceProtocol {
    func establishConnection()
    func closeConnection()
    func joinChatRoom(nickname: String, completion: () -> Void)
    func leaveChatRoom(nickname: String, completion: () -> Void)
    func participantList(completion: @escaping (_ userList: [User]?) -> Void)
    func getMessage(completion: @escaping (_ messageInfo: Message?) -> Void)
    func sendMessage(message: String, withNickname nickname: String)
}

final class WebSockerService: NSObject, SocketServiceProtocol {
    
    static let shared = WebSockerService()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        
        guard let url = URL(string: SOCKET_HOST) else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
           
        guard let manager = manager else { return }
        socket = manager.socket(forNamespace: "/**********")
    }
    
    func establishConnection() {
        
        guard let socket = manager?.defaultSocket else { return }
        socket.connect()
    }
    
    func closeConnection() {
        
        guard let socket = manager?.defaultSocket else { return }
        socket.disconnect()
    }
    
    func joinChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else { return }
        socket.emit(SOCKET_CONNECTUSER, nickname)
        completion()
    }
        
    func leaveChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else { return }
        socket.emit(SOCKET_EXIT_USER, nickname)
        completion()
    }
    
    func participantList(completion: @escaping (_ userList: [User]?) -> Void) {

        guard let socket = manager?.defaultSocket else  { return }
        socket.on(SOCKET_USERLIST) { [weak self] (result, ack) in
            print("No default socket");

            guard result.count > 0,
                let _ = self,
                let user = result.first as? [[String: Any]],
                let data = UIApplication.parseDataToJson(from: user) else {
                print("No result");
                    return
            }
            
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completion(userModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
    
    func getMessage(completion: @escaping (_ messageInfo: Message?) -> Void) {
        
        guard let socket = manager?.defaultSocket else { return }
        
        socket.on(SOCKET_NEW_CHAT_MESSAGE) { (dataArray, socketAck) -> Void in
            
            var messageInfo = [String: Any]()
            
            guard let nickName = dataArray[0] as? String,
                let message = dataArray[1] as? String,
                let date = dataArray[2] as? String else{
                    return
            }
            
            messageInfo["nickname"] = nickName
            messageInfo["message"] = message
            messageInfo["date"] = date
            
            guard let data = UIApplication.parseDataToJson(from: messageInfo) else { return }

            do {
                let messageModel = try JSONDecoder().decode(Message.self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        
        guard let socket = manager?.defaultSocket else { return }
        socket.emit(SOCKET_CHAT_MESSAGE, nickname, message)
    }
}
