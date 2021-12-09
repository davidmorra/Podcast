//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Macbook on 11/29/21.
//

import UIKit
import AVFoundation

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple
        
        setUpViewControllers()
        
        setupPlayerDetailView()
     }
    
    @objc func minimizePlayerDetail() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
        }
        
    }
    
    func maximazePlayerDelail(episode: Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        if episode != nil {
            playerDeatilView.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = true
        }

    }
    
    //MARK: - Setup Functions
    let playerDeatilView = PlayerDetailView.initFromNib()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    // MARK: - Set Up View Controllers
    fileprivate func setupPlayerDetailView() {
        
        view.insertSubview(playerDeatilView, belowSubview: tabBar)

        
        playerDeatilView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDeatilView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDeatilView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint.isActive = true
        
        
        playerDeatilView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDeatilView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDeatilView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    
    
    func setUpViewControllers() {
        viewControllers = [
            setUpNavigationControllers(with: PodcastSearchController(), title: "Search", image: "magnifyingglass"),
            setUpNavigationControllers(with: ViewController(), title: "Favorites", image: "play.circle.fill"),
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
