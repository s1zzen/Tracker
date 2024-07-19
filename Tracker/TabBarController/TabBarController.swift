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

        let trackersVC = TrackersViewController()
        let statisticVC = StatisticViewController()

        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )

        statisticVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            selectedImage: UIImage(systemName: "hare.fill")
        )

        viewControllers = [createNavigationController(rootViewController: trackersVC),
                           createNavigationController(rootViewController: statisticVC)
        ]

        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.systemGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        tabBar.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
}
