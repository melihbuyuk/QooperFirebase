//
//  UIImageView.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 2.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit

extension UIImageView {
  public func maskCircle() {
    self.contentMode = UIView.ContentMode.scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.systemGreen.cgColor
    self.layer.masksToBounds = false
    self.clipsToBounds = true
  }
}
