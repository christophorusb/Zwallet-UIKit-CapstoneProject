//
//  ProfileViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 18/08/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var loggedInUserName: UILabel!
    
    var authService = AuthService()
    var userService = UserService()
    var bearerToken: String?
    var loggedInUserData: UserResponseModel?
    
    override func viewDidLoad() {
        initialSetup()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        let loadingView = showLoadingView()
        authService.logoutUser(bearerToken: bearerToken!) { [weak self] result in
            self?.hideLoadingView(loadingView)
            switch result {
            case .success:
                let okAction = UIAlertAction(title: "Sure baby", style: .default) { [weak self] _ in
                    self?.authService.redirectToLogin()
                }
                self?.showAlert(title: "Aww shucks!", message: "Please come back to Zwallet again will you? 🥹", actions: [okAction])
            case .failure(let error):
                self?.showAlert(title: "WTF WHY DOES THE LOGOUT FAIL?!O_O😔", message: "Idk Tbh brooo logout shouldn't fail")
                print("\nLogin error:\n", error)
            }
        }
    }
    
    func initialSetup() {
        let checkTokenValidity = authService.checkBearerTokenValidity()
        switch checkTokenValidity{
        case .expired:
            authService.redirectToLogin()
        case .valid:
            bearerToken = authService.getBearerToken()
            fetchUser()
        case .notFound:
            authService.redirectToLogin()
        }
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
