//
//  ChatRoomViewController.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, Instantiable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var senderDisplayName: String!
    private var rooms: [Room] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40.0))
        return textField
        
    }()
    
    static var storyboardName: StringConvertible {
        return StoryboardName.main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createChannelAlert))
        self.title = "Chat Rooms"
        self.tableView.tableFooterView = UIView(frame: .zero)
        observeChannels()
    }
    
    @objc func createChannelAlert() {
        channelAlert()
    }
    
    private func configurationTextField(textField: UITextField!){
        self.textField = textField!
        self.textField.placeholder = "Channel Name"
    }
    
    private func channelAlert() {
        let alert = UIAlertController(title: "Create Channel",
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Create", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            print(self.textField.text!)
            self.createChannel()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func createChannel() {
        if let name = textField.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name
            ]
            newChannelRef.setValue(channelItem)
        }
    }

    private func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String?, name.count > 0 {
                self.rooms.append(Room(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
        cell.roomSetup(room: rooms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController.instantiateFromStoryboard()
        chatVC.senderName = senderDisplayName
        chatVC.room = rooms[indexPath.row]
        chatVC.roomRef = channelRef.child(rooms[indexPath.row].id!)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

}
