//
//  Connection.swift
//  CoinTred
//
//  Created by MAC on 12/03/22.
//

import UIKit
import SwiftEventBus

class Connection {
    
    private static var privateShared : Connection?
    
    static var shared = Connection()
    
    let task = URLSession.shared
    let timeoutInterval: Double = 60
    
    func connect<T:Decodable>( url: String, params: [String:Any]?, httpMethod: String = "POST", model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {

        guard let _url = URL(string: url) else {
            fatalError("invalid url: " + url)
        }
        var request = URLRequest(url: _url)
        request.httpMethod = params == nil ? "GET" : httpMethod
        request.httpMethod = (params == nil && httpMethod != "POST") ? httpMethod : request.httpMethod
        request.addValue("Bearer", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = params, let body = try? JSONSerialization.data(withJSONObject: params, options: [.fragmentsAllowed]) {
            request.httpBody = body
        }
        
        self.task.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error{
                    if error.localizedDescription == "The request timed out."{
                        SwiftEventBus.post("REQUEST_TIMEOUT")
                    }
                    print("error : \(String(describing: error))")
                    return
                }
                
                if let data = data, let stringResponse = String(data: data, encoding: .utf8) {
                    print("JSON from ==> "+url+" "+stringResponse)
                }
                
                if let a = response as? HTTPURLResponse {                    
                    if a.statusCode == 200 || a.statusCode == 201 {
                        do {
                            let responseModel = try JSONDecoder().decode(T.self, from: data!)
                            completion(.success(responseModel))
                        } catch let jsonError {
                            completion(.failure(jsonError))
                            print(String(describing: jsonError))
                        }
                    } else {
                        completion(.failure(RequestError.failed_response(e: "\(a.statusCode)")))
                    }
                }
            }
        }.resume()
    }
}

enum RequestError: Error {
    case failed_response(e: String)
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .failed_response(e):
            return e
        }
    }
}
