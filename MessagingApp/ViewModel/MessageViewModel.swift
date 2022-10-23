//
//  MessageViewModel.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation

final class MessageViewModel {
    
    var observable_messageArray : Rx<[ChatMessage]> = Rx<[ChatMessage]>([])
    
    func getMessagesFromServer() {
        
        CoreDataService.shared.loadItemsFromCache { coreDataMessages in
            self.observable_messageArray.value.append(contentsOf: coreDataMessages)
        }
        
        WebSockerService.shared.getMessage { [weak self] messageDataDict in
            var newMessages = [ChatMessage]()
            guard let _ = self,
                  
                  let messageData = messageDataDict else { return }
            
                newMessages.append(messageData)

            
            self?.observable_messageArray.value.append(messageData)
            CoreDataService.shared.saveItemsToCache(messageArray: newMessages)


        }
    }
}
