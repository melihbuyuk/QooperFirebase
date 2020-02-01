//
//  ChatCell.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 2.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func chatSetup(chat: Chat) {
        print(chat.text!)
        
        self.senderName.text = chat.senderName
        self.message.text = chat.text
    }
}
