//
//  Car.swift
//  Desafio App Moobie
//
//  Created by da Silva, William on 09/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import CoreData

class CarManager {
    static let shared = CarManager()
    var carDetail: [CarDetail] = []
    
    func loadCars(with context: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<CarDetail> = CarDetail.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "modelo", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            carDetail = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteCars(index: Int, context: NSManagedObjectContext) {
        let car = carDetail[index]
        context.delete(car) //excluiu do contexto
        do {
            try context.save()
            carDetail.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
