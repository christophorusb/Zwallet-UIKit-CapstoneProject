//
//  SignUpViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 06/08/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var authService = AuthService()
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var nameTextField: UITextField?
    
    @IBOutlet weak var roundedCard: UIView!
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton?.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
            updateButtonAppearance()
        }
    }
    @IBOutlet weak var HeadersContainer: UIView!
    @IBOutlet weak var SignUpFormContainer: UIStackView!
    @IBOutlet weak var LoginLabelWrapper: UIView!
    @IBOutlet weak var LoginSmallNavText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        let mainHeader = createMainHeader(forText: "Sign Up")
        let subHeader = createSubHeader(forText: "Create your account to access Zwallet")
        
        HeadersContainer.addSubview(mainHeader)
        HeadersContainer.addSubview(subHeader)
        
        nameTextField = createTextField(placeholder: "Name", systemIconName: "person")
        emailTextField = createTextField(placeholder: "Email", systemIconName: "envelope")
        passwordTextField = createTextField(placeholder: "Password", isSecureTextEntry: true, systemIconName: "lock")
        
        SignUpFormContainer.addArrangedSubview(nameTextField!)
        SignUpFormContainer.addArrangedSubview(emailTextField!)
        SignUpFormContainer.addArrangedSubview(passwordTextField!)

        // Center the first label horizontally and vertically
        NSLayoutConstraint.activate([
            mainHeader.centerXAnchor.constraint(equalTo: HeadersContainer.centerXAnchor),
//            mainHeader.centerYAnchor.constraint(equalTo: HeadersContainer.centerYAnchor)
        ])

        // Center the second label horizontally and position it below the first label
        NSLayoutConstraint.activate([
            subHeader.centerXAnchor.constraint(equalTo: HeadersContainer.centerXAnchor),
            subHeader.topAnchor.constraint(equalTo: mainHeader.bottomAnchor, constant: 20),
            subHeader.leadingAnchor.constraint(equalTo: HeadersContainer.leadingAnchor),
            subHeader.trailingAnchor.constraint(equalTo: HeadersContainer.trailingAnchor),
        ])
    }
    
    func initialSetup(){
        roundedCard.applyShadowedRoundedCard()
        signUpButton.isEnabled = false
        signUpButton.applyRoundedCornersToButton()
        updateButtonAppearance()
        createLoginMessageNavLink()
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
        subHeader.font = UIFont.systemFont(ofSize: 14)
        subHeader.translatesAutoresizingMaskIntoConstraints = false
        subHeader.textAlignment = .center
        subHeader.numberOfLines = 0
        subHeader.lineBreakMode = .byWordWrapping
        
        return subHeader
    }
    
    func createTextField(placeholder: String, isSecureTextEntry: Bool = false, systemIconName: String? = nil) -> UITextField {
        let textField = ZwalletCustomTextField()

        // Configure text field
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false


        if let systemIconName = systemIconName {
            let iconView = UIImageView(image: UIImage(systemName: systemIconName))
            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = UIColor(named: "ZwalletPrimary")
            let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
            iconView.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
            iconContainerView.addSubview(iconView)
            textField.leftView = iconContainerView
            textField.leftViewMode = .always
        }

        if isSecureTextEntry {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "eye"), for: .normal)
            button.tintColor = UIColor(named: "ZwalletPrimary")
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.toggleVisibility), for: .touchUpInside)
            textField.rightView = button
            textField.rightViewMode = .whileEditing
        }

        textField.delegate = self

        return textField
    }
    
    func createLoginMessageNavLink() {
        let loginMessageAttribute = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        
        loginMessageAttribute.append(NSAttributedString(
            string: "Login",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor: UIColor(named: "ZwalletPrimary") ?? UIColor.blue
            ]
        ))
        
        LoginSmallNavText.attributedText = loginMessageAttribute
        LoginSmallNavText.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        
        LoginSmallNavText.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateButtonState() {
        if let emailText = emailTextField?.text, !emailText.isEmpty,
           let passwordText = passwordTextField?.text, !passwordText.isEmpty,
           let nameText = nameTextField?.text, !nameText.isEmpty{
            signUpButton?.isEnabled = true
        } else {
            signUpButton?.isEnabled = false
        }
        updateButtonAppearance()
    }
    
    func updateButtonAppearance() {
        if signUpButton?.isEnabled == true {
            signUpButton?.backgroundColor = UIColor(named: "ZwalletPrimary")
            signUpButton?.setTitleColor(.white, for: .normal)
        } else {
            signUpButton?.backgroundColor = UIColor(named: "ZwalletPrimary")?.withAlphaComponent(0.4) // Dimmed appearance
            signUpButton?.setTitleColor(.lightGray, for: .normal) // adjust this color as needed
        }
    }
    
    func navigateToOTPVerificationScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "OTPVerificationViewController") as? OTPVerificationViewController{
            nextViewController.OTPVerificationFor = "SIGNUP"
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    /*
        ==============================================================================
        | BEHAVIORS, ACTIONS                                                         |
        ==============================================================================
     */
    
    @objc func toggleVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let textField = sender.superview as? UITextField {
            textField.isSecureTextEntry = !sender.isSelected
            sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
        }
    }
    
    @objc func signUpButtonTapped() {
        let email = emailTextField?.text ?? ""
        let password = passwordTextField?.text ?? ""
        let name = nameTextField?.text ?? ""
        let loadingView = showLoadingView()
        
        authService.signUpUser(username: name, email: email, password: password) { [weak self] result in
            self?.hideLoadingView(loadingView)
            switch result {
            case .success(let user):
                //Successful Login
                self?.navigateToOTPVerificationScreen()
                print("\nSigned up user:\n", user)
                
            case .failure(let error):
                // Handle error, show an alert to the user
                self?.showAlert(title: "Signup Failed 😔", message: "Something's definitely wrong")
                print("\nSignup error:\n", error)
            }
        }
    }
    
    @objc func loginLabelTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.setViewControllers([targetViewController], animated: true)
    }
    
    /*
        ==============================================================================
        | DELEGATE REQUIRED METHODS                                                  |
        ==============================================================================
     */
    
    // UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Change the color of the bottom border when the text field is active
        if let customTextField = textField as? ZwalletCustomTextField{
            customTextField.bottomLine.backgroundColor = UIColor(named: "ZwalletPrimary")?.cgColor
            //customTextField.bottomLine.backgroundColor = UIColor.gray.cgColor
            customTextField.textColor = UIColor(named: "ZwalletPrimary")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Change the color of the bottom border back when the text field is inactive
        if let customTextField = textField as? ZwalletCustomTextField {
            customTextField.bottomLine.backgroundColor = UIColor.gray.cgColor
            customTextField.textColor = UIColor.black
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
}
