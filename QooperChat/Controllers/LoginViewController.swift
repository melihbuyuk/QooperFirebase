//
//  LoginViewController.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var joinChat: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName.layer.cornerRadius = 5.0
        displayName.layer.borderColor = UIColor.lightGray.cgColor
        displayName.layer.borderWidth = 1.0
        displayName.paddingLeft(inset: 10)
        avatarView.maskCircle()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    @IBAction func joinToChat(_ sender: Any) {
        if displayName.text!.count > 0 {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let chatromVC = ChatRoomViewController.instantiateFromStoryboard()
                chatromVC.senderDisplayName = self.displayName!.text
                self.navigationController?.pushViewController(chatromVC, animated: true)
                
            }
        } else {
            print("Please enter your name")
        }
    }
    
    @IBAction func openPicker(_ sender: AnyObject) {
        self.imagePicker.present(from: self.view)
    }
    
}

extension LoginViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.avatarView.image = image
    }
}
