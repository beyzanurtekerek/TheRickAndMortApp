//
//  APICaller.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 21.08.2025.
//

import Foundation

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

protocol NetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class URLSessionNetworkService: NetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}

final class APICaller {
    static let shared = APICaller(service: URLSessionNetworkService())
    private let service: NetworkService
    
    private init(service: NetworkService) {
        self.service = service
    }
    
    func fetchCharacters(completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)character") else {
            completion(.failure(.invalidURL))
            return
        }
        service.fetch(url: url, completion: completion)
    }
}
