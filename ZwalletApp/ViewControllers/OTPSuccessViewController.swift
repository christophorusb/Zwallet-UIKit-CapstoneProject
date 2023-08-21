//
//  OTPSuccessViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 08/08/23.
//

import UIKit

class OTPSuccessViewController: UIViewController {
    
    var OTPSuccessFor: String?

    @IBOutlet weak var OTPSuccessMessageWrapper: UIView!
    
    @IBOutlet weak var roundedCard: UIView!
    
    @IBOutlet weak var loginNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
        let mainHeader = createMainHeader(forText: "OTP Authorized")
        
        let subHeader = OTPSuccessFor == "SIGNUP" ? createSubHeader(forText: "Login now and start exploring!") : createSubHeader(forText: "Welcome to Zwallet!")
        
        OTPSuccessMessageWrapper.addSubview(mainHeader)
        OTPSuccessMessageWrapper.addSubview(subHeader)
        
        // Center the first label horizontally and vertically
        NSLayoutConstraint.activate([
            mainHeader.centerXAnchor.constraint(equalTo: OTPSuccessMessageWrapper.centerXAnchor),
           //mainHeader.centerYAnchor.constraint(equalTo: HeadersContainer.centerYAnchor)
        ])

        // Center the second label horizontally and position it below the first label
        NSLayoutConstraint.activate([
            subHeader.centerXAnchor.constraint(equalTo: OTPSuccessMessageWrapper.centerXAnchor),
            subHeader.topAnchor.constraint(equalTo: mainHeader.bottomAnchor, constant: 20),
            subHeader.leadingAnchor.constraint(equalTo: OTPSuccessMessageWrapper.leadingAnchor),
            subHeader.trailingAnchor.constraint(equalTo: OTPSuccessMessageWrapper.trailingAnchor),
        ])
    }
    
    func initialSetup(){
        
        switch OTPSuccessFor {
        case "LOGIN":
            loginNowButton.setTitle("Go to home", for: .normal)
            loginNowButton.addTarget(self, action: #selector(goToHomeButtonTapped), for: .touchUpInside)
        case "SIGNUP":
            loginNowButton.setTitle("Login", for: .normal)
            loginNowButton.addTarget(self, action: #selector(loginNowButtonTapped), for: .touchUpInside)
        default:
            loginNowButton.isHidden = false
        }
        
        roundedCard.applyShadowedRoundedCard()
        loginNowButton.applyRoundedCornersToButton()
    }
    
    func createMainHeader(forText text: String) -> UILabel {
        let mainHeader = UILabel()
        mainHeader.text = text
        mainHeader.font = UIFont.boldSystemFont(ofSize: 24)
        mainHeader.translatesAutoresizingMaskIntoConstraints = false
        
        return mainHeader
    }
    
    func createSubHeader(forText text: String) -> UILabel {
        let subHeader = UILabel()
        subHeader.text = text
        subHeader.textColor = UIColor(named: "ZwalletDefault")
        subHeader.font = UIFont.systemFont(ofSize: 18)
        subHeader.translatesAutoresizingMaskIntoConstraints = false
        subHeader.textAlignment = .center
        subHeader.numberOfLines = 0
        subHeader.lineBreakMode = .byWordWrapping
        
        return subHeader
    }
    
    @objc func goToHomeButtonTapped() {
//        print("\nWindow: \(UIApplication.shared.delegate?.window as? UIWindow)")
//        print("\nWindow: \(UIApplication.shared.connectedScenes.first as? UIWindowScene)")

        let tabBarController = ViewControllerBuilder.createTabBarController()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
            }, completion: nil)
        }
    }
    
    @objc func loginNowButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.setViewControllers([targetViewController], animated: true)
    }
}
