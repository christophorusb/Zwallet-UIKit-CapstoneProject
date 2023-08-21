//
//  ViewControllerBuilder.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 19/08/23.
//

import Foundation
import UIKit

class ViewControllerBuilder {
    static func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

        // Set up the tab bar items
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)

        // Add view controllers to the tab bar controller
        tabBarController.viewControllers = [homeViewController, profileViewController]
        tabBarController.selectedIndex = 0

        return tabBarController
    }
}
