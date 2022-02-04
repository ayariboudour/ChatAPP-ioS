//
//  LoginController.swift
//  Gameofchat
//
//  Created by sarah sghair on 10/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
import ElValidator
import SDLoader
class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate {
    var messagesController: MessagesController?
var activeTextField: TextFieldValidator?
    let sdLoader: SDLoader = {
        let sd = SDLoader()
        sd.spinner?.lineWidth = 15
        sd.spinner?.spacing = 0.2
        sd.spinner?.sectorColor = UIColor(r: 241, g: 53, b: 100).cgColor
        sd.spinner?.textColor = UIColor(r: 241, g: 53, b: 100)
        sd.spinner?.animationType = AnimationType.anticlockwise
        return sd
    }()
    //containerView
    let containerViewForName: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  22.0
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        return view
    }()

    let containerViewForEmail: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  22.0
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        return view
    }()
    let containerViewForPass: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //arrondissement
        view.layer.cornerRadius =  22.0
        view.layer.masksToBounds = true
        view.dropShadow(scale: true)
        return view
    }()
    
    //name text field
    var nameTextField: TextFieldValidator = {
        let tf = TextFieldValidator()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.leftViewMode = UITextFieldViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: tf.frame.height))
        let imageView = UIImageView(frame: CGRect(x: 5, y: -10, width: 20, height: 20))
        let image = UIImage(named: "person")
        imageView.image = image
        tf.leftView = paddingView
        paddingView.addSubview(imageView)
        tf.leftView = paddingView
        tf.font = UIFont(name: "Avenir", size: 14)
        tf.tintColor = UIColor(r: 241, g: 53, b: 100)

        return tf
    }()
    
    
    //email
    var emailTextField: TextFieldValidator = {
        let etf = TextFieldValidator()
        etf.placeholder = "Email address"
        etf.translatesAutoresizingMaskIntoConstraints = false
        etf.leftViewMode = UITextFieldViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: etf.frame.height))
        let imageView = UIImageView(frame: CGRect(x: 5, y: -10, width: 20, height: 20))
        let image = UIImage(named: "person")
        imageView.image = image
        etf.leftView = paddingView
        paddingView.addSubview(imageView)
        etf.leftView = paddingView
        etf.font = UIFont(name: "Avenir", size: 14)
        etf.tintColor = UIColor(r: 241, g: 53, b: 100)

        return etf
    }()
