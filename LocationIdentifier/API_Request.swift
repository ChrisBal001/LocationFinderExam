////
////  API_Request.swift
////  LocationIdentifier
////
////  Created by FDC.Chris on 4/30/24.
////
//
//import Foundation
//import PromiseKit
//import Alamofire
//
//func post_API(url: String) -> Promise<Any> {
//    return Promise<Any> { seal in
//        AF.request(url, method: .post, encoding: JSONEncoding.default)
//            .validate()
//            .responseJSON(completionHandler: { response in
//                switch response.result {
//                case .success(let value):
//                    seal.fulfill(value)
//                case .failure(let error):
//                    seal.reject(error)
//                }
//            })
//    }
//}
//
//func makeAPIRequest() -> Promise<YourResponseType> {
//    return Promise { seal in
//        // Make the API request using Alamofire
//        AF.request("Your API URL", method: .get)
//            .validate() // Optional: Validate the response
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    // Parse the response data into your response type
//                    if let responseData = try? JSONSerialization.data(withJSONObject: value),
//                       let responseObject = try? JSONDecoder().decode(YourResponseType.self, from: responseData) {
//                        seal.fulfill(responseObject) // Resolve the Promise with the response object
//                    } else {
//                        seal.reject(APIError.parsingError) // Reject the Promise if parsing fails
//                    }
//                case .failure(let error):
//                    seal.reject(error) // Reject the Promise with the Alamofire error
//                }
//            }
//    }
//}
//
//// Define your custom response type
//struct YourResponseType: Codable {
//    // Define your response properties here
//}
//
//// Define custom errors if needed
//enum APIError: Error {
//    case parsingError
//    // Add more error cases as needed
//}
