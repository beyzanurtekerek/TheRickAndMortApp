//
//  CharacterCell.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 20.08.2025.
//

import UIKit
import Kingfisher

class CharacterCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CharacterCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        setupUI()
        applyConstraints()
        styleCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func styleCard() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        
        //bordfer
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        //shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
    
    // MARK: - Public Funcs
    func configureCharacterCell(with imageUrlString: String?, title: String) {
        nameLabel.text = title
        if let url = URL(string: imageUrlString ?? "") {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            )
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
}
