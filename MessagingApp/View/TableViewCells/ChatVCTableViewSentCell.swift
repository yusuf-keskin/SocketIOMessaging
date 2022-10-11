//
//  ChatVCTableViewSentCell.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit

class ChatVCTableViewSentCell: UITableViewCell {

    @IBOutlet weak var sentMessageLbl: UILabel!
    @IBOutlet weak var sentMessageDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ message: Message) {
        sentMessageLbl.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.8767130171, blue: 0.7569885576, alpha: 1)
        self.sentMessageLbl.text = message.message ?? ""
        self.sentMessageDate.text = message.date ?? ""
    }

}
