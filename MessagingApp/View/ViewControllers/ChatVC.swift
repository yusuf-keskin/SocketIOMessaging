//
//  ChatVC.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit

class ChatVC: UIViewController {
    
    var user: User?
    var nickName: String?
    
    private var messageViewModel = MessageViewModel()
    
    var socketService : SocketServiceProtocol = WebSockerService.shared
    
    @IBOutlet weak var txtMessage: UITextView! {
        didSet {
            txtMessage.layer.cornerRadius = txtMessage.frame.height/2
            txtMessage.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var messageWritingView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        messageViewModel.observable_messageArray.subscribe { [weak self] result in
            guard let self = self else {
                return
            }
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom(animated: false)
        }
        messageViewModel.getMessagesFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureNavigation() {
        
        guard let user = user else { return }
        
        title = user.nickname
    }
    @IBAction func btnSendClick(_ sender: Any) {
        guard txtMessage.text.count > 0,
              let message = txtMessage.text,
              let name = nickName else {
            print("Please type your message.")
            return
        }
        
        txtMessage.resignFirstResponder()
        socketService.sendMessage(message: message, withNickname: name)
        txtMessage.text = nil
    }
    
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageViewModel.observable_messageArray.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageViewModel.observable_messageArray.value[indexPath.row]
        
        if message.nickname == self.nickName {
            guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatVCTableViewSentCell") as? ChatVCTableViewSentCell
            else { return UITableView.emptyCell()}
            cell.configureCell(message)
            return cell
        }
        
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatVCTableViewIncomingCell") as? ChatVCTableViewIncomingCell else {
            return UITableView.emptyCell() }
        cell.configureCell(message)
        
        return cell
    }
}
