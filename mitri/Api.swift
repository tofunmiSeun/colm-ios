//
//  Api.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 28/11/2022.
//

import Foundation

struct Api {
    static let serverUrl = ProcessInfo.processInfo.environment["base_server_url"]!
    
    static func get(uri: String, completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: serverUrl + uri) else {
            print("Invalid url")
            return
        }

        URLSession.shared.dataTask(with: url) {(data, response, error) in
            onApiResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }.resume()
    }
    
    static func post(uri: String, body: Optional<Encodable> = nil, completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: serverUrl + uri) else {
            print("Invalid url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let unwrappedBody = body {
            guard let encodedRequestBody = try? JSONEncoder().encode(unwrappedBody) else {
                print("Request body could not be encoded")
                return
            }
            urlRequest.httpBody = encodedRequestBody
        }
        
        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            onApiResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }.resume()
    }
    
    static func onApiResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Data) -> Void) {
        if error != nil {
            print("Error while fetching data")
            return
        }
        
        guard let response = (response as? HTTPURLResponse) else {
            print("Error while fetching data")
            return
        }
        
        if response.statusCode != 200 {
            print("Invalid http response")
            return
        }
        
        guard let data = data else { return }
        completionHandler(data)
    }
    
    struct Utils {
        static func decodeAsObject<T: Decodable>(data: Data) -> Optional<T> {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                return nil
            }
        }
        
        static func decodeAsString(data: Data) -> String {
            return  String(decoding: data, as: UTF8.self)
        }
    }
}
