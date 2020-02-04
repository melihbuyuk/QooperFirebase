//
//  ChatViewController.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, Instantiable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageInput: UITextView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var keyboardSafeAreaBottomConstraints: NSLayoutConstraint!
    

    var senderName: String!
    var roomRef: DatabaseReference?
    var room: Room? {
        didSet {
            title = room?.name
        }
    }
    var chat = [Chat]()
    
    static var storyboardName: StringConvertible {
        return StoryboardName.main
    }
    
    private lazy var chatRef: DatabaseReference = self.roomRef!.child("messages")
    private var messageHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        messageInput.layer.borderColor = UIColor.lightGray.cgColor
        messageInput.layer.borderWidth = 1.0

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        observeMessages()
    }
    
    func observeMessages() {
        chatRef = roomRef!.child("messages")
        let query = chatRef.queryLimited(toLast: 30)
        
        messageHandle = query.observe(.childAdded, with: { (snapshot) -> Void in
            let message = snapshot.value as! Dictionary<String, String>
            
            if let id = message["senderId"] as String?,
               let name = message["senderName"] as String?,
               let text = message["text"] as String?, text.count > 0 {
                self.chat.append(Chat(senderId: id, senderName: name, text: text))

                self.tableView.reloadData()
            }
            
        })
    }

    func updateLastRow() {
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: self.chat.count - 1, section: 0)

            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [lastIndexPath], with: .none)
            self.tableView.endUpdates()

            self.tableView.layoutIfNeeded()

            self.tableView.scrollToRow(at: lastIndexPath,
                                       at: UITableView.ScrollPosition.bottom,
                                       animated: true)
        }
    }

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardSafeAreaBottomConstraints?.constant = 0.0
            } else {
                self.keyboardSafeAreaBottomConstraints?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    @IBAction func senderButton(_ sender: Any) {
        let itemRef = chatRef.childByAutoId()
        let messageItem = [
            "senderId": Auth.auth().currentUser?.uid,
            "senderName": senderName,
            "text": messageInput.text,
            ]
        
        itemRef.setValue(messageItem)
        
        messageInput.text = nil
        self.isEditing = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.chatSetup(chat: chat[indexPath.row])
        return cell
    }
}
