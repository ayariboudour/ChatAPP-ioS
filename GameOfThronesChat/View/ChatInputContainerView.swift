//
//  ChatInputContainerView.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 23/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
class ChatInputContainerView: UIView, UITextFieldDelegate {
    var Chatlogcontroller: ChatLogController? {
        didSet {
            sendButton.addTarget(Chatlogcontroller, action: #selector(Chatlogcontroller?.handleSend), for: .touchUpInside)
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: Chatlogcontroller, action: #selector(Chatlogcontroller?.handleUpLoadTap)))

        }
    }
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "add image")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    let sendButton = UIButton(type: .system)
    lazy var inputTextFiled: UITextField = {
        let TextFiled = UITextField()
        TextFiled.attributedPlaceholder = NSAttributedString(string: "Type message...",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        TextFiled.translatesAutoresizingMaskIntoConstraints = false
        TextFiled.delegate = self
        TextFiled.textColor = .white
        return TextFiled
    }()
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 241, g: 53, b: 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  11
        view.layer.masksToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        backgroundColor = .white
        container.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 45).isActive = true
        container.addSubview(uploadImageView)
        //x y w h
        uploadImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        let img = UIImage(named: "send")
        
        sendButton.setBackgroundImage(img, for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        //chidu
       container.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        container.addSubview(self.inputTextFiled)
        //x y w h
        self.inputTextFiled.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor , constant: 8).isActive = true
        self.inputTextFiled.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        self.inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextFiled.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Chatlogcontroller?.handleSend()
        return true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
