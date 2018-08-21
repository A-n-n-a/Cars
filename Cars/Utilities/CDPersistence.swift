//
//  Created by Anna on 8/19/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class CDPersistence {
    
    static func save(car: Car) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let carDescriptor = NSEntityDescription.entity(forEntityName: "CDCar", in: managedContext), let ownerDescriptor = NSEntityDescription.entity(forEntityName: "CDOwner", in: managedContext) {
            
            let cdCar = CDCar(entity: carDescriptor, insertInto: managedContext)
            
            guard let id = car.id, let model = car.model, let type = car.type, let color = car.color else { return }
            
            cdCar.id = Int32(id)
            cdCar.model = model
            cdCar.type = type
            cdCar.color = color
            
            
            for owner in car.owners {
                let cdOwner = CDOwner(entity: ownerDescriptor, insertInto: managedContext)
                guard let ownerId = owner.id, let ownerName = owner.name, let ownerPhone = owner.phone else { return }
                cdOwner.id = Int32(ownerId)
                cdOwner.name = ownerName
                cdOwner.phone = ownerPhone
                cdOwner.carModel = model
                cdCar.addToOwner(cdOwner)
            }
            
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
     static func fetchRecords() -> [StoredCar] {
        var storedCars = [StoredCar]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return storedCars }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDCar>(entityName: "CDCar")
        
        do {
            let cars = try managedContext.fetch(fetchRequest)
            for car in cars {
                if let model = car.value(forKey: "model") as? String {
                    let predicate = NSPredicate(format: "carModel == %@", model)
                    let fetchOwner = NSFetchRequest<NSFetchRequestResult>(entityName: "CDOwner")
                    fetchOwner.predicate = predicate
                    if let ownerResults = try managedContext.fetch(fetchOwner) as? [CDOwner] {
                        let storedCar = StoredCar(car: car, owners: ownerResults)
                        storedCars.append(storedCar)
                    }
                }
            }
        }catch {
            print(error)
        }
        return storedCars
    }
    
    static func deleteAllRecords() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteCarFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDCar")
        let deleteCarRequest = NSBatchDeleteRequest(fetchRequest: deleteCarFetch)
        let deleteOwnerFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDOwner")
        let deleteOwnerRequest = NSBatchDeleteRequest(fetchRequest: deleteOwnerFetch)
        do
        {
            try managedContext.execute(deleteCarRequest)
            try managedContext.execute(deleteOwnerRequest)
            try managedContext.save()
        }
        catch {
            print(error)
        }
    }
}
