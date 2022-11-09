//
//  NetworkManager.swift
//  BitcoinPrice
//
//  Created by Андрей Абакумов on 08.11.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum Link: String {
    case bitcoinPriceApi = "https://api.coindesk.com/v1/bpi/currentprice.json"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: String, completion: @escaping (Result<Bitcoin, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let bitcoin = try JSONDecoder().decode(Bitcoin.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(bitcoin))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

