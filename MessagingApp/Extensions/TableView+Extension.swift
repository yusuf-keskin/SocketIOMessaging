//
//  TableView+Extension.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    static func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollToBottom(animated : Bool = true) {
        DispatchQueue.main.async {
            var yOffset : CGFloat =  0.0
            if self.contentSize.height > self.bounds.size.height {
                yOffset = self.contentSize.height - self.bounds.size.height
            }
            self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }
}
