//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by Adit Salim on 16/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        
        List {
            ForEach(viewModel.coins) { coin in
                HStack(spacing: 12) {
                    Text("\(coin.marketCapRank)")
                        .foregroundStyle(Color.gray)
                    
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }

                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.name)
                            .fontWeight(.semibold)
                        
                        Text(coin.symbol.uppercased())
                    }

                }
                .font(.footnote)
            }
        }
        .overlay {
            if let error = viewModel.errMsg {
                Text(error)
            }
        }

    }
}

#Preview {
    ContentView()
}
