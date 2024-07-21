//
//  CategoriesInCreactingViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 19.07.2024.
//

import UIKit

final class CategoriesInCreactingViewController: UIViewController {
    
    var categories: [TrackerCategoryCoreData] = []
    private let plugImageView = UIImageView()
    private let plugLable = UILabel()
    private let createCategoryButton = UIButton()
    private let categoriesTableView = UITableView()
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private var heightCategoriesTableViewConstraint: NSLayoutConstraint?
    var createTrackerViewController: CreateTrackerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        categories = trackerCategoryStore.trackersCategoryCoreData
        setupNavBar()
        plugOrCategories()
        trackerCategoryStore.delegate = self
        addCreateCategoryButton()
    }
    
    // MARK: - Public Methods
    
    func plugOrCategories() {
        if categories.isEmpty {
            categoriesTableView.removeFromSuperview()
            addPlugImage()
            addPlugLable()
        } else {
            plugLable.removeFromSuperview()
            plugImageView.removeFromSuperview()
            addCategoriesTableView()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        title = "Категория"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addPlugImage() {
        plugImageView.image = UIImage(named: "plugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugImageView)
        NSLayoutConstraint.activate([
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plugImageView.widthAnchor.constraint(equalToConstant: 80),
            plugImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func addPlugLable() {
        plugLable.text = "Привычки и события можно объединить по смыслу"
        plugLable.font = UIFont.systemFont(ofSize: 12)
        plugLable.numberOfLines = 2
        plugLable.textAlignment = .center
        plugLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugLable)
        NSLayoutConstraint.activate([
            plugLable.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLable.centerXAnchor.constraint(equalTo: plugImageView.centerXAnchor),
            plugLable.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func addCategoriesTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.layer.masksToBounds = true
        categoriesTableView.layer.cornerRadius = 16
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTableView)
        heightCategoriesTableViewConstraint = categoriesTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * categories.count))
        heightCategoriesTableViewConstraint?.isActive = true
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addCreateCategoryButton() {
        createCategoryButton.backgroundColor = .black
        createCategoryButton.tintColor = .white
        createCategoryButton.setTitle("Добавить категорию", for: .normal)
        createCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createCategoryButton.addTarget(self, action: #selector(createCategoryButtonTap), for: .touchUpInside)
        createCategoryButton.layer.masksToBounds = true
        createCategoryButton.layer.cornerRadius = 16
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createCategoryButton)
        NSLayoutConstraint.activate([
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func createCategoryButtonTap() {
        let vc = CreateCategoryViewController()
        vc.categoriesInCreactingViewController = self
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true)
    }
}

extension CategoriesInCreactingViewController: TrackerCategoryStoreDelegate {
    func updateCategorys() {
        categories = trackerCategoryStore.trackersCategoryCoreData
        heightCategoriesTableViewConstraint?.isActive = false
        heightCategoriesTableViewConstraint = categoriesTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * categories.count))
        heightCategoriesTableViewConstraint?.isActive = true
        categoriesTableView.reloadData()
    }
}

