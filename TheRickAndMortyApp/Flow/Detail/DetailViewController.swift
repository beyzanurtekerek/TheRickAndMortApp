//
//  DetailViewController.swift
//  TheRickAndMortyApp
//
//  Created by Beyza Nur Tekerek on 20.08.2025.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: DetailViewModelProtocol
    
    // MARK: - Initializers
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) or init(character:) instead.")
    }
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Helper
    private func createInfoRow(icon: String, title: String, value: String) -> UIStackView {
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupUI()
        applyConstraints()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        contentView.addSubview(infoContainer)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusBadge)
        infoContainer.addSubview(infoStackView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statusBadge.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            statusBadge.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            infoContainer.topAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: 24),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            infoStackView.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            self.navigationItem.title = state.navigationTitle
            self.nameLabel.text = state.name
            self.statusBadge.text = state.statusText
            
            let colors = self.colors(for: state.statusKind)
            self.statusBadge.backgroundColor = colors.background
            self.statusBadge.textColor = colors.text
            
            if let url = state.imageURL {
                self.imageView.kf.setImage(with: url)
                self.backgroundImageView.kf.setImage(with: url)
            }
            
            // Rebuild info rows
            self.infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            state.infoRows.forEach { row in
                self.infoStackView.addArrangedSubview(
                    self.createInfoRow(icon: row.icon, title: row.title, value: row.value)
                )
            }
        }
    }
    
    // MARK: - Helpers
    private func colors(for kind: StatusKind) -> (background: UIColor, text: UIColor) {
        switch kind {
        case .alive:
            return (.systemGreen, .white)
        case .dead:
            return (.systemRed, .white)
        case .unknown:
            return (.systemGray, .white)
        }
    }
    
}
