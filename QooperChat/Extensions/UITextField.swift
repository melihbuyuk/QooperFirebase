//
//  UITextField.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 2.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit

extension UITextField {
    func paddingLeft(inset: CGFloat){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.leftViewMode = UITextField.ViewMode.always
    }
}
