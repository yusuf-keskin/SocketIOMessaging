//
//  ChatViewModel.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation
 
final class ChatViewModel {
    
    var observable_usersArray : Rx<[User]> = Rx<[User]>([])
    
    func fetchParticipantsList( _ name : String) {

        WebSockerService.shared.participantList{ [weak self] userlist in
            print( "Hey")
            guard let _ = self,
                  let users = userlist else { return }
            
            var filteredUsers : [User] = users
            
            if let index = filteredUsers.firstIndex(where: {$0.nickname == name}) {
                filteredUsers.remove(at: index)
            }
            
            self?.observable_usersArray.value = filteredUsers
        }
    }
}




