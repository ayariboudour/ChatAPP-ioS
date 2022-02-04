//
//  ChatLogController.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 15/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let cellId = "cellId"
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid , let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snap: DataSnapshot) in
            let messagesId = snap.key
            let messagesRef = Database.database().reference().child("messages").child(messagesId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
               
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        //scroll to the las msg
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath , at: .bottom, animated: true)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatlogController = self
        let message = messages[indexPath.item]
        cell.messsage = message
        cell.textView.text = message.text
        setupCell(cell: cell, message: message)
        if let text = message.text {
            //a text msg
            cell.bubblewidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubblewidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        cell.playButton.isHidden = message.videoUrl == nil
        return cell
    }
    
    //pour modifier le design du cell
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            //outgoing gray
            cell.bubbleView.backgroundColor = UIColor.white
            cell.textView.textColor = UIColor.darkGray
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
        
        
        if let messageImageUrl = message.imageUrl {
            cell.messgaeImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messgaeImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else{
            cell.messgaeImageView.isHidden = true
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //height modifie
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimatedFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        //width modifie
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    @objc func handlebackend() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self , forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        setupKeyBoardObservers()
    }
    lazy var inputContainerVie: ChatInputContainerView = {
        let chatinputcontainerview = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatinputcontainerview.Chatlogcontroller = self
        return chatinputcontainerview
    }()
    
    @objc func handleUpLoadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerVie
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoselectedForUrl(url: videoUrl)
        }else{
            //we gonna select an image
            handleImageselectedForInfo(info: info as [String : AnyObject])
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    private func handleVideoselectedForUrl(url: URL) {
        let filename = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("Failed upload of video", error!)
                return
            }
            Storage.storage().reference().child("message_movies").child(filename).downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let videoUrl = url?.absoluteString {
                    if let thumbanailImage = self.thumbnailImageForVideoUrl(fileUrl: url!) {
                        self.uploadToFirebaseStorageUsingImage(image: thumbanailImage, completion: { (imageUrl) in
                            let proporties = ["imageUrl": imageUrl,"imageWidth": thumbanailImage.size.width,"imageHeight": thumbanailImage.size.height,"videoUrl": videoUrl] as [String : AnyObject]
                            self.sendMessageWithproperties(proporties: proporties)
                        })
                        
                    }
                }
            })
        })
        uploadTask.observe(.progress) { (snap) in
            if let completedUnitCount = snap.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
                

            }
        }
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    private func thumbnailImageForVideoUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    private func handleImageselectedForInfo(info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        } else {
            return
        }
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: {(imageUrl) in
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage,completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        if let uploadedData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadedData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed upload image ", error!)
                    return
                }
                //this completly change in swift 4
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let imageUrl = url?.absoluteString {
                        completion(imageUrl)
                    }
                })
            })
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboarDidShow), name: .UIKeyboardDidShow, object: nil)
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        //move the input area
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleKeyboarDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        //move the input area
        containerViewBottomAnchor?.constant = -(keyboardFrame!.height) - 38
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    
    private func sendMessageWithproperties(proporties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var values = ["toId": toId, "fromId": fromId!, "timestamp": timestamp] as [String : AnyObject]
        //append proporties
        // key = $0 , value = $1
        proporties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.inputContainerVie.inputTextFiled.text = nil
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!).child(toId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId).child(fromId!)
            recipientUserMessageRef.updateChildValues([messageId: 1])
        }
    }
    
    @objc func handleSend() {
        let properties = ["text": inputContainerVie.inputTextFiled.text!] as [String : AnyObject]
        sendMessageWithproperties(proporties: properties)
    }
    private func sendMessageWithImageUrl(imageUrl: String,image: UIImage) {
        let proporties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : AnyObject]
        sendMessageWithproperties(proporties: proporties)
    }
    
    
    var startingFrame: CGRect?
    var blackBackgroudView: UIView?
    var startingImageView: UIImageView?
    //my custom zomming logic
    func performeZoomInForImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroudView = UIView(frame: keyWindow.frame)
            blackBackgroudView?.backgroundColor = UIColor.black
            blackBackgroudView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroudView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               
                self.blackBackgroudView?.alpha = 1
                self.inputContainerVie.alpha = 0
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
//                do nothing
            })
        }
    }
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroudView?.alpha = 0
                self.inputContainerVie.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}
