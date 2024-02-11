//
//  CoinDataService.swift
//  NetworkingTutorial
//
//  Created by Adit Salim on 17/12/23.
//

import Foundation

class CoinDataService {
    
    private func genericApi<T: Codable>(with urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw CoinAPIError.invalidData }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let listData = try JSONDecoder().decode(T.self, from: data)
            
            return listData
        } catch {
            throw CoinAPIError.unknownError(error: error)
        }
    }
    
    func genericCall() async -> [Coin] {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        
        do {
            let data: [Coin] = try await self.genericApi(with: urlString)
            return data
        } catch {
            return []
        }
    }
    
    func asyncFetchCoins() async throws -> [Coin] {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            
            return coins
        } catch {
            return []
        }
    }
    
    func fetchCoins(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void) {

        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(.jsonParsingFailure))
            }
            
        }
        .resume()
    }
    
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd%2Cidr"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                
            if let error {
                print("Failed with error: \(error.localizedDescription)")
                //                    self.errorMsg = error.localizedDescription
                return
            }
            
            guard let httpRes = response as? HTTPURLResponse else {
                //                    self.errorMsg = "Bad Response"
                return
            }
            
            guard httpRes.statusCode == 200 else {
                //                    self.errorMsg = "Failed to fetch data with status code \(httpRes.statusCode)"
                return
            }
            
            guard let data else { return }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            
            guard let value = jsonObject[coin] as? [String: Double] else { return }
            guard let price = value["usd"] else { return }
            
            completion(price)
            
        }.resume()
    }
}
