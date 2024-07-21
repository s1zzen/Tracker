//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 19.07.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController, UITextFieldDelegate {
    
    private let nameCategoryTextField = CustomTextField()
    private let createCategoryButton = UIButton()
    private var textFieldСompleted = false
    private let trackerCategoryStore = TrackerCategoryStore.shared
    var categoriesInCreactingViewController: CategoriesInCreactingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        addNameTracerTextField()
        addCreateCategoryButton()
    }
    
    private func setupNavBar() {
        title = "Новая категория"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addNameTracerTextField() {
        nameCategoryTextField.delegate = self
        nameCategoryTextField.placeholder = "Введите название категории"
        nameCategoryTextField.clearButtonMode = .whileEditing
        nameCategoryTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        nameCategoryTextField.layer.masksToBounds = true
        nameCategoryTextField.layer.cornerRadius = 16
        nameCategoryTextField.setLeftPaddingPoints(16)
        view.addSubview(nameCategoryTextField)
        nameCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func addCreateCategoryButton() {
        createCategoryButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        createCategoryButton.tintColor = .white
        createCategoryButton.setTitle("Готово", for: .normal)
        createCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createCategoryButton.addTarget(self, action: #selector(createCategoryButtonTap), for: .touchUpInside)
        createCategoryButton.isEnabled = false
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
    
    private func enabledSaveButtonOrNot() {
        if textFieldСompleted {
            createCategoryButton.backgroundColor = .black
            createCategoryButton.isEnabled = true
        } else {
            createCategoryButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            createCategoryButton.isEnabled = false
        }
    }
    
    private func saveCategory() {
        trackerCategoryStore.createTrackerCategory(heading: nameCategoryTextField.text ?? "")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if text.count >= 1 {
                textFieldСompleted = true
            } else {
                textFieldСompleted = false
            }
        }
        enabledSaveButtonOrNot()
    }
    
    @objc private func createCategoryButtonTap() {
        saveCategory()
        categoriesInCreactingViewController?.plugOrCategories()
        self.dismiss(animated: true)
    }
}