func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField as? TextFieldValidator
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    activeTextField?.resignFirstResponder()
    activeTextField = nil;
    return true
}
    //password
    var passwordTextField: TextFieldValidator = {
        
        let etf = TextFieldValidator()
        etf.placeholder = "Password"
        etf.translatesAutoresizingMaskIntoConstraints = false
        etf.isSecureTextEntry = true
        etf.leftViewMode = UITextFieldViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: etf.frame.height))
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: -10, width: 20, height: 20))
        let image = UIImage(named: "lock")
        imageView.image = image
        etf.leftView = paddingView
        paddingView.addSubview(imageView)
        etf.leftView = paddingView
        etf.font = UIFont(name: "Avenir", size: 14)
        etf.tintColor = UIColor(r: 241, g: 53, b: 100)

        return etf
    }()
    lazy var facebook: UIButton = {
        let media = UIButton()
        let image = UIImage(named: "Facebook")
        media.setBackgroundImage(image, for: .normal)
        media.translatesAutoresizingMaskIntoConstraints = false
        media.addTarget(self, action: #selector(handleMedia), for: .touchUpInside )
        return media
    }()
    lazy var twitter: UIButton = {
        let media = UIButton()
        let image = UIImage(named: "Twitter")
        media.setBackgroundImage(image, for: .normal)
        media.translatesAutoresizingMaskIntoConstraints = false
        media.addTarget(self, action: #selector(handleMedia), for: .touchUpInside )
        return media
    }()
    lazy var linked: UIButton = {
        let media = UIButton()
        let image = UIImage(named: "Linked")
        media.setBackgroundImage(image, for: .normal)
        media.translatesAutoresizingMaskIntoConstraints = false
        media.addTarget(self, action: #selector(handleMedia), for: .touchUpInside )
        return media
    }()
    @objc func handleMedia() {
        let alert = UIAlertController(title: "Coming Soon ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    lazy var SignInButon: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "Group 4-1"), for: .normal)
        button.setTitle("or     SIGN IN  ", for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Multiple", size: 14) //make the text label bold
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside )
        button.dropShadow(scale: true)
        
        return button
    }()
    
    
    //profile imageview
    lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.image = UIImage(named: "camera (2)")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleToFill
        imageview.layer.cornerRadius = 30
        imageview.clipsToBounds = true
        imageview.layer.borderWidth = 0.2
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        imageview.layer.masksToBounds = true
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageview)))
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
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
    //button
    lazy var RegisterButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 241, g: 53, b: 100)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Multiple", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside )
        button.dropShadow(scale: true)
        return button
    }()
    
    @objc func handleRegister() {
        if  !emailTextField.isValid() || !passwordTextField.isValid() || !nameTextField.isValid() {
            print("Form is not valid")
            let alert = UIAlertController(title: "Error", message: "Please check your data", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard let email = emailTextField.text ,let password = passwordTextField.text, let name = nameTextField.text else { return  }
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("error")
                let alert = UIAlertController(title: "Error", message: "Check your informations", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
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
                        print(error!)
                        return
                        
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        //houni badalt
                        if error != nil {
                            print(error!.localizedDescription)
                            self.sdLoader.stopAnimation()
                            let alert = UIAlertController(title: "Error", message: "Check your informations", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name" : name ,"email": email,"password" : password, "profileImageUrl": profileImageUrl]
                            self.RegisterUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                            self.sdLoader.stopAnimation()

                        }
                    })
                })
            }
        })
        sdLoader.startAnimating(atView: self.view)

        
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
            user.password = values["password"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.messagesController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
            
            print("saved user sucessfully into firebase")
        })
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let validationBlock = { [weak self] (errors: [Error]) -> Void in
            if let error = errors.first {
                print(error)
                self?.activeTextField?.textColor = UIColor(r: 208, g: 2, b: 27)
            } else {
                self?.activeTextField?.textColor = UIColor(r: 65, g: 117, b: 5)
            }
        }
        
        nameTextField.delegate =  self
        nameTextField.add(validator: LenghtValidator(validationEvent: .perCharacter, min: 1))
        nameTextField.validationBlock = validationBlock
        emailTextField.delegate =  self
        emailTextField.add(validator: PatternValidator(validationEvent: .perCharacter, pattern: .mail))
        emailTextField.validationBlock = validationBlock
        
        passwordTextField.delegate =  self
        passwordTextField.add(validator: LenghtValidator(validationEvent: .perCharacter, min: 6))
        passwordTextField.validationBlock = validationBlock
        view.backgroundColor = UIColor.white
        
        view.backgroundColor = UIColor.white
        view.addSubview(containerViewForName)
        view.addSubview(containerViewForEmail)
        view.addSubview(containerViewForPass)//add the containerView to the viewcontrollr
        view.addSubview(RegisterButton)//add the button to the view
        view.addSubview(profileImageView)
        view.addSubview(facebook)
        view.addSubview(linked)
        view.addSubview(twitter)

        view.addSubview(SignInButon)//add the image of the chat
        setupInputsNameContainerView()
        setupmailconstraint()//set up the constrain of the container view
        setupInputsContainerViewPass()
        setupLoginRegisterButton()
        setupImageView()
        setupMediaContrainer()
    }
 
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nametextfieledheightanchor: NSLayoutConstraint?
    var emailtextfieledheightanchor: NSLayoutConstraint?
    var passwordtextfieledheightanchor: NSLayoutConstraint?
    
    //setup the containers

    
    func setupInputsNameContainerView() {
        containerViewForName.addSubview(nameTextField)

        // need x, y , height, width constraints
        containerViewForName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 56).isActive = true
        containerViewForName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        containerViewForName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        containerViewForName.heightAnchor.constraint(equalToConstant: 43).isActive =  true
        // need x, y , height, width constraints
        nameTextField.leftAnchor.constraint(equalTo: containerViewForName.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: containerViewForName.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: containerViewForName.widthAnchor).isActive = true
        //$$$$$$$$
        nametextfieledheightanchor?.isActive = false
        nametextfieledheightanchor = nameTextField.heightAnchor.constraint(equalTo: containerViewForName.heightAnchor)
        nametextfieledheightanchor?.isActive = true
    }
    
    func setupmailconstraint() {
        containerViewForEmail.addSubview(emailTextField)
        // need x, y , height, width constraints
        containerViewForEmail.topAnchor.constraint(equalTo: containerViewForName.bottomAnchor, constant: 40).isActive = true
        containerViewForEmail.leftAnchor.constraint(equalTo: containerViewForName.leftAnchor, constant: 0).isActive = true
        containerViewForEmail.rightAnchor.constraint(equalTo: containerViewForName.rightAnchor, constant: 0).isActive = true
        containerViewForEmail.heightAnchor.constraint(equalToConstant: 43).isActive =  true
        // need x, y , height, width constraints
        emailTextField.leftAnchor.constraint(equalTo: containerViewForEmail.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: containerViewForEmail.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: containerViewForEmail.widthAnchor).isActive = true
        //$$$$$$$$
        emailtextfieledheightanchor?.isActive = false
        emailtextfieledheightanchor = emailTextField.heightAnchor.constraint(equalTo: containerViewForEmail.heightAnchor)
        emailtextfieledheightanchor?.isActive = true
    }
    func setupInputsContainerViewPass() {
        containerViewForPass.addSubview(passwordTextField)
        // need x, y , height, width constraints
        containerViewForPass.topAnchor.constraint(equalTo: containerViewForEmail.bottomAnchor, constant: 40).isActive = true
        containerViewForPass.leftAnchor.constraint(equalTo: containerViewForName.leftAnchor, constant: 0).isActive = true
        containerViewForPass.rightAnchor.constraint(equalTo: containerViewForName.rightAnchor, constant: 0).isActive = true
        containerViewForPass.heightAnchor.constraint(equalToConstant: 43).isActive =  true
        // need x, y , height, width constraints
        passwordTextField.leftAnchor.constraint(equalTo: containerViewForPass.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: containerViewForPass.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: containerViewForPass.widthAnchor).isActive = true
        passwordtextfieledheightanchor?.isActive = false
        passwordtextfieledheightanchor = passwordTextField.heightAnchor.constraint(equalTo: containerViewForPass.heightAnchor)
        passwordtextfieledheightanchor?.isActive = true
    }
    func setupMediaContrainer() {
        //button
        SignInButon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        SignInButon.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        SignInButon.widthAnchor.constraint(equalToConstant: 150).isActive =  true
        SignInButon.heightAnchor.constraint(equalToConstant: 57).isActive =  true
        //media
        facebook.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        facebook.leftAnchor.constraint(equalTo: SignInButon.rightAnchor, constant: 36).isActive = true
        facebook.rightAnchor.constraint(equalTo: linked.leftAnchor, constant: -36).isActive = true
        facebook.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        linked.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        linked.leftAnchor.constraint(equalTo: facebook.rightAnchor, constant: -36).isActive = true
        linked.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        
        twitter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        twitter.leftAnchor.constraint(equalTo: facebook.rightAnchor, constant: 100).isActive = true
        twitter.heightAnchor.constraint(equalToConstant: 30).isActive =  true
    }
    func setupLoginRegisterButton() {
        // need x, y , height, width constraints
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        RegisterButton.topAnchor.constraint(equalTo: containerViewForPass.bottomAnchor, constant: 56).isActive = true
        
        RegisterButton.widthAnchor.constraint(equalTo: containerViewForPass.widthAnchor, constant: -56).isActive =  true
        RegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive =  true
    }
    func setupImageView() {
        // need x, y , height, width constraints
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 150).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150).isActive = true

        profileImageView.addConstraint(NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
    }
}



