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

enum Timetable: Equatable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    case none
}

