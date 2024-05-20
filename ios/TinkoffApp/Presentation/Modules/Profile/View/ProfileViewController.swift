//
//  ProfileViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var output: ProfileViewOutput

    private lazy var editButton = UIButton()
    private lazy var profileImageView = UIImageView()
    private lazy var addPhotoButton = UIButton(type: .system)
    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var backgroundView = UIView()
    private lazy var ratingLabel = UILabel()
    private lazy var starView = UIImageView()
    private lazy var detailsButton = UIButton(type: .system)
    private lazy var ratingView = UIView()
    
    private let lightTheme = [
        "backgroundColor": UIColor.systemGray6,
        "secondaryBackgroundColor": UIColor.white,
        "textColor": UIColor.black,
        "secondaryTextColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    ]
    
    private let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "secondaryBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "secondaryTextColor": UIColor.systemGray5
    ]
    
    init(output: ProfileViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        output.viewIsReady()
    }

    private func setupView() {
        setupTitle()
        setupBackgroundView()
        setupImageView()
        setupNameLabel()
        setupRating()
        setupAddPhotoButton()
        setupEditButton()
        setupTheme()
        setupMedal()
    }
    
    private func setupMedal() {
        let medal = UIImageView(image: UIImage(systemName:  "medal.fill"))
        medal.tintColor = Colors.yellow.uiColor
        view.addSubview(medal)
        medal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            medal.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15),
            medal.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            medal.heightAnchor.constraint(equalToConstant: 35),
            medal.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMedalTap(_:)))
        medal.isUserInteractionEnabled = true
        medal.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleMedalTap(_ sender: UITapGestureRecognizer) {
        output.openRating()
    }
    
    private func setupTheme() {
        let themeColors = lightTheme
        view.backgroundColor = themeColors["backgroundColor"]
        backgroundView.backgroundColor = themeColors["secondaryBackgroundColor"]
        nameLabel.textColor = themeColors["textColor"]
        descriptionLabel.textColor = themeColors["secondaryTextColor"]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeColors["textColor"] ?? .black]
    }
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupTitle() {
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        editButton.setTitle("Редактировать", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        editButton.backgroundColor = Colors.yellow.uiColor
        editButton.layer.cornerRadius = 14
        
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            backgroundView.bottomAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16)
        ])
        
        editButton.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )
    }
    
    
    private func setupImageView() {
        profileImageView.accessibilityIdentifier = "profileImageView"
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        profileImageView.layer.cornerRadius = 75
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "avatar")
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.accessibilityIdentifier = "addPhotoButton"
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        addPhotoButton.setTitle("Подробнее", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22),
            addPhotoButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 24),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    private func setupNameLabel() {
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 22.0, weight: .bold)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            nameLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16)
        ])
    }
    
    private func setupRating() {
        view.addSubview(ratingView)
        ratingView.addSubview(starView)
        ratingView.addSubview(ratingLabel)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        starView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        starView.image = UIImage(systemName: "star.fill")
        starView.tintColor = Colors.yellow.uiColor
        ratingLabel.textColor = .black
        ratingLabel.font = .systemFont(ofSize: 20, weight: .bold)
        ratingLabel.text = "8.0"
        
        NSLayoutConstraint.activate([
            starView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            starView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -5),
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16)
        ])
        
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textAlignment = .left//.center
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(greaterThanOrEqualTo: backgroundView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: backgroundView.rightAnchor, constant: -16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
        ])
    }
    
    @objc private func addPhotoButtonTapped() {
        output.addPhotoButtonTapped(with: self)
    }
    
    @objc private func editButtonTapped() {
        output.editButtonTapped(with: self)
    }
}

extension ProfileViewController: ProfileViewInput {
    func updateProfile(with model: UserProfileViewModel) {
        nameLabel.text = model.userName ?? "Нет имени"
        descriptionLabel.text = model.userDescription ?? " "
        if let imageData = model.userAvatar {
            profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
    }
}

extension ProfileViewController: ProfileSaveDelegate {
    func profileSaved(with profileModel: UserProfileViewModel) {
        output.update(with: profileModel)
    }
}
