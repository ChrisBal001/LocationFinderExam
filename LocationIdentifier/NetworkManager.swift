//
//  NetworkManager.swift
//  LocationIdentifier
//
//  Created by FDC.Chris on 4/30/24.
//

import Foundation
import AdSupport
import PromiseKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let apiURL = "https://restcountries.com/v3.1/all"
    
    
    func fetchAPI() -> Promise<Any> {
        return Promise { seal in
            AF.request(apiURL).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}


struct CountriesCommonName {
    var region: String
    var name: [nameData]
}

struct nameData {
    var common: String
}

struct Country: Codable {
    let name: [String: String]
    let region: String
}
