//
//  CategoriesItCreactingViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 11.07.2024.
//

import UIKit

final class CategoriesItCreactingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
    }
    
    private func setupNavBar() {
        title = "Категория"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
