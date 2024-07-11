//
//  TimetableViewController + Extention.swift
//  Tracker
//
//  Created by Сергей Баскаков on 11.07.2024.
//

import UIKit

extension TimetableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchView.tag = indexPath.row
        switchView.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        cell.accessoryView = switchView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension TimetableViewController: UITableViewDelegate {
    
}

