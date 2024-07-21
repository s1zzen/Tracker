//
//  CategoriesInCreactingViewController + Extention.swift
//  Tracker
//
//  Created by Сергей Баскаков on 19.07.2024.
//

import UIKit

extension CategoriesInCreactingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createTrackerViewController?.cattegory = categories[indexPath.row].heading ?? ""
        createTrackerViewController?.categoryCoreData = categories[indexPath.row]
        createTrackerViewController?.buttonsOfCattegoryOrTimetableTableView.reloadData()
        createTrackerViewController?.enabledSaveButtonOrNot()
        self.dismiss(animated: true)
    }
}

extension CategoriesInCreactingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        let text = categories[indexPath.row].heading
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
