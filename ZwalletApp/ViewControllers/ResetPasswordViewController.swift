//
//  ResetPasswordViewController.swift
//  ZwalletApp
//
//  Created by laptop MCO on 20/08/23.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var roundedCard: UIView!
    @IBOutlet weak var formContainer: UIStackView!
    @IBOutlet weak var resetPasswordButton: UIButton! {
        didSet {
            updateButtonAppearance()
        }
    }
    
    var emailSent: String?
    
    var passwordTextField: UITextField?
    var confirmPasswordTextField: UITextField?
    
    var authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        print("\nEMAIL SENT: \(emailSent ?? "")")
        
        passwordTextField = createTextField(placeholder: "Password", isSecureTextEntry: true, systemIconName: "lock")
        confirmPasswordTextField = createTextField(placeholder: "Confirm Password", isSecureTextEntry: true, systemIconName: "lock")
        
        formContainer.addArrangedSubview(passwordTextField!)
        formContainer.addArrangedSubview(confirmPasswordTextField!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        
        if passwordTextField?.text != confirmPasswordTextField?.text {
            print("\nPASSWORDS DONT MATCH\n")
            showAlert(title: "Oops", message: "Your passwords don't seem to match!")
            passwordTextField?.text = ""
            confirmPasswordTextField?.text = ""
        } else {
            let loadingView = showLoadingView()
            authService.resetPassword(email: emailSent!, password: (passwordTextField?.text)!) { [weak self] result in
                self?.hideLoadingView(loadingView)
                switch result {
                case .success:
                    let okAction = UIAlertAction(title: "Sure", style: .default) { [weak self] _ in
                        self?.authService.redirectToLogin()
                    }
                    self?.showAlert(title: "Password changed!", message: "Your password has been successfully changed. Please log in again!", actions: [okAction])
                case .failure:
                    self?.showAlert(title: "Oops!", message: "Something's wrong. Please try again")
                }
            }
        }
    }
    
    func initialSetup(){
        roundedCard.applyShadowedRoundedCard()
        resetPasswordButton.applyRoundedCornersToButton()
        resetPasswordButton.isEnabled = false
        updateButtonAppearance()
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
    
    func updateButtonState() {
        if let passwordText = passwordTextField?.text, !passwordText.isEmpty,
           let confirmPasswordText = confirmPasswordTextField?.text, !confirmPasswordText.isEmpty{
            resetPasswordButton?.isEnabled = true
        } else {
            resetPasswordButton?.isEnabled = false
        }
        updateButtonAppearance()
    }
    
    func updateButtonAppearance() {
        if resetPasswordButton?.isEnabled == true {
            resetPasswordButton?.backgroundColor = UIColor(named: "ZwalletPrimary")
            resetPasswordButton?.setTitleColor(.white, for: .normal)
        } else {
            resetPasswordButton?.backgroundColor = UIColor(named: "ZwalletPrimary")?.withAlphaComponent(0.4) // Dimmed appearance
            resetPasswordButton?.setTitleColor(.lightGray, for: .normal) // adjust this color as needed
        }
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
}
