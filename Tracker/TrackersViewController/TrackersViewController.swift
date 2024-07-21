//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 04.07.2024.
//

import UIKit


final class TrackersViewController: UIViewController, TrackerViewCellDelegate, CreateTrackerViewControllerDelegate{
    private let plugImageView = UIImageView()
    private let plugLable = UILabel()
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerStore = TrackerStore.shared
    private var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var currentDayOfWeek: Timetable = .none
    
    var categories: [TrackerCategory] = []
    var curentCategories = [TrackerCategory]()
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        trackerStore.delegate = self
        
    }
    
    private func setupViews() {
        setupNavBar()
        showPlugOrTrackers()
    }
    
    private func setupNavBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapPlusButtonOnNavBar))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        currentDayOfWeek = calculateDayOfWeek(date: datePicker.date)
        
        let searchField = UISearchController(searchResultsController: nil)
        searchField.automaticallyShowsCancelButton = true
        self.navigationItem.searchController = searchField
    }
    
    private func showPlugOrTrackers() {
        
//        print(categories)
        
        if curentCategories.isEmpty {
            addPlugImage()
            addPlugLable()
        } else {
            addTrackersCollectionView()
            setupTrackersCollectionView()
        }
    }
    
    func reloadCollectionAfterCreating() {
        print(curentCategories)
        curentCategories = calculateArrayOfWeek(week: currentDayOfWeek, categories: categories)
        print(curentCategories)
        trackersCollectionView.reloadData()
        showPlugOrTrackers()
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
        plugLable.text = "Что будем отслеживать?"
        plugLable.font = UIFont.systemFont(ofSize: 12)
        plugLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugLable)
        NSLayoutConstraint.activate([
            plugLable.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLable.centerXAnchor.constraint(equalTo: plugImageView.centerXAnchor)
        ])
    }
    
    private func addTrackersCollectionView() {
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ])
    }
    
    private func setupTrackersCollectionView() {
        self.trackersCollectionView.dataSource = self
        self.trackersCollectionView.delegate = self
        trackersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func completeTrackerOnDateOrNot(tracker: Tracker, completedTrackers: [TrackerRecord], date: Date) -> Bool {
        var result = false
        for i in completedTrackers {
            if i.id == tracker.id && i.date == date {
                result = true
            }
        }
        return result
    }
    
    func updateCategories(trackerCategory: TrackerCategory) {
        var result: [TrackerCategory] = []
        if categories.isEmpty {
            result.append(trackerCategory)
        }
        for category in categories {
            if category.heading != trackerCategory.heading {
                result.append(category)
                result.append(trackerCategory)
            }
            if category.heading == trackerCategory.heading {
                let trackers = category.trackers + trackerCategory.trackers
                let heading = category.heading
                result.append(TrackerCategory(heading: heading, trackers: trackers))
            }
        }
        categories = result
        self.reloadCollectionAfterCreating()
    }
    
    private func calculateDayOfWeek(date: Date) -> Timetable {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        
        let weekdays: [Timetable] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        
        guard weekdays.indices.contains(weekdayIndex) else {
            return .none
        }
        
        return weekdays[weekdayIndex]
    }
    
    func calculateArrayOfWeek(week: Timetable, categories: [TrackerCategory]) -> [TrackerCategory] {
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.timetable.contains(week) || tracker.timetable.contains(.none)
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(heading: category.heading, trackers: filteredTrackers)
        }
    }
    
    func calculateCountOfDayOnDate(tracker: Tracker, completedTrackers: [TrackerRecord], date: Date) -> Int {
        return completedTrackers.filter { $0.id == tracker.id }.count
    }
    
    func writeCompletedTracker(tracker: Tracker) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        completedTrackers.append(trackerRecord)
    }

    func deleteCompletedTracker(tracker: Tracker) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        completedTrackers = completedTrackers.filter { $0.id != tracker.id || $0.date != trackerRecord.date }
    }

    func deleteTrackerFromCategories(tracker: Tracker) {
        categories = categories.map { category in
            let filteredTrackers = category.trackers.filter { $0.id != tracker.id }
            return TrackerCategory(heading: category.heading, trackers: filteredTrackers)
        }
    }

    
    @objc private func didTapPlusButtonOnNavBar() {
        let vc = HabitOrEventViewController()
        vc.originalViewController = self
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        currentDayOfWeek = calculateDayOfWeek(date: sender.date)
        curentCategories = calculateArrayOfWeek(week: currentDayOfWeek, categories: categories)
        showPlugOrTrackers()
        trackersCollectionView.reloadData()
    }
    
}

