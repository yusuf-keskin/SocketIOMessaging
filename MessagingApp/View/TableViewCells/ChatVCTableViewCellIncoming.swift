//
//  ChatVCTableViewIncomingCell.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit

class ChatVCTableViewIncomingCell: UITableViewCell {
    
    @IBOutlet weak var incomingMessageLbl: UILabel!
    @IBOutlet weak var incomingMessageDate: UILabel!
    
    func configureCell(_ message: ChatMessage) {
        incomingMessageLbl.backgroundColor = #colorLiteral(red: 0.7080285465, green: 0.95605184, blue: 0.9686274529, alpha: 1)
        incomingMessageLbl.layer.cornerRadius = 10
        incomingMessageLbl.bounds.size.width += 2
        incomingMessageLbl.bounds.size.height += 2
     
        self.incomingMessageLbl.text = message.message ?? ""
        self.incomingMessageDate.text = message.date ?? ""
    }

}
