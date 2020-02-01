//
//  RoomCell.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    @IBOutlet weak var roomName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func roomSetup(room: Room) {
        self.roomName.text = room.name
    }
}
