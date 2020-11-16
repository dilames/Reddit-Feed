//
//  ApplicationCoordinator.swift
//  Reddit
//
//  Created by Andrew Chersky on 13.11.2020.
//

import UIKit
import Platform
import Domain
import Combine

final class ApplicationCoordinator {
    
    private unowned var sceneDelegate: SceneDelegate
    private unowned var appDelegate: AppDelegate
    private var useCaseProvider: UseCaseProvider
    
    init(sceneDelegate: SceneDelegate, appDelegate: AppDelegate) {
        self.sceneDelegate = sceneDelegate
        self.appDelegate = appDelegate
        self.useCaseProvider = appDelegate.platform
    }
    
    func start() {
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
}

// MARK: ViewControllers
extension ApplicationCoordinator {
    
    var navigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: feedViewController)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    var feedViewController: FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "FeedViewController") as FeedViewController
        let viewModel = FeedViewModel(useCases: useCaseProvider)
        viewController.viewModel = viewModel
        return viewController
    }
    
    func feedDetailsViewController(url: URL) -> FeedDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "FeedDetailsViewController") as FeedDetailsViewController
        let viewModel = FeedDetailsViewModel(useCases: useCaseProvider, url: url)
        viewController.viewModel = viewModel
        return viewController
    }
    
}
