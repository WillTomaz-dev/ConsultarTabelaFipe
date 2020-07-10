//
//  REST.swift
//  Desafio App Moobie
//
//  Created by William Tomaz on 01/07/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

class REST {
    
    static private let basePath = "http://fipe-api.herokuapp.com/cars/"
    
    class func loadBrand(onComplete: @escaping ([Brands]?) -> Void) {
        let url = ("\(basePath)brand")
        let request = AF.request(url)
        request.responseJSON{ (response) in
        guard let data = response.data, let brands = try? JSONDecoder().decode([Brands].self, from: data) else {
            onComplete(nil)
            return
            }
        onComplete(brands)
        return
        }
    }
    
    class func loadModel(brand: String, onComplete: @escaping ([Models]?) -> Void) {
        let url = ("\(basePath)brand/\(brand)")
        let request = AF.request(url)
        request.responseJSON{ (response) in
        guard let data = response.data, let models = try? JSONDecoder().decode([Models].self, from: data) else {
            onComplete(nil)
            return
            }
        onComplete(models)
        return
        }
    }
    
    class func loadDetails(codigo_fipe: String, ano: String, onComplete: @escaping ([Details]?) -> Void) {
        let url = ("\(basePath)\(codigo_fipe)/\(ano)")
        let request = AF.request(url)
        request.responseJSON{ (response) in
        guard let data = response.data, let details = try? JSONDecoder().decode([Details].self, from: data) else {
            onComplete(nil)
            return
            }
        onComplete(details)
        return
        }
    }
}
