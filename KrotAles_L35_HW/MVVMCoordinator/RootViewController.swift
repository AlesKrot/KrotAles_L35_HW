//
//  ViewController.swift
//  MVVMCoordinator
//
//  Created by Max Bystryk on 13.02.2022.
//

import UIKit

struct UserSession {
    let token: String
    let userName: String
}

class UserSessionManager {
    private(set) var userSession: UserSession?
    
    //Manager that handles user session, make api call etc.
}

protocol LoginCoordinatorDelegate {
    func loginCoordinator(_ coordinator: LoginCoordinator, didExitWith userSession: UserSession)
}

class RootViewController: UIViewController {
    private var loginCoordinator: LoginCoordinator?
    private var mainCoordinator: MainCoordinator?
    private var userSessionManager: UserSessionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        handleUserSession()
    }
    
    func handleUserSession() {
        guard let userSession = userSessionManager?.userSession else {
            loginCoordinator = LoginCoordinator(rootParentController: self,
                                                delegate: self)
            loginCoordinator?.activate()

            return
        }
        
        activateMainCoordinator(with: userSession)
    }
    
    func activateMainCoordinator(with userSession: UserSession) {
        mainCoordinator = MainCoordinator(rootParentController: self,
                                          userSession: userSession)
        mainCoordinator?.activate()
    }
}

extension RootViewController: LoginCoordinatorDelegate {
    func loginCoordinator(_ coordinator: LoginCoordinator, didExitWith userSession: UserSession) {
        coordinator.deactivate()
        activateMainCoordinator(with: userSession)
    }
}


class LoginCoordinator {
    private unowned var rootParentController: UIViewController
    private var navigationController: UINavigationController?
    
    var delegate: LoginCoordinatorDelegate?
    
    init(rootParentController: UIViewController, delegate: LoginCoordinatorDelegate?) {
        self.delegate = delegate
        self.rootParentController = rootParentController
    }
    
    func activate() {
        let signInController = SignInViewController()
        navigationController = UINavigationController(rootViewController: signInController)
        signInController.delegate = self
        rootParentController.add(navigationController!)
    }
    
    func deactivate() {
        navigationController?.remove()
        navigationController = nil
    }
}

extension LoginCoordinator: SignInViewControllerDelegate {
    func signInViewControllerDidTapForgotPasswordButton(_ controller: SignInViewController) {
        //navigate to appropriate view controller
        
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func signInViewControllerDidTapSignUpButton(_ controller: SignInViewController) {
        //navigate to appropriate view controller
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func signInViewController(_ controller: SignInViewController, signedInWith userSession: UserSession) {
        delegate?.loginCoordinator(self, didExitWith: userSession)
    }
}


class MainCoordinator {
    private var userSession: UserSession
    private var navigationController: UINavigationController?
    private var rootParentController: UIViewController
    
    init(rootParentController: UIViewController, userSession: UserSession) {
        self.userSession = userSession
        self.rootParentController = rootParentController
    }
    
    func activate() {
        let weatherViewController = WeatherViewController()
        navigationController = UINavigationController(rootViewController: weatherViewController)
        //weatherViewController.delegate = self
        rootParentController.add(navigationController!)
    }
}
