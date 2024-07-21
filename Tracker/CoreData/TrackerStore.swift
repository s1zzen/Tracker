//
//  TrackerStore.swift
//  Tracker
//
//  Created by Сергей Баскаков on 19.07.2024.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func updateCollection()
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    private override init() {}
    private var persistentContainerCreator = PersistentContainerCreator.shared
    private var context: NSManagedObjectContext {
        persistentContainerCreator.persistentContainer.viewContext
    }
    var trackersCoreData: [TrackerCoreData] {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return []}
        return objects
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Create
    
    func saveTracker(tracker: Tracker, category: TrackerCategoryCoreData) {
        guard let trackerEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else { return }
        let trackerEntity = TrackerCoreData(entity: trackerEntityDescription, insertInto: context)
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.timetable = tracker.timetable as NSObject
        category.addToTrackers(trackerEntity)
        persistentContainerCreator.saveContext()
    }
    
    // MARK: - Read
    
    func fetchTrackers() -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        guard let trackersCoreData = try? context.fetch(request) else { return [] }
        return trackersCoreData
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.updateCollection()
    }
}

