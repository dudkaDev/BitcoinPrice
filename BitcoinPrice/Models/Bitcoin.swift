//
//  Bitcoin.swift
//  BitcoinPrice
//
//  Created by Андрей Абакумов on 05.11.2022.
//


struct Bitcoin: Decodable {
    let time: Time
    let chartName: String
    let bpi: Price
    
    init() {
        time = Time(value: [:])
        chartName = ""
        bpi = Price(value: [:])
    }
    
    init(bitcoinData: [String: Any]) {
        let timeDict = bitcoinData["time"] as? [String: String] ?? [:]
        time = Time(value: timeDict)
        chartName = bitcoinData["chartName"] as? String ?? ""
        let bpiDict = bitcoinData["bpi"] as? [String: Any] ?? [:]
        bpi = Price(value: bpiDict)
    }
    static func getBitcoinData(from data: Any) -> Bitcoin {
        guard let data = data as? [String: Any] else { return Bitcoin() }
        return Bitcoin(bitcoinData: data)
    }
}

struct Time: Decodable {
    let updated: String
    
    init(value: [String: String]) {
        updated = value["updated"] ?? ""
    }
}

struct Price: Decodable {
    let usd: Currency
    let eur: Currency
    
    init(value: [String: Any]) {
        let usdDict = value["USD"] as? [String: Any] ?? [:]
        usd = Currency(value: usdDict)
        
        let eurDict = value["EUR"] as? [String: Any] ?? [:]
        eur = Currency(value: eurDict)
    }
}

struct Currency: Decodable {
    let rateFloat: Double
    
    init(value: [String: Any]) {
        rateFloat = value["rate_float"] as? Double ?? 0
    }
}


