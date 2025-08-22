//
//  APICaller.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 21.08.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
}

protocol CharacterServiceProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void)
}

struct Constants {
    static let baseURL = "https://rickandmortyapi.com/api/"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
}

final class URLSessionNetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Sadece bu kaldı
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}

final class APICaller: CharacterServiceProtocol {
    
    static let shared = APICaller(service: URLSessionNetworkService())
    private let service: NetworkServiceProtocol
    
    private init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void) {
        let urlString = "\(Constants.baseURL)character/?page=\(page)"
        print("Fetching characters from URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        service.fetch(url: url, completion: completion)
    }

}
