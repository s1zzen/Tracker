//
//  TimetableViewController.swift
//  Tracker
//
//  Created by Сергей Баскаков on 19.07.2024.
//

import UIKit

protocol TimetableViewControllerDelegate: AnyObject {
    func saveCurrentTimetable(timetable: Set<Timetable>)
}

final class TimetableViewController: UIViewController {
    
    private let timetableTableView = UITableView()
    private let completeButton = UIButton()
    
    weak var delegate: TimetableViewControllerDelegate?
    var daysOfWeek: [Timetable] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    var resultSetOfWeak = Set<Timetable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
        addButton()
    }
    
    private func setupNavBar() {
        title = "Расписание"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupTableView() {
        timetableTableView.dataSource = self
        timetableTableView.delegate = self
        timetableTableView.layer.masksToBounds = true
        timetableTableView.layer.cornerRadius = 16
        timetableTableView.isScrollEnabled = false
        timetableTableView.tableHeaderView = UIView()
        view.addSubview(timetableTableView)
        timetableTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timetableTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            timetableTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timetableTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timetableTableView.heightAnchor.constraint(equalToConstant: 525 - 1)
        ])
    }
    
    private func addButton() {
        completeButton.setTitle("Готово", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = 16
        completeButton.backgroundColor = .black
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            completeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func switchValueChanged(sender: UISwitch) {
        var weak: Timetable = .none
        switch sender.tag {
        case 0:
            weak = .monday
        case 1:
            weak = .tuesday
        case 2:
            weak = .wednesday
        case 3:
            weak = .thursday
        case 4:
            weak = .friday
        case 5:
            weak = .saturday
        case 6:
            weak = .sunday
        default:
            weak = .none
        }
        if sender.isOn {
            resultSetOfWeak.insert(weak)
        } else {
            resultSetOfWeak.remove(weak)
        }
    }
    
    @objc private func tapCompleteButton() {
        delegate?.saveCurrentTimetable(timetable: resultSetOfWeak)
        self.dismiss(animated: true)
    }
}
