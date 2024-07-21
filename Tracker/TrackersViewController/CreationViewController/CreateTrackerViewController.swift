//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 11.07.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController, TimetableViewControllerDelegate {
    
    private let nameTrackerTextField = CustomTextField()
    private let exitButton = UIButton()
    private let saveButton = UIButton()
    private var emojiAndColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared

    let buttonsOfCattegoryOrTimetableTableView = UITableView()
    var isTracker = false
    var habitOrEventViewController: HabitOrEventViewController?
    var timetable = Set<Timetable>()
    var cattegory: String?
    var categoryCoreData: TrackerCategoryCoreData?
    var selectedEmoji: String?
    var selectedEmojiCell: EmojiAndColorCell?
    var selectedColor: UIColor?
    var selectedColorCell: EmojiAndColorCell?
    var textFieldСompleted = false
    var timetableСompleted = false
    let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "♥️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let color: [UIColor] = [.color1, .color2, .color3, .color4, .color5, .color6, .color7, .color8, .color9, .color10, .color11, .color12, .color13, .color14, .color15, .color16, .color17, .color18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupVCforEvent()
        addViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    func saveCurrentTimetable(timetable: Set<Timetable>) {
        self.timetable = timetable
        if timetable.isEmpty {
            timetableСompleted = false
        } else {
            timetableСompleted = true
        }
        buttonsOfCattegoryOrTimetableTableView.reloadData()
        enabledSaveButtonOrNot()
    }
    
    func enabledSaveButtonOrNot() {
        if textFieldСompleted && timetableСompleted && selectedColor != nil && selectedEmoji != nil && cattegory != nil {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .black
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        }
    }
    
    func returnTimetableToTableView() -> String? {
        var result: String = ""
        if timetable.isEmpty { return nil }
        if timetable.count == 7 { return "Каждый день" }
        for i in Array(timetable) {
            if i == .monday {result += "Пн, "}
        }
        for i in Array(timetable) {
            if i == .tuesday {result += "Вт, "}
        }
        for i in Array(timetable) {
            if i == .wednesday {result += "Ср, "}
        }
        for i in Array(timetable) {
            if i == .thursday {result += "Чт, "}
        }
        for i in Array(timetable) {
            if i == .friday {result += "Пт, "}
        }
        for i in Array(timetable) {
            if i == .saturday {result += "Сб, "}
        }
        for i in Array(timetable) {
            if i == .sunday {result += "Вс, "}
        }
        result.removeLast(2)
        return result
    }
    
    func returnCategoryToTableView() -> String? {
        return cattegory
    }
    
    private func setupNavBar() {
        title = isTracker ? "Новая привычка" : "Новое нерегулярное событие"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupVCforEvent() {
        if !isTracker {
            timetable.insert(.none)
            timetableСompleted = true
        }
    }
    
    private func addViews() {
        view.backgroundColor = .white
        addScrollView()
        addNameTrackerTextField()
        addButtonsOfCattegoryOrTimetableTableView()
        addEmojiAndColorCollectionView()
        addExitButton()
        addSaveButton()
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func addNameTrackerTextField() {
        nameTrackerTextField.delegate = self
        nameTrackerTextField.placeholder = "Введите название трекера"
        nameTrackerTextField.clearButtonMode = .whileEditing
        nameTrackerTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        nameTrackerTextField.layer.masksToBounds = true
        nameTrackerTextField.layer.cornerRadius = 16
        nameTrackerTextField.setLeftPaddingPoints(16)
        contentView.addSubview(nameTrackerTextField)
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTrackerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
        ])
    }
    
    private func addButtonsOfCattegoryOrTimetableTableView() {
        buttonsOfCattegoryOrTimetableTableView.dataSource = self
        buttonsOfCattegoryOrTimetableTableView.delegate = self
        buttonsOfCattegoryOrTimetableTableView.layer.masksToBounds = true
        buttonsOfCattegoryOrTimetableTableView.layer.cornerRadius = 16
        buttonsOfCattegoryOrTimetableTableView.isScrollEnabled = false
        contentView.addSubview(buttonsOfCattegoryOrTimetableTableView)
        buttonsOfCattegoryOrTimetableTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsOfCattegoryOrTimetableTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            buttonsOfCattegoryOrTimetableTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsOfCattegoryOrTimetableTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsOfCattegoryOrTimetableTableView.heightAnchor.constraint(equalToConstant: isTracker ? 150 - 1 : 75 - 1)
        ])
    }
    
    private func addEmojiAndColorCollectionView() {
        setupEmojiAndColorCollectionView()
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiAndColorCollectionView)
        NSLayoutConstraint.activate([
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: buttonsOfCattegoryOrTimetableTableView.bottomAnchor),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 492)
        ])
    }
    
    private func setupEmojiAndColorCollectionView() {
        self.emojiAndColorCollectionView.dataSource = self
        self.emojiAndColorCollectionView.delegate = self
        emojiAndColorCollectionView.isScrollEnabled = true
        emojiAndColorCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "cell")
        emojiAndColorCollectionView.register(HeaderOfEmojiOrColorView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func addExitButton() {
        exitButton.setTitle("Отменить", for: .normal)
        exitButton.setTitleColor(UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1), for: .normal)
        exitButton.addTarget(self, action: #selector(tapExitButton), for: .touchUpInside)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        exitButton.layer.masksToBounds = true
        exitButton.layer.borderWidth = 1
        exitButton.layer.borderColor = CGColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        exitButton.layer.cornerRadius = 16
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 60),
            exitButton.widthAnchor.constraint(equalToConstant: 166),
            exitButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 40),
            exitButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            exitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
    }
    
    private func addSaveButton() {
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 16
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 166),
            saveButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
    }
    
    @objc private func tapExitButton() {
        self.dismiss(animated: true)
        habitOrEventViewController?.dismiss(animated: true)
    }
    
    @objc private func tapSaveButton() {
        guard let category = categoryCoreData else { return }
        let resultTracker = Tracker(
            id: UUID(),
            name: nameTrackerTextField.text ?? "Без текста",
            color: selectedColor ?? .black,
            emoji: selectedEmoji ?? "",
            timetable: Array(self.timetable))
        trackerStore.saveTracker(tracker: resultTracker, category: category)
        self.dismiss(animated: true)
        habitOrEventViewController?.dismiss(animated: true)
    }
}
