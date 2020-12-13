//
//  Network Service.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import Foundation

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    public func getData(url: URL, completion: @escaping (Any) -> Void) {
        let session = URLSession.shared
        // следующая строка вызывает ошибку, не влияющую на работу приложения
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print(error)
            }
        }.resume()
    }

}
