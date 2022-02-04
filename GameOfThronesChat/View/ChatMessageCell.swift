//
//  ChatMessageCell.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 15/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import AVFoundation
extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
}
private let reuseIdentifier = "Cell"

class ChatMessageCell: UICollectionViewCell {
    
    var messsage: Message?
    var chatlogController: ChatLogController?
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageButton = UIImage(named: "playButton")
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    @objc func handlePlay() {
        if let videoUrlString = messsage?.videoUrl, let url = NSURL(string: videoUrlString) {
            player = AVPlayer(url: url as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        return tv
    }()
    static let blueColor = UIColor(r: 241, g: 53, b: 100)
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        return view
    }()
    lazy var messgaeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if messsage?.videoUrl != nil {
            return
        }
        //pro tip
        if let imageView = tapGesture.view as? UIImageView {
            self.chatlogController?.performeZoomInForImageView(startingImageView: imageView)
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.roundedImage()
        return imageView
    }()
    
    
    var bubblewidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        bubbleView.addSubview(messgaeImageView)
        //ios 9 x y width height
        messgaeImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messgaeImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messgaeImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messgaeImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        bubbleView.addSubview(activityIndicatorView)
        //ios 9 x y width height
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        //ios 9 x y width height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32) .isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //ios 9 x y width height
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubblewidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubblewidthAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 x y width height
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -3).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
