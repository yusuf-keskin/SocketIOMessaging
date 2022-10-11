//
//  MessageViewModel.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation

final class MessageViewModel {
    
    var observable_messageArray : Rx<[Message]> = Rx<[Message]>([])
    
    func getMessagesFromServer() {
        WebSockerService.shared.getMessage { [weak self] messageDataDict in
            guard let _ = self,
                  let messageData = messageDataDict else { return }
            
            self?.observable_messageArray.value.append(messageData)
        }
    }
}
