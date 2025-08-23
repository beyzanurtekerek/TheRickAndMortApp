//
//  DetailViewModel.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 23.08.2025.
//

import Foundation

// MARK: - Protocols
protocol DetailViewModelProtocol {
    var onStateChange: ((DetailViewState) -> Void)? { get set }

    func viewDidLoad()
    func viewWillAppear()
}

// MARK: - View State
struct DetailViewState: Equatable {
    let navigationTitle: String
    let name: String
    let statusText: String
    let statusKind: StatusKind
    let imageURL: URL?
    let infoRows: [InfoRow]
}

enum StatusKind: Equatable {
    case alive
    case dead
    case unknown
}

struct InfoRow: Equatable {
    let icon: String
    let title: String
    let value: String
}

// MARK: - ViewModel
final class DetailViewModel: DetailViewModelProtocol {
    var onStateChange: ((DetailViewState) -> Void)?

    private let character: Character

    init(character: Character) {
        self.character = character
    }

    func viewDidLoad() {
        let state = makeState(from: character)
        onStateChange?(state)
    }

    func viewWillAppear() {
        // no op. for now
    }

    // Mapping
    private func makeState(from c: Character) -> DetailViewState {
        let title = (c.name ?? "UNKNOWN").uppercased()
        let name = c.name ?? "Unknown Character"
        let statusRaw = c.status.rawValue
        let statusText = statusRaw.uppercased()
        let statusKind: StatusKind
        switch statusRaw.lowercased() {
        case "alive": statusKind = .alive
        case "dead": statusKind = .dead
        default: statusKind = .unknown
        }

        let imageURL: URL?
        if let imageString = c.image, let url = URL(string: imageString) {
            imageURL = url
        } else {
            imageURL = nil
        }

        let rows: [InfoRow] = [
            InfoRow(icon: "🧬", title: "Species", value: c.species ?? "Unknown"),
            InfoRow(icon: "🔮", title: "Type", value: (c.type?.isEmpty == false ? c.type! : "Unknown")),
            InfoRow(icon: "⚧️", title: "Gender", value: "\(c.gender.rawValue) \(c.gender.icon)"),
            InfoRow(icon: "🪐", title: "Origin", value: c.origin.name ?? "Unknown"),
            InfoRow(icon: "🌍", title: "Location", value: c.location?.name ?? "Unknown")
        ]

        return DetailViewState(
            navigationTitle: title,
            name: name,
            statusText: statusText,
            statusKind: statusKind,
            imageURL: imageURL,
            infoRows: rows
        )
    }
}
