
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let containter: NSPersistentContainer
    
    init() {
        self.containter = NSPersistentContainer(name: "DataModel")
        
        
        containter.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
