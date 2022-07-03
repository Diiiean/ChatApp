//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Диана Нуансенгси on 2.07.22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let firstNameField: UITextField = {
        let emailfield = UITextField()
        emailfield.autocapitalizationType = .none
        emailfield.autocorrectionType = .no
        emailfield.returnKeyType = .continue
        emailfield.layer.cornerRadius = 12
        emailfield.layer.borderWidth = 1
        emailfield.layer.borderColor = UIColor.lightGray.cgColor
        emailfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailfield.leftViewMode = .always
        emailfield.backgroundColor = .white
        emailfield.placeholder = "First name..."
        return emailfield
    }()
    private let lastNameField: UITextField = {
        let emailfield = UITextField()
        emailfield.autocapitalizationType = .none
        emailfield.autocorrectionType = .no
        emailfield.returnKeyType = .continue
        emailfield.layer.cornerRadius = 12
        emailfield.layer.borderWidth = 1
        emailfield.layer.borderColor = UIColor.lightGray.cgColor
        emailfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailfield.leftViewMode = .always
        emailfield.backgroundColor = .white
        emailfield.placeholder = "Last name..."
        return emailfield
    }()
    private let emailField: UITextField = {
        let emailfield = UITextField()
        emailfield.autocapitalizationType = .none
        emailfield.autocorrectionType = .no
        emailfield.returnKeyType = .continue
        emailfield.layer.cornerRadius = 12
        emailfield.layer.borderWidth = 1
        emailfield.layer.borderColor = UIColor.lightGray.cgColor
        emailfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailfield.leftViewMode = .always
        emailfield.backgroundColor = .white
        emailfield.placeholder = "Email Adress..."
        return emailfield
    }()
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Enter password..."
        return passwordField
    }()
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemMint
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Register",
            style: .done,
            target: self,
            action: #selector(didTapRegister))
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,                           action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        
    }
    @objc private func didTapChangeProfilePic() {
        print("Change pic tapped")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 100,
                                 width: size,
                                 height: size)
        firstNameField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        lastNameField.frame = CGRect(x: 30,
                                  y: firstNameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        registerButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
        
    }
    @objc private func registerButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()

        guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let password = passwordField.text, !firstName.isEmpty, !email.isEmpty, !lastName.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertLoginUserError()
            return
            
        }
        
        // Firebase log in
        
    }
    
    func alertLoginUserError() {
        let alert = UIAlertController(title: "Wrong login!", message: "Please enter all information to create a new account", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}
