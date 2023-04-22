//
//  ViewController.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit


typealias SelectedUserMessagesHandler = (User)-> Void

class UsersVC: UIViewController {
    
    var socketService : SocketServiceProtocol = WebSockerService.shared
    
    var userArray = [User]()
    var nickName: String?
    private var userModel = ChatViewModel()
    var usersHandler : SelectedUserMessagesHandler?
    
    @IBOutlet weak var usersTableView: UITableView!
     
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        usersTableView.delegate = self
        usersTableView.dataSource = self
        userModel.observable_usersArray.subscribe { [weak self] _ in
            DispatchQueue.main.async {
                self!.usersTableView.reloadData()
            }
            self?.userModel.fetchParticipantsList((self?.nickName)!)
        }
    }
}


extension UsersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userModel.observable_usersArray.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserVCTableViewCell", for: indexPath) as! UserVCTableViewCell
        let index = userModel.observable_usersArray.value[indexPath.row]
        cell.configureCell(index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? UserVCTableViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else { return }
        
        let user: User = userModel.observable_usersArray.value[indexPath.row]
        chatVC.nickName = selectedCell?.userNameLbl.text
        chatVC.user = user

        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}


extension UsersVC {
    
    private func configuration() {
        
        guard let name = nickName else { return }
        
        title = "Welcome \(name)"
        configureNavigationRightBarButton()

    }
    
    private func configureNavigationRightBarButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Exit",
            style: .done,
            target: self,
            action: #selector(exitButtonCLK)
        )
    }
}

// MARK:- Action Events -
extension UsersVC {
    
    @objc func exitButtonCLK() {
        
        guard let name = nickName else { return }
        
        socketService.leaveChatRoom(nickname: name) { [weak self] in
            
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}




