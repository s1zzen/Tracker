//
//  EmojiAndColorCell.swift
//  Tracker
//
//  Created by Сергей Баскаков on 11.07.2024.
//

import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
        
        let view = UIView()
        lazy var emoji: UILabel = {
            let lable = UILabel()
            return lable
        }()
        lazy var colorView: UIView = {
            let colorView = UIView()
            return colorView
        }()
        
        func setupCell() {
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 48),
                view.widthAnchor.constraint(equalToConstant: 48)
            ])
        }
        
        func setupEmoji(_ emoji: String) {
            self.emoji.text = emoji
            self.emoji.font = UIFont.systemFont(ofSize: 32)
            self.emoji.textAlignment = .center
            self.emoji.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(self.emoji)
            NSLayoutConstraint.activate([
                self.emoji.heightAnchor.constraint(equalToConstant: 48),
                self.emoji.widthAnchor.constraint(equalToConstant: 48),
                self.emoji.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                self.emoji.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        func setupColor(color: UIColor) {
            colorView.backgroundColor = color
            colorView.layer.masksToBounds = true
            colorView.layer.cornerRadius = 8
            view.addSubview(colorView)
            colorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                colorView.heightAnchor.constraint(equalToConstant: 40),
                colorView.widthAnchor.constraint(equalToConstant: 40),
                colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        func selectEmojiCell() {
            view.layer.cornerRadius = 16
            view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
        }
        
        func deselectEmojiCell() {
            view.layer.cornerRadius = 0
            view.backgroundColor = nil
        }
        
        func selectColorCell() {
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 3
            let color = colorView.backgroundColor?.withAlphaComponent(0.3)
            view.layer.borderColor = color?.cgColor
        }
        
        func deselectColorCell() {
            view.layer.cornerRadius = 0
            view.layer.borderWidth = 0
            view.layer.borderColor = nil
        }
    }
