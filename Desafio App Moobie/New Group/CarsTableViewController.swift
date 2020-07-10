//
//  CarsTableViewController.swift
//  Desafio App Moobie
//
//  Created by William Tomaz on 01/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit
import CoreData

class CarsTableViewController: UITableViewController {
    
    // MARK: - Variables
//    var fetchedResultController: NSFetchedResultsController<CarDetail>!
    var carDatail: CarDetail!
    var label = UILabel()
    var carManager = CarManager.shared
    
    // MARK: - a
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Você não possui carros salvos"
        label.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CarsViewController
        vc.enableButton = false
        let index = tableView.indexPathForSelectedRow!.row
        let carDetail = carManager.carDetail[index]
        vc.carData = carDetail
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let count = carManager.carDetail.count
            
            tableView.backgroundView = count == 0 ? label : nil
            return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let carDetail = carManager.carDetail[indexPath.row]
        cell.textLabel?.text = carDetail.modelo
        cell.detailTextLabel?.text = carDetail.ano
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            carManager.deleteCars(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Methods
    
    func loadCars() {
        carManager.loadCars(with: context)
        tableView.reloadData()
    }
}
