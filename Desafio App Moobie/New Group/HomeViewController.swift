//
//  ViewController.swift
//  Desafio App Moobie
//
//  Created by William Tomaz on 01/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit
    
enum ErrorType: String {
    case empty = "Selecione a marca e modelo do seu carro desejado para continuar"
    case brandEmpty = "Primeiro, selecione a marca do carro desejado"
}

class HomeViewController: UIViewController {
    
//MARK: - IBOutlets
    
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfModel: UITextField!
    @IBOutlet weak var tfYear: UITextField!

//MARK: - Variables
    
    var brands: [Brands] = []
    var models: [Models] = []
    var details: [Details] = []
    var selected: String = ""
    var codigoFipe = ""

    lazy var pickerView: UIPickerView = {
          let pickerView = UIPickerView()
          pickerView.backgroundColor = .white
          pickerView.setValue(UIColor.black, forKeyPath: "textColor")
          pickerView.delegate = self
          pickerView.dataSource = self
          return pickerView
      }()
    
    lazy var aiLoading: UIActivityIndicatorView = {
        let aiLoading = UIActivityIndicatorView()
        aiLoading.hidesWhenStopped = true
        aiLoading.color = .red
        aiLoading.style = .whiteLarge
        aiLoading.frame = CGRect(x: 165, y: 87, width: 46, height: 46)
        return aiLoading
    }()
    
//MARK: - a
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfBrand.text = nil
        tfModel.text = nil
        tfYear.text = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CarsViewController
        for details in self.details {
            vc.detail = details
            vc.enableButton = true
        }
    }

  //MARK: - IBActions
    
    @IBAction func Search(_ sender: UIButton) {
        if tfBrand.text!.isEmpty || tfModel.text!.isEmpty {
            showAlert(errorType: .empty)
        }
    }
    
    @IBAction func selectBrand(_ sender: UITextField) {
        selected = "brand"
        loadPickerView()
        loadREST()
    }
    
    @IBAction func selectModel(_ sender: UITextField) {
        if tfBrand.text!.isEmpty {
            showAlert(errorType: .brandEmpty)
        } else {
            selected = "model"
            loadPickerView()
            loadREST()
        }
    }
    
    
    // MARK: - Methods
    
    @objc func cancel() {
        if selected == "brand" {
            tfBrand.resignFirstResponder()
        } else {
            tfModel.resignFirstResponder()
        }
    }
    
    @objc func done() {
        if selected == "brand" {
            tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].marca
        } else {
            tfModel.text = models[pickerView.selectedRow(inComponent: 0)].modelo
            tfYear.text = models[pickerView.selectedRow(inComponent: 0)].ano
            codigoFipe = models[pickerView.selectedRow(inComponent: 0)].codigo_fipe
            loadDetail(ano: tfYear.text!)
        }
        cancel()
    }
    
    func loadREST() {
        aiLoading.startAnimating()
        pickerView.isUserInteractionEnabled = false
        if selected == "brand"{
            REST.loadBrand{ (brands) in
                if let brands = brands {
                    self.brands = brands.sorted(by: {$0.marca < $1.marca}) //nome o primeiro tem que ser menor que do proximo
                    DispatchQueue.main.async {
                        self.reload()
                    }
                }
            }
        } else {
            REST.loadModel(brand: tfBrand.text!) { (models) in
                if let models = models {
                    self.models = models.sorted(by: {$0.modelo < $1.modelo})
                    DispatchQueue.main.async {
                        self.reload()
                    }
                }
            }
        }
    }
    
    func loadDetail(ano: String) {
        REST.loadDetails(codigo_fipe: codigoFipe, ano: ano) { (details) in
            if let details = details {
                self.details = details
            }
        }
    }
    
    func loadPickerView() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        if selected == "brand" {
            tfBrand.inputAccessoryView = toolbar
            tfBrand.inputView = pickerView
            pickerView.addSubview(aiLoading)
        } else {
            tfModel.inputAccessoryView = toolbar
            tfModel.inputView = pickerView
            pickerView.addSubview(aiLoading)
        }
    }
    
    func reload() {
        self.aiLoading.stopAnimating()
        self.pickerView.isUserInteractionEnabled = true
        self.pickerView.reloadAllComponents()
    }
    
    func showAlert(errorType: ErrorType) {
        let vazio = UIAlertController(title: "Campo vazio!", message: "\(errorType.rawValue)", preferredStyle: .alert)
        let confirmar = UIAlertAction(title: "Confirmar", style: .destructive, handler: nil)
        present(vazio, animated: true, completion: nil)
        vazio.addAction(confirmar)
    }
}

// MARK: - Extensions

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selected == "brand" {
            return brands.count
        } else {
            return models.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selected == "brand"{
        let brand = brands[row]
        return brand.marca
        } else {
            let model = models[row]
                return model.modelo
        }
    }
}

extension UITextField {

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
    }
}
