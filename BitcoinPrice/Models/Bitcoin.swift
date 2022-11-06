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
}

struct Time: Decodable {
    let updated: String
}

struct Price: Decodable {
    let USD: Currency
    let EUR: Currency
}

struct Currency: Decodable {
    let rate_float: Double
}

enum Link: String {
case bitcoinPriceApi = "https://api.coindesk.com/v1/bpi/currentprice.json"
}
