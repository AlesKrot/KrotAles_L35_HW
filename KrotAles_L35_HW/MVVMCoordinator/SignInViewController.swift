//
//  SignInViewController.swift
//  MVVMCoordinator
//
//  Created by Max Bystryk on 16.02.2022.
//

import Foundation
import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    func signInViewControllerDidTapForgotPasswordButton(_ controller: SignInViewController)
    func signInViewControllerDidTapSignUpButton(_ controller: SignInViewController)
    func signInViewController(_ controller: SignInViewController, signedInWith userSession: UserSession)
}

class SignInViewController: UIViewController {
    weak var delegate: SignInViewControllerDelegate?
    
    func signIn(with login: String, password: String) {
        //sign in logic should be implemented here
        
        //real user session should be received from server
        let userSession = UserSession(token: "fdf3hfkjh3f3hr", userName: "Zorg999")
        delegate?.signInViewController(self, signedInWith: userSession)
    }
    
    @IBAction func signInDidTap(_ sender: UIButton) {
        //value from text fields should be taken
        signIn(with: "login", password: "password")
    }
    
    @IBAction func forgotPasswordDidTap(_ sender: UIButton) {
        delegate?.signInViewControllerDidTapForgotPasswordButton(self)
    }
    
    @IBAction func signUpDidTap(_ sender: UIButton) {
        delegate?.signInViewControllerDidTapSignUpButton(self)
    }
}
