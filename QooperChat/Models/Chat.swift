//
//  Chat.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import Foundation
import Firebase

 class Chat {
    
    var senderId: String?
    var senderName: String?
    var text: String?
    
    init(senderId: String, senderName: String, text: String) {
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
    }
    
    
}
