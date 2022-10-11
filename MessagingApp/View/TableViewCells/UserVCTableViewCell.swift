//
//  UserVCTableViewCell.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import UIKit

class UserVCTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userOnlineStatusLbl: UIView! {
        didSet {
            userOnlineStatusLbl.layer.cornerRadius = userOnlineStatusLbl.frame.width/2
        }
    }
    
    
    func configureCell(_ user: User) {
        userNameLbl.text = user.nickname ?? ""
        userOnlineStatusLbl.isHidden = !(user.isConnected ?? false)
    }

}
