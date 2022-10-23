//
//  ChatJoinVC.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit

class ChatJoinVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    private func joinChatRoom() {
        
        let alertController = UIAlertController(title: "Socket", message: "Please enter a name:", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            
            guard let textFields = alertController.textFields else { return }
            let textfield = textFields[0]
            
            if textfield.text?.count == 0 {
                self.joinChatRoom()
            } else {
                
                guard let nickName = textfield.text else { return }
                
                WebSockerService.shared.joinChatRoom(userName: nickName) { [weak self] in
                    guard let nickName = textfield.text,
                          let self = self else {
                        return
                    }
                    currentUser = nickName
                    self.moveToNextScreen(nickName)
                }
            }
        }
        print("heyheyheyheyheyhe" + currentUser)
        
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func moveToNextScreen(_ name: String) {
        print("-----------******************-----------")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("heyheyheyheyheyhe" + currentUser)
        
        guard let usersVC = storyboard.instantiateViewController(withIdentifier: "UsersVC") as? UsersVC else { return }
        
        usersVC.nickName = name
        self.navigationController?.pushViewController(usersVC, animated: true)
    }
    
    @IBAction func joinChatBtn(_ sender: UIButton) {
        joinChatRoom()
    }
    
}
