//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Adit Salim on 16/12/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var errMsg: String?
//    @Published var coin = ""
//    @Published var price = ""
//    @Published var errorMsg: String?
    
    private let service = CoinDataService()
    
    init() {
//        fetchPrice(coin: "bitcoin")
//        fetchCoins()
        Task { try await asyncFetchCoins() }
    }
    
    func asyncFetchCoins() async throws {
//        self.coins = try await service.asyncFetchCoins()
        self.coins = await service.genericCall()
    }
    
    func fetchCoins() {
        service.fetchCoins { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errMsg = error.localizedDescription
                }
            }
        }
    }
    
//    func fetchPrice(coin: String) {
//        service.fetchPrice(coin: coin) { price in
//            DispatchQueue.main.async {
//                self.coin = coin
//                self.price = "\(price)"
//            }
//        }
//    }
}
