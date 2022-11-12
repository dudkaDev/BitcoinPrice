//
//  NetworkManager.swift
//  BitcoinPrice
//
//  Created by Андрей Абакумов on 08.11.2022.
//

import Foundation
import Alamofire

enum Link: String {
    case bitcoinPriceApi = "https://api.coindesk.com/v1/bpi/currentprice.json"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}

    func fetchData(from url: String, completion: @escaping(Result<Bitcoin, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let bitcoin = Bitcoin.getBitcoinData(from: value)
                    completion(.success(bitcoin))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

