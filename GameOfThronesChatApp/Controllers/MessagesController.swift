//
//  ViewController.swift
//  Gameofchat
//
//  Created by sarah sghair on 10/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
class MessagesController: UITableViewController {
    
    var cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "message")
        //ajouter icon

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true //pour view the delete button
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let message = self.messages[indexPath.row]
            if let chatPartnerId = message.chatPartnerId(){
                Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (err, ref) in
                    if err != nil {
                        print("failled deleted messgae \(err!)")
                        return
                    }
                    self.messagesDictionary.removeValue(forKey: chatPartnerId)
                    self.attemptReloadOfTable()
                })
            }
        }
        delete.backgroundColor = UIColor(r: 248, g: 202, b: 215)
        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
            // share item at indexPath
        }
    
        share.backgroundColor = UIColor(r: 248, g: 202, b: 215)
        
        return [delete, share]

    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            let userId = snapshot.key
            ref.child(userId).observe(.childAdded, with: { (snap) in
                let messageId = snap.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }, withCancel: nil)
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshout) in
            print(snapshout.key)
            print(self.messagesDictionary)
            self.messagesDictionary.removeValue(forKey: snapshout.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    func fetchMessageWithMessageId(messageId: String) {
        let messageReference = Database.database().reference().child("messages").child(messageId)
        messageReference.observeSingleEvent(of: .value, with: { (snap: DataSnapshot) in
            if let dictionary = snap.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let msg = messages[indexPath.row]
        cell.msg = msg
        let view = UIView(frame: CGRect(x: 5, y: 20, width: cell.frame.width - 10, height: cell.frame.height - 40))
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  view.frame.height / 2.0
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        cell.contentView.insertSubview(view, at: 0)
        
        cell.selectionStyle = .none
       
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = messages[indexPath.row]
        guard let chatPartnerId = msg.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snap: DataSnapshot) in
            print(snap)
            guard let dictionary = snap.value as? [String: AnyObject] else {
                return
            }
            let user = User()
            user.id = chatPartnerId
            user.password = dictionary["password"] as? String
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            self.showChatControllerForUser(user: user)
        }, withCancel: nil)
    }
    
    
    @objc func handleNewMessage() {
        let newmessageController = NewMessagesController()
        newmessageController.messagescontroller = self
        let navController = UINavigationController(rootViewController: newmessageController)
       present(navController, animated: true, completion: nil)
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavBarTitle()
            
        }
    }
    
    
  func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with:{ (snapshot) in
            if let dictonary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.name = dictonary["name"] as? String
                user.email = dictonary["email"] as? String
                user.profileImageUrl = dictonary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
                
            }}, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.textColor = UIColor(r: 68, g: 72, b: 81)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        //ios 9 constrains anchor x y width and height
        titleView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleView
        
    }
    
    
    @objc func showChatControllerForUser(user: User) {
        let chatlogcontroller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatlogcontroller.user = user
        navigationController?.pushViewController(chatlogcontroller, animated: true)
    }
    
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let logincontroller = LoginController()
        logincontroller.messagesController = self
        let navContr : UINavigationController? = UINavigationController()
        navContr?.isNavigationBarHidden = true
    
        navContr?.setViewControllers([logincontroller], animated: false)
        present(navContr!, animated: true, completion: nil)
    }
    
}

