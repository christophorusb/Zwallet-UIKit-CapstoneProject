//
//  HomeViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 19/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loggedInUserName: UILabel!
    
    var loggedInUserData: UserResponseModel?
    
    private var userService = UserService()
    private var authService = AuthService()
    override func viewDidLoad() {
        initialSetup()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        fetchUser()
    }
    
    func fetchUser() {
        let loadingView = showLoadingView()
        userService.getLoggedInUserData { [weak self] result in
            self?.hideLoadingView(loadingView)
            switch result {
            case .success(let response):
                self?.loggedInUserData = response
                let firstName = self?.loggedInUserData?.data.firstname ?? ""
                let lastName = self?.loggedInUserData?.data.lastname ?? ""
                
                self?.loggedInUserName.text = "\(firstName) \(lastName)"
            case .failure(let error):
                if let userServiceError = error as? UserServiceError {
                    self?.handleError(userServiceError)
                }
            }
        }
    }
    
    func handleError(_ error: UserServiceError) {
        if let httpError = error.baseHTTPError {
            handleHTTPError(httpError)
        } else {
            handleBaseError(error)
        }
    }

    func handleHTTPError(_ httpError: BaseHTTPErrorModel) {
        // Handle or display the HTTP-specific error
        showAlert(title: httpError.title, message: httpError.message)
    }

    func handleBaseError(_ error: UserServiceError) {
        let errorModel = error.baseError

        switch error {
        case .tokenExpired, .tokenNotFound:
            let okAction = UIAlertAction(title: "Sure", style: .default) { [weak self] _ in
                self?.authService.redirectToLogin()
            }
            self.showAlert(title: errorModel.title, message: errorModel.message, actions: [okAction])
        case .decodingError, .invalidStatusCode:
            self.showAlert(title: errorModel.title, message: errorModel.message)
        default:
            // Handle any other base errors if needed
            break
        }
    }
}
