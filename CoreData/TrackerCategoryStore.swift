import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateCategories()
}
final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    private override init() {}
    private var persistentContainerCreator = PersistentContainerCreator.shared
    private var context: NSManagedObjectContext {
        persistentContainerCreator.persistentContainer.viewContext
    }
    var trackersCategoryCoreData: [TrackerCategoryCoreData] {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return []}
        return objects
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "heading", ascending: false)
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
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Create
    
    func createTrackerCategory(heading: String) -> TrackerCategoryCoreData? {
        guard let tracerCategoryEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return nil }
        let tracerCategoryEntity = TrackerCategoryCoreData(entity: tracerCategoryEntityDescription, insertInto: context)
        tracerCategoryEntity.heading = heading
        persistentContainerCreator.saveContext()
        return tracerCategoryEntity
    }
    
    // MARK: - Read
    
    func fetchTrackerCategoryCoreData(heading: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "heading == %@", heading)
        do {
            let category = try context.fetch(fetchRequest)
            return category.first
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTrackersCategory() -> [TrackerCategoryCoreData] {
       let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let trackerCategoryCoreData = try? context.fetch(request) else { return [] }
        return trackerCategoryCoreData
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.updateCategories()
    }
}
