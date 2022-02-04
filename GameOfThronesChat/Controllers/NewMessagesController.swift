//
//  NewMessagesController.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 13/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
class NewMessagesController: UITableViewController {
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "messages"
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        tableView.separatorStyle = .none
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: {(snap: DataSnapshot) in
            if let dictionary = snap.value as? [String: AnyObject]{
                let user = User()
                user.id = snap.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.password = dictionary["password"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                print(self.users)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)

    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let view = UIView(frame: CGRect(x: 5, y: 20, width: cell.frame.width - 10, height: cell.frame.height - 40))
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  view.frame.height / 2.0
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        cell.contentView.insertSubview(view, at: 0)
    
        cell.selectionStyle = .none
        let user = users[indexPath.row]
        print(user)
        cell.textLabel?.text = user.name
        print(indexPath.row)
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    var messagescontroller: MessagesController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
             print("Dissmiss completed")
            let user = self.users[indexPath.row]
            self.messagescontroller?.showChatControllerForUser(user: user)
        }
    }
}

