//
//  HomeViewController.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 19.08.2025.
//

import UIKit

class HomeViewController: UIViewController {

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rick And Morty Characters"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var setupCollectionView: UICollectionView = {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 100, height: 200) // temporary
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let itemWidth = (view.frame.size.width / 2) - 18
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        layout.itemSize = CGSize(width: itemWidth, height: 200)
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(setupCollectionView)
        
        setupCollectionView.delegate = self
        setupCollectionView.dataSource = self
    }
    
    private func applyConstraints() { // will be edit
        NSLayoutConstraint.activate([
            
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        setupCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        setupCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        setupCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        setupCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20 // example count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        // Configure the cell with data
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
}

