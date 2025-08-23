//
//  APICaller.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 21.08.2025.
//

import Foundation

// MARK: - Protocols
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
}

protocol CharacterServiceProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void)
}

// MARK: - Constants
struct Constants {
    static let baseURL = "https://rickandmortyapi.com/api/"
}

// MARK: - Errors
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
}

// MARK: - Network Service
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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}

// MARK: - API Caller
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
