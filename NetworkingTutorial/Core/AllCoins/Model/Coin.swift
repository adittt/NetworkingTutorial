//
//  Coin.swift
//  NetworkingTutorial
//
//  Created by Adit Salim on 17/12/23.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let image: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, image, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
    
}
