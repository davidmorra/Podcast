//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Macbook on 11/29/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple
        
        setUpViewControllers()
        print("git")
    }
    
    // MARK: - Set Up View Controllers
    func setUpViewControllers() {
        viewControllers = [
            setUpNavigationControllers(with: ViewController(), title: "Favorites", image: "play.circle.fill"),
            setUpNavigationControllers(with: ViewController(), title: "Search", image: "magnifyingglass"),
            setUpNavigationControllers(with: ViewController(), title: "Donwloads", image: "rectangle.stack.fill")
        ]
    }
    
    // MARK: - Helper Functions
    fileprivate func setUpNavigationControllers(with rootviewController: UIViewController, title: String, image: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootviewController)
        rootviewController.navigationItem.title = title
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        navController.title = title
        
        return navController
    }
    
    


    
}
