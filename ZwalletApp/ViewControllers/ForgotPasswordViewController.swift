//
//  ForgotPasswordViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 06/08/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var FormContainer: UIStackView!
    @IBOutlet weak var ResetPasswordMainHeader: UILabel!
    @IBOutlet weak var roundedCard: UIView!
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton?.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
            updateButtonAppearance()
        }
    }
    @IBOutlet weak var ResetPasswordSubheader: UILabel!
    
    var emailTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        createSubHeader(forText: "Enter your Zwallet e-mail so we can send you a password reset link")
        createMainHeader(forText: "Reset Password")
        
        emailTextField = createTextField(placeholder: "Email", systemIconName: "envelope")
            
        FormContainer.addArrangedSubview(emailTextField!)
    }
    
    func initialSetup(){
        roundedCard.applyShadowedRoundedCard()
        confirmButton.applyRoundedCornersToButton()
        confirmButton.isEnabled = false
        updateButtonAppearance()
    }
    
    func createMainHeader(forText text: String){
        ResetPasswordMainHeader.text = text
        ResetPasswordMainHeader.font = UIFont.boldSystemFont(ofSize: 24)
        ResetPasswordMainHeader.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createSubHeader(forText text: String){
        ResetPasswordSubheader.text = text
        ResetPasswordSubheader.textColor = UIColor(named: "ZwalletDefault")
        ResetPasswordSubheader.font = UIFont.systemFont(ofSize: 14)
        ResetPasswordSubheader.translatesAutoresizingMaskIntoConstraints = false
        ResetPasswordSubheader.textAlignment = .center
        ResetPasswordSubheader.numberOfLines = 0
        ResetPasswordSubheader.lineBreakMode = .byWordWrapping
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
        if let emailText = emailTextField?.text, !emailText.isEmpty {
            confirmButton?.isEnabled = true
        } else {
            confirmButton?.isEnabled = false
        }
        updateButtonAppearance()
    }
    
    func updateButtonAppearance() {
        if confirmButton?.isEnabled == true {
            confirmButton?.backgroundColor = UIColor(named: "ZwalletPrimary")
            confirmButton?.setTitleColor(.white, for: .normal)
        } else {
            confirmButton?.backgroundColor = UIColor(named: "ZwalletPrimary")?.withAlphaComponent(0.4) // Dimmed appearance
            confirmButton?.setTitleColor(.lightGray, for: .normal) // adjust this color as needed
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
    
    @objc func confirmButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController{
            nextViewController.emailSent = emailTextField?.text
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
