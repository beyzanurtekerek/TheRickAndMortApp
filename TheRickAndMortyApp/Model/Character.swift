//
//  Character.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 20.08.2025.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String?
    let gender: CharacterGender
    let origin: Origin
    let location: Location
    let image: String
    let episode: [URL]
    let url: URL
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url
        case createdAt = "created"
    }
}

struct Origin: Codable {
    let name: String
    let url: URL?
}

struct Location: Codable {
    let name: String
    let url: URL?
}

enum CharacterStatus: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum CharacterGender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
