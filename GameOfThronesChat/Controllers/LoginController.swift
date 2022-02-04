//
//  LoginController.swift
//  Gameofchat
//
//  Created by sarah sghair on 10/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
import SDLoader
import ElValidator

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 13)
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


class LoginController: UIViewController, UITextFieldDelegate {
    var messagesController: MessagesController?
    var register: RegisterViewController?
    var activeTextField: TextFieldValidator?

    //containerView
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
    
    let passwordForgoten: UIButton = {
       let label = UIButton(type: UIButtonType.system)
        label.setTitle("Forgot Password?", for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = UIColor(r: 145, g: 158, b: 196)
        label.contentMode = .center
        label.addTarget(self, action: #selector(handleForgotPass), for: .touchUpInside )
        return label
    }()
    @objc func handleForgotPass() {
        let alert = UIAlertController(title: "Coming Soon ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    //button
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 241, g: 53, b: 100)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Multiple", size: 16) //make the text label bold
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside )
        button.dropShadow(scale: true)
        return button
    }()
    //media
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
    lazy var RegisterButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "Group 4"), for: .normal)
        button.setTitle("or     SIGN UP  ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Multiple", size: 14) //make the text label bold
        button.addTarget(self, action: #selector(handleRegisterView), for: .touchUpInside )
        button.dropShadow(scale: true)
        return button
    }()
    @objc func handleRegisterView() {
        print("handled")
        register = RegisterViewController()
        self.navigationController?.pushViewController(register!, animated: true)
        register?.reloadInputViews()
    }
    
    func handleSignUp() {
        self.messagesController?.fetchUserAndSetupNavBarTitle()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //loading
    @objc func handleLogin() {
        if  !emailTextField.isValid() || !passwordTextField.isValid() {
            print("Form is not valid")
            
            let alert = UIAlertController(title: "Error", message: "Please Check your data", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return

        }
        guard let email = emailTextField.text ,let password = passwordTextField.text else { return  }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user,error) in
            
            if error != nil {
                print("error ")
                let alert = UIAlertController(title: "Error", message: "Wrong Password or email tap again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.sdLoader.stopAnimation()
                return
            }
            //seccufully loged in user
            self.sdLoader.stopAnimation()
            print("seccufully loged in user")
//            self.dismiss(animated: true, completion: nil)
        })
        
        sdLoader.startAnimating(atView: self.view)
    }
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
        etf.font = UIFont(name: "Avenir", size: 14)
        etf.tintColor = UIColor(r: 241, g: 53, b: 100)
        return etf
    }()
    //password
    var passwordTextField: TextFieldValidator = {
        let etf = TextFieldValidator()
        etf.placeholder = "Password"
        etf.translatesAutoresizingMaskIntoConstraints = false
        etf.isSecureTextEntry = true
        etf.leftViewMode = UITextFieldViewMode.always
        etf.tintColor = UIColor(r: 241, g: 53, b: 100)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: etf.frame.height))
        let imageView = UIImageView(frame: CGRect(x: 5, y: -10, width: 20, height: 20))
        let image = UIImage(named: "lock")
        imageView.image = image
        etf.leftView = paddingView
        paddingView.addSubview(imageView)
        etf.font = UIFont(name: "Avenir", size: 14)

        return etf
    }()
    
    //profile imageview
    lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .center
        return imageview
    }()
    
    let sdLoader: SDLoader = {
        let sd = SDLoader()
        sd.spinner?.lineWidth = 15
        sd.spinner?.spacing = 0.2
        sd.spinner?.sectorColor = UIColor(r: 241, g: 53, b: 100).cgColor
        sd.spinner?.textColor = UIColor(r: 241, g: 53, b: 100)
        sd.spinner?.animationType = AnimationType.anticlockwise
        return sd
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading
        let validationBlock = { [weak self] (errors: [Error]) -> Void in
            if let error = errors.first {
                print(error)
                self?.activeTextField?.textColor = UIColor(r: 208, g: 2, b: 27)
            } else {
                self?.activeTextField?.textColor = UIColor(r: 65, g: 117, b: 5)
            }
        }
        
        emailTextField.delegate =  self
        emailTextField.add(validator: PatternValidator(validationEvent: .perCharacter, pattern: .mail))
        emailTextField.validationBlock = validationBlock
        passwordTextField.delegate =  self
        passwordTextField.add(validator: LenghtValidator(validationEvent: .perCharacter, min: 6))
        passwordTextField.validationBlock = validationBlock
        view.backgroundColor = UIColor.white
        
        view.addSubview(containerViewForEmail)
        view.addSubview(containerViewForPass) //add the containerView to the viewcontrollr
        view.addSubview(loginRegisterButton) //add the button to the view
        view.addSubview(profileImageView) //add the image of the chat
        view.addSubview(passwordForgoten)
        setupInputsContainerView()
        setupInputsContainerViewPass() //set up the constrain of the container view
        setupLoginRegisterButton()
        setupImageView()
        setuppasswordForgotenContainers()
        setupMediaContrainer()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as? TextFieldValidator
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil;
        return true
    }
    
    func setupMediaContrainer() {
        view.addSubview(facebook)
        view.addSubview(twitter)
        view.addSubview(linked)
        view.addSubview(RegisterButton)
        
        //media
        facebook.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        facebook.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        facebook.rightAnchor.constraint(equalTo: linked.leftAnchor, constant: -36).isActive = true
        facebook.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        //
        linked.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        linked.leftAnchor.constraint(equalTo: facebook.rightAnchor, constant: -36).isActive = true
        linked.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        
        twitter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -59).isActive = true
        twitter.leftAnchor.constraint(equalTo: facebook.rightAnchor, constant: 100).isActive = true
        twitter.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        //button
        RegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        RegisterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: 150).isActive =  true
        RegisterButton.heightAnchor.constraint(equalToConstant: 57).isActive =  true
        
    }

    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var inputsContainerViewHeightAnchor2: NSLayoutConstraint?
    var emailtextfieledheightanchor: NSLayoutConstraint?
    var passwordtextfieledheightanchor: NSLayoutConstraint?
    var passwordtextfieledheightanchor2: NSLayoutConstraint?

    func setupInputsContainerViewPass() {
        containerViewForPass.addSubview(passwordTextField)
        // need x, y , height, width constraints
        containerViewForPass.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive =  true  //center to the intier view par rapport y
        containerViewForPass.leftAnchor.constraint(equalTo: containerViewForEmail.leftAnchor, constant: 0).isActive = true
        containerViewForPass.rightAnchor.constraint(equalTo: containerViewForEmail.rightAnchor, constant: 0).isActive = true
        containerViewForPass.topAnchor.constraint(equalTo: containerViewForEmail.topAnchor, constant: 100).isActive = true
        containerViewForPass.bottomAnchor.constraint(equalTo: loginRegisterButton.topAnchor, constant: -56).isActive = true
        containerViewForPass.heightAnchor.constraint(equalToConstant: 43).isActive =  true
        //text
        passwordTextField.leftAnchor.constraint(equalTo: containerViewForPass.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: containerViewForPass.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: containerViewForPass.widthAnchor).isActive = true
        //$$$$$$$$
        passwordtextfieledheightanchor?.isActive = false
        passwordtextfieledheightanchor = passwordTextField.heightAnchor.constraint(equalTo: containerViewForPass.heightAnchor)
        passwordtextfieledheightanchor?.isActive = true
        
    }
    func setupInputsContainerView() {
        containerViewForEmail.addSubview(emailTextField)
        // need x, y , height, width constraints
        
        containerViewForEmail.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -53).isActive = true
        containerViewForEmail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 63).isActive = true
        containerViewForEmail.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -63  ).isActive = true
        
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
    
    func setupLoginRegisterButton() {
        // need x, y , height, width constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        loginRegisterButton.topAnchor.constraint(equalTo: containerViewForPass.bottomAnchor, constant: 56).isActive = true
        
        loginRegisterButton.widthAnchor.constraint(equalTo: containerViewForPass.widthAnchor, constant: -56).isActive =  true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive =  true
    }
    
    func setuppasswordForgotenContainers() {
        // need x, y , height, width constraints
        passwordForgoten.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        passwordForgoten.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 50).isActive = true
        passwordForgoten.widthAnchor.constraint(equalToConstant: 179).isActive =  true
        passwordForgoten.heightAnchor.constraint(equalToConstant: 17).isActive =  true
    }
    func setupImageView() {
        // need x, y , height, width constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30).isActive =  true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: containerViewForEmail.topAnchor, constant: -53).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 208).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 109).isActive = true
    }
}
extension UIColor {
        convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
            self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        }
}


