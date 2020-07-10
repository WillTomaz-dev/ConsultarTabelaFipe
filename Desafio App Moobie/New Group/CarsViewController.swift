//
//  CarsViewController.swift
//  Desafio App Moobie
//
//  Created by William Tomaz on 01/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit
import CoreData

class CarsViewController: UIViewController {
    
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbModel: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btSave: UIButton!
    
    var detail: Details!
    var enableButton: Bool = false
    var carData: CarDetail!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetail()
    }
    
    @IBAction func Save(_ sender: UIButton) {
        if carData == nil {
            carData = CarDetail(context: context)
        }
        carData.marca = detail.marca
        carData.modelo = detail.modelo
        carData.ano = detail.ano
        carData.preco = lbPrice.text
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        showAlert()
        btSave.isHidden = true
    }
    
    func showDetail() {
        self.navigationController?.isNavigationBarHidden = false
        if enableButton == true {
            btSave.isHidden = false
            title = detail.modelo
            lbBrand.text = "Marca: \(detail.marca)"
            lbModel.text = "Modelo: \(detail.modelo)"
            lbYear.text = "Ano: \(detail.ano)"
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencySymbol = "R$"
            let priceString = currencyFormatter.string(from: NSNumber(value: detail.valor))!
            lbPrice.text = "Preço: \(priceString)"
            
        } else {
            btSave.isHidden = true
            title = carData.modelo
            lbBrand.text = "Marca: \(carData.marca ?? "")"
            lbModel.text = "Modelo: \(carData.modelo ?? "")"
            lbYear.text = "Ano: \(carData.ano ?? "")"
            lbPrice.text = carData.preco
        }
    }
        
    func showAlert() {
        let vazio = UIAlertController(title: "Carro Salvo", message: "Carro salvo na sua lista de favoritos!", preferredStyle: .alert)
        let confirmar = UIAlertAction(title: "Confirmar", style: .destructive, handler: nil)
        present(vazio, animated: true, completion: nil)
        vazio.addAction(confirmar)
    }

}
