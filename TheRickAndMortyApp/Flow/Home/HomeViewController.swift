//
//  HomeViewController.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 19.08.2025.
//

import UIKit

class HomeViewController: UIViewController {

    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rick And Morty Characters"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
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
        setupBindings()
        viewModel.fetchCharacters(page: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let itemWidth = (view.frame.size.width / 2) - 18
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        layout.itemSize = CGSize(width: itemWidth, height: 200)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.shouldFetchNextPage(
            currentOffset: scrollView.contentOffset.y,
            contentHeight: scrollView.contentSize.height,
            frameHeight: scrollView.frame.height) {
            viewModel.fetchNextPageIfNeeded()
        }
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.didUpdate = { [weak self] in
            print("Karakterler geldi: \(self?.viewModel.characters.count ?? 0)")
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.didFailWithError = { [weak self] error in
            print("Hata: \(error.localizedDescription)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
}

// MARK: - CollectionView DataSource & Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        let character = viewModel.characters[indexPath.row]
        cell.configureCharacterCell(with: character.image, title: character.name ?? "No Name")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.configureWithCharacter(with: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

