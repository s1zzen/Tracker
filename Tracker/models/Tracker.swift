//
//  Tracker.swift
//  Tracker
//
//  Created by Сергей Баскаков on 08.07.2024.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let timetable: [Timetable]
}

enum Timetable: String, Equatable, Codable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница "
    case saturday = "Суббота"
    case sunday = "Воскресение"
    case none = "Без "
}

