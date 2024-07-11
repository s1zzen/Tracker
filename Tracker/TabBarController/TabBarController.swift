//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 04.07.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
        }
    }
    
    private func createTabBar() {
        viewControllers = [
            createViewController(
                viewController: TrackersViewController(),
                title: "Трекеры",
                image: UIImage(systemName: "record.circle.fill")),
            createViewController(
                viewController: StatisticViewController(),
                title: "Статистика",
                image: UIImage(systemName: "hare.fill")),
        ]
    }
    
    private func createViewController(viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        let result = UINavigationController(rootViewController: viewController)
        return result
    }
}
