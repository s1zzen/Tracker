//
//  CreateTrackerViewController + Extention.swift
//  Tracker
//
//  Created by Сергей Баскаков on 11.07.2024.
//

import UIKit

extension CreateTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = CategoriesInCreactingViewController()
            vc.createTrackerViewController = self
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true)
        } else {
            let vc = TimetableViewController()
            vc.delegate = self
            vc.resultSetOfWeak = timetable
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true)
        }
    }
}

extension CreateTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isTracker ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        let text = indexPath.row == 0 ? "Категория" : "Расписание"
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        let subText = indexPath.row == 0 ? nil : returnTimetableToTableView()
        cell.detailTextLabel?.text = subText
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CreateTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, !text.isEmpty {
            if text.count >= 1 && text.count <= 38 {
                textFieldСompleted = true
            } else {
                textFieldСompleted = false
            }
        }
        enabledSaveButtonOrNot()
        return true
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell else { return }
        if indexPath.section == 0 {
            if selectedEmoji != nil {
                selectedEmojiCell?.deselectEmojiCell()
            }
            cell.selectEmojiCell()
            selectedEmoji = cell.emoji.text
            selectedEmojiCell = cell
            enabledSaveButtonOrNot()
        } else {
            if selectedColor != nil {
                selectedColorCell?.deselectColorCell()
            }
            cell.selectColorCell()
            selectedColor = cell.colorView.backgroundColor
            selectedColorCell = cell
            enabledSaveButtonOrNot()
        }
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiAndColorCell else { return UICollectionViewCell()}
        cell.setupCell()
        if indexPath.section == 0 {
            cell.setupEmoji(emoji[indexPath.row])
        } else {
            cell.setupColor(color: color[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let titile = indexPath.section == 0 ? "Emoji" : "Цвет"
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderOfEmojiOrColorView else { return UICollectionReusableView()}
        view.titleLabel.text = titile
        return view
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6, height: 48)
    }
}
