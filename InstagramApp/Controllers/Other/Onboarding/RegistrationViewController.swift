//
//  RegistrationViewController.swift
//  InstagramApp
//
//  Created by 陳飛 on 31/3/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameFields: UITextField = {
        let field = UITextField()
        field.placeholder = "Username..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let emailFields: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordFields: UITextField = {
        let field = UITextField()
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        usernameFields.delegate = self
        emailFields.delegate = self
        passwordFields.delegate = self
        
        addSubviews()

        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameFields.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top + 100,
            width: view.width-40,
            height: 52.0
        )
        
        emailFields.frame = CGRect(
            x: 20,
            y: usernameFields.bottom + 10,
            width: view.width-40,
            height: 52.0
        )
        
        passwordFields.frame = CGRect(
            x: 20,
            y: emailFields.bottom + 10,
            width: view.width-40,
            height: 52.0
        )
        
        registerButton.frame = CGRect(
            x: 20,
            y: passwordFields.bottom + 10,
            width: view.width-40,
            height: 52.0
        )
    }
    
    @objc func didTapRegister() {
        
        usernameFields.resignFirstResponder()
        emailFields.resignFirstResponder()
        passwordFields.resignFirstResponder()
        
        guard let username = usernameFields.text, !username.isEmpty,
              let email = emailFields.text, !email.isEmpty,
              let password = passwordFields.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            
            DispatchQueue.main.async {
                if registered {
                    // good to go
                    print("Success.")
                }
                else {
                    // failed
                    print("Fail.")
                }
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(usernameFields)
        view.addSubview(emailFields)
        view.addSubview(passwordFields)
        view.addSubview(registerButton)
    }

}


extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameFields {
            emailFields.becomeFirstResponder()
        }
        else if textField == emailFields {
            passwordFields.becomeFirstResponder()
        }
        else {
            didTapRegister()
        }
        
        return true
    }
}
