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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func joinToChat(_ sender: Any) {
        if displayName.text != nil {
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
    
}
