//
//  DetailViewController.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 20.08.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var character: Character?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private let nameLabel = DetailViewController.makeLabel()
    private let statusLabel = DetailViewController.makeLabel()
    private let speciesLabel = DetailViewController.makeLabel()
    private let genderLabel = DetailViewController.makeLabel()
    private let locationLabel = DetailViewController.makeLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(speciesLabel)
        view.addSubview(genderLabel)
        view.addSubview(locationLabel)
        
        applyConstraints()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = 15
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            speciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            speciesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speciesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            speciesLabel.heightAnchor.constraint(equalToConstant: 30),
            
            genderLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 8),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            genderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            locationLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    private func setupUI() {
        guard let character = character else { return }
        navigationItem.title = character.name?.uppercased()
        nameLabel.text = "• Name 🖋️: \(character.name ?? "Unknown")"
        statusLabel.text = "• Status ✅: \(character.status.rawValue)" // enum old icin rawvalue
        statusLabel.textColor = character.status.color
        speciesLabel.text = "• Species ⚡️: \(character.species ?? "Unknown")"
        genderLabel.text = "• Gender ⚧️: \(character.gender.rawValue) \(character.gender.icon)"
        locationLabel.text = "• Location 🌍: \(character.location?.name ?? "Unknown")"
        
        if let imageString = character.image, let url = URL(string: imageString) {
            loadImage(from: url)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
    
    public func configureWithCharacter(with character: Character) {
        self.character = character
        if isViewLoaded {
            setupUI()
        }
    }
    
    
    
}
