//
//  HomeViewModel.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 22.08.2025.
//

import Foundation

protocol HomeViewModelProtocol {
    var characters: [Character] { get }
    var didUpdate: (() -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }
    
    func fetchCharacters(page: Int)
    func fetchNextPageIfNeeded()
}

final class HomeViewModel: HomeViewModelProtocol {
    
    private let service: CharacterServiceProtocol
    private(set) var characters: [Character] = []
    
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    
    var didUpdate: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    init(service: CharacterServiceProtocol = APICaller.shared) {
        self.service = service
    }
    
    func fetchCharacters(page: Int = 1) {
        guard  !isLoading else { return }
        isLoading = true
        
        service.fetchCharacters(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.characters.append(contentsOf: response.results)
                self.totalPages = response.info.pages
                self.currentPage = page
                self.didUpdate?()
            case.failure(let error):
                self.didFailWithError?(error)
            }
        }
    }
    
    func fetchNextPageIfNeeded() {
        guard currentPage < totalPages else { return }
        fetchCharacters(page: currentPage + 1)
    }
    
}
