//
//  LoginController+handllers.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 14/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("error")
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            print("login successful")
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil, metadata != nil {
                        print(error ?? "")
                        return
                        
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["email": email, "profileImageUrl": profileImageUrl]
                            self.RegisterUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        })
        
    }
    private func RegisterUserIntoDatabaseWithUid(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
            if err != nil {
                print(err as Any)
                return
            }
            
            let user = User()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.messagesController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
            
            print("saved user sucessfully into firebase")
        })
    }
    @objc func handleSelectProfileImageview() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        } else {
            return
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
