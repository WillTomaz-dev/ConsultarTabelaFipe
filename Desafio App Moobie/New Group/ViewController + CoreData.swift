//
//  ViewController + CoreData.swift
//  Desafio App Moobie
//
//  Created by da Silva, William on 09/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//


import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
