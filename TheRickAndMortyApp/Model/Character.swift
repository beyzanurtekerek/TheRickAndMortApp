//
//  Character.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 20.08.2025.
//

import Foundation
import UIKit

struct CharacterResponse: Decodable {
    let info: Info
    let results: [Character]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let status: CharacterStatus
    let species: String?
    let type: String?
    let gender: CharacterGender
    let origin: Origin
    let location: Location?
    let image: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image
    }
}

struct Origin: Decodable {
    let name: String?
}

struct Location: Decodable {
    let name: String?
}

enum CharacterStatus: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    // UI'da kullanmak için renk döndüren helper property
    var color: UIColor {
        switch self {
        case .alive: return .systemGreen
        case .dead: return .systemRed
        case .unknown: return .systemGray
        }
    }
}

enum CharacterGender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    // UI'da kullanmak için simge döndüren helper property
    var icon: String {
        switch self {
        case .female: return "♀"
        case .male: return "♂"
        case .genderless: return "⚪"
        case .unknown: return "❓"
        }
    }
}
