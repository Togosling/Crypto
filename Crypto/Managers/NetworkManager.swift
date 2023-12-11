//
//  NetworkManager.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    func dowload(url: URL) -> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Finished fetching transactions")
        case .failure(let error):
            print("Failed fetching transactions \(error.localizedDescription)")
        }
    }
}
