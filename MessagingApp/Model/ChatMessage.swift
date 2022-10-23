//
//  Message.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation
import SocketIO

struct ChatMessage : Codable , SocketData{
    var date : String?
    var message : String?
    var nickname : String?
    var userNickname : String?
}


