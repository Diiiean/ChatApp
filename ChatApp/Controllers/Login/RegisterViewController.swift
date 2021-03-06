//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Диана Нуансенгси on 2.07.22.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.layer.borderColor = UIColor.systemMint.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        
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
        presentPhotoActionSheet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 100,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width / 2.0
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
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                // user alredy exists
                strongSelf.alertLoginUserError(message: "User already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard let strongSelf = self else {
                    return
                }
                guard authResult != nil, error == nil else {
                    print("Error creating a user")
                    return
                }
                //insert user to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        
            
        })
    }
       
    
    func alertLoginUserError(message: String = "Please enter all information to create a new account") {
        let alert = UIAlertController(title: "Wrong login!", message: message, preferredStyle: .actionSheet)
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentPhotoPicker()
            
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
