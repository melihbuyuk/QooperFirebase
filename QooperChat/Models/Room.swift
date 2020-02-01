//
//  Room.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import Foundation

class Room {
    var id: String?
    var name: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
