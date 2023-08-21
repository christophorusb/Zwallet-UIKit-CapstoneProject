//
//  OTPVerificationViewController.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 06/08/23.
//

import UIKit
import QuartzCore

class OTPVerificationViewController: UIViewController, UITextFieldDelegate {
    
    var OTPVerificationFor: String? 

    @IBOutlet weak var roundedCard: UIView!
    
    @IBOutlet weak var HeadersContainer: UIView!
    
    @IBOutlet weak var OTPFieldsHorizontalStackContainer: UIStackView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var otpTextFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        let mainHeader = createMainHeader(forText: "Please input your OTP")
        let subHeader = createSubHeader(forText: "We have sent your OTP (One Time Password) code via email")
        HeadersContainer.addSubview(mainHeader)
        HeadersContainer.addSubview(subHeader)
        
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
        
        setupOTPFields()
    }
    
    func initialSetup(){
        roundedCard.applyShadowedRoundedCard()
        confirmButton.applyRoundedCornersToButton()
        confirmButton.isEnabled = false
        updateButtonAppearance()
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
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
    
    func createOTPTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1.0
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }
    
    func setupOTPFields() {
        for _ in 0..<6 {
            let textField = createOTPTextField()
            otpTextFields.append(textField)
            OTPFieldsHorizontalStackContainer.addArrangedSubview(textField)
        }
    }
    
    @objc func confirmButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "OTPSuccessViewController") as? OTPSuccessViewController{
            nextViewController.OTPSuccessFor = OTPVerificationFor
            navigationController?.pushViewController(nextViewController, animated: true)
        }
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
        | DELEGATE REQUIRED METHODS
        ==============================================================================
     */
    
    @objc func textDidChange(_ textField: UITextField) {
        // Retrieve the current text from the textField. If it's nil, default to an empty string.
        let text = textField.text ?? ""
        
        // Check if a character was added to the textField.
        if text.count == 1 {
            // Find the index of the current textField in the otpTextFields array.
            // Then, calculate the index of the next textField.
            let nextIndex = otpTextFields.firstIndex(of: textField)! + 1
            
            // Check if there's another textField after the current one.
            if nextIndex < otpTextFields.count {
                // Move focus to the next textField.
                confirmButton.isEnabled = false
                updateButtonAppearance()
                otpTextFields[nextIndex].becomeFirstResponder()
            } else {
                // If the current textField is the last one:
                // Remove focus from the current textField.
                confirmButton.isEnabled = true
                updateButtonAppearance()
                textField.resignFirstResponder()
                //let otp = otpTextFields.map { $0.text ?? "" }.joined()
                //print("OTP Value is:", otp)
            }
        }
        // Check if a character was deleted from the textField.
        else if text.count == 0 {
            // Find the index of the current textField in the otpTextFields array.
            // Then, calculate the index of the previous textField.
            let prevIndex = otpTextFields.firstIndex(of: textField)! - 1
            
            // Check if there's a textField before the current one.
            if prevIndex >= 0 {
                // Move focus to the previous textField.
                otpTextFields[prevIndex].becomeFirstResponder()
            }
        }
        
        if let text = textField.text, !text.isEmpty {
            // If filled, set the border color
            textField.layer.borderColor = UIColor(named: "ZwalletPrimary")?.cgColor
            textField.layer.borderWidth = 3
        } else {
            // If not filled, set the border color to a default (e.g., gray).
            textField.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
