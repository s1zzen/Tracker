//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Сергей Баскаков on 08.07.2024.
//
import UIKit

protocol TrackerViewCellDelegate: AnyObject {
    func writeCompletedTracker(tracker: Tracker)
    func deleteCompletedTracker(tracker: Tracker)
    func deleteTrackerFromCategories(tracker: Tracker)
}

final class TrackerViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let nameLable = UILabel()
    private let emogiImage = UILabel()
    private let daysCountLable = UILabel()
    private let completeButton = UIButton()
    private var background = UIView()
    private let currentDate = Date()
    private var currentTracker: Tracker?
    
    // MARK: - Public Properties
    
    var daysCount: Int = 0
    var trackerChangeToday = false
    var selectedDate = Date()
    var trackerViewController: TrackersViewController?
    weak var delegate: TrackerViewCellDelegate?
    
    // MARK: - Public Methods
    
    func setupViews(tracker: Tracker) {
        createBackground(color: tracker.color)
        addName(name: tracker.name)
        addEmoji(emoji: tracker.emojy)
        addCompleteButton(color: tracker.color)
        addDaysCountLable()
    }
    
    func currentTracker(tracker: Tracker) {
        currentTracker = tracker
    }
    
    // MARK: - Private Methods
    
    private func createBackground(color: UIColor) {
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        background.backgroundColor = color
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalToConstant: 167),
            background.heightAnchor.constraint(equalToConstant: 90),
        ])
        background.layer.cornerRadius = 16
    }
    
    private func addName(name: String) {
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.text = name
        nameLable.font = UIFont.systemFont(ofSize: 12)
        nameLable.textColor = .white
        nameLable.lineBreakMode = .byWordWrapping
        nameLable.textAlignment = .left
        nameLable.numberOfLines = 2
        addSubview(nameLable)
        NSLayoutConstraint.activate([
            nameLable.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12),
            nameLable.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
            nameLable.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -12)
        ])
    }
    
    private func addEmoji(emoji: String) {
        emogiImage.translatesAutoresizingMaskIntoConstraints = false
        emogiImage.text = emoji
        emogiImage.font = UIFont.systemFont(ofSize: 16)
        emogiImage.textAlignment = .center
        emogiImage.backgroundColor = .white.withAlphaComponent(0.3)
        emogiImage.layer.masksToBounds = true
        emogiImage.layer.cornerRadius = 12
        addSubview(emogiImage)
        NSLayoutConstraint.activate([
            emogiImage.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            emogiImage.heightAnchor.constraint(equalToConstant: 24),
            emogiImage.widthAnchor.constraint(equalToConstant: 24),
            emogiImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 12)
        ])
    }
    
    private func addDaysCountLable() {
        daysCountLable.translatesAutoresizingMaskIntoConstraints = false
        setupDaysCount(newCount: daysCount)
        daysCountLable.font = UIFont.systemFont(ofSize: 12)
        addSubview(daysCountLable)
        NSLayoutConstraint.activate([
            daysCountLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            daysCountLable.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            
        ])
    }
    
    private func addCompleteButton(color: UIColor) {
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.backgroundColor = color
        completeButton.layer.cornerRadius = 16
        if trackerChangeToday == false {
            trackerNoCompleteToday()
        } else {
            trackerCompleteToday()
        }
        completeButton.tintColor = .white
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        addSubview(completeButton)
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupDaysCount(newCount: Int) {
        switch newCount{
        case 1:
            daysCountLable.text = "\(newCount) день"
        case 2...4:
            daysCountLable.text = "\(newCount) дня"
        default:
            daysCountLable.text = "\(newCount) дней"
        }
    }
    
    private func plusDaysCount() {
        let newCount = daysCount + 1
        trackerChangeToday = true
        setupDaysCount(newCount: newCount)
        daysCount = newCount
        trackerCompleteToday()
    }
    
    private func minesDaysCount() {
        let newCount = daysCount - 1
        trackerChangeToday = false
        setupDaysCount(newCount: newCount)
        daysCount = newCount
        trackerNoCompleteToday()
    }
    
    private func trackerCompleteToday() {
        completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        completeButton.backgroundColor = completeButton.backgroundColor?.withAlphaComponent(0.3)
    }
    
    private func trackerNoCompleteToday() {
        completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completeButton.backgroundColor = completeButton.backgroundColor?.withAlphaComponent(1)
    }
    
    private func writeCompletedTracker() {
        guard let tracker = currentTracker else { return }
        delegate?.writeCompletedTracker(tracker: tracker)
    }
    
    private func deleteCompletedTracker() {
        guard let tracker = currentTracker else { return }
        delegate?.deleteCompletedTracker(tracker: tracker)
    }
    
    // MARK: - Private Actions
    
    @objc private func didTapCompleteButton() {
        guard currentDate > selectedDate else { return }
        if trackerChangeToday == false {
            plusDaysCount()
            writeCompletedTracker()
            guard let tracker = currentTracker else { return }
            delegate?.deleteTrackerFromCategories(tracker: tracker)
        } else {
            minesDaysCount()
            deleteCompletedTracker()
        }
    }
}
