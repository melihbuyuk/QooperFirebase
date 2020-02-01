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
        
        messageInput.layer.borderColor = UIColor.black.cgColor
        messageInput.layer.borderWidth = 1.0
        
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
    
    
    @IBAction func senderButton(_ sender: Any) {
        let itemRef = chatRef.childByAutoId()
        let messageItem = [
            "senderId": Auth.auth().currentUser?.uid,
            "senderName": senderName,
            "text": messageInput.text,
            ]
        
        itemRef.setValue(messageItem)
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
