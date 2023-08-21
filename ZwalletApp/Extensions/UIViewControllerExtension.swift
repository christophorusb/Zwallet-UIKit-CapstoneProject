//
//  UIViewControllerExtension.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 19/08/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
        
    func showLoadingView() -> LoadingView {
        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        loadingView.startAnimating()
        return loadingView
    }
    
    func hideLoadingView(_ loadingView: LoadingView) {
        loadingView.stopAnimating()
    }

}


