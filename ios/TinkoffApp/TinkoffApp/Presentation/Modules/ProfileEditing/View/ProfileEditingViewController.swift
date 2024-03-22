//
//  ProfileEditingViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import UIKit

class ProfileEditingViewController: UIViewController {
    
    internal var output: ProfileEditingViewOutput
    
    internal lazy var titleLabel = UILabel()
    internal lazy var editProfileImageView = UIImageView()
    internal lazy var addPhotoButton = UIButton(type: .system)
    internal lazy var cancelButton = UIButton(type: .system)
    internal lazy var saveButton = UIButton(type: .system)
    
    internal lazy var nameTextField = UITextField()
    internal lazy var nameStackView = UIStackView()
    internal lazy var viewNameBackground = UIView()
    internal lazy var nameEditLabel = UILabel()

    internal lazy var cityStackView = UIStackView()
    internal lazy var viewCityBackground = UIView()
    internal lazy var cityLabel = UILabel()
    internal lazy var cityTextField = UITextField()
    
    internal lazy var ageStackView = UIStackView()
    internal lazy var viewAgeBackground = UIView()
    internal lazy var ageLabel = UILabel()
    internal lazy var ageTextField = UITextField()
    
    internal lazy var licenseNumberStackView = UIStackView()
    internal lazy var viewLicenseNumberBackground = UIView()
    internal lazy var licenseNumberLabel = UILabel()
    internal lazy var licenseNumberTextField = UITextField()
    
    internal lazy var sexStackView = UIStackView()
    internal lazy var viewSexBackground = UIView()
    internal lazy var sexLabel = UILabel()
    internal lazy var sexTextField = UITextField()
        
    internal lazy var bottomSeparator = UIView()
    internal lazy var topSeparator = UIView()
    internal lazy var centerSeparatop = UIView()
    
    internal let pickerController = UIImagePickerController()
    internal lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    internal let lightTheme = [
        "backgroundColor": UIColor.white,
        "editBackgroundColor": UIColor.systemGray6,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    internal let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "editBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "secondaryTextColor": UIColor.systemGray5
    ]

    init(output: ProfileEditingViewOutput) {
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
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        output.viewIsReady()
    }

    private func setupView() {
        setupTitle()
        setupCancelButton()
        setupSaveButton()
        setupEditProfileImageView()
        setupAddPhotoButton()
        setupEditViews()
        changeTheme()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor)
        ])
    }
    
    func changeTheme() {
        let themeColors = lightTheme
        view.backgroundColor = themeColors["editBackgroundColor"]
        titleLabel.textColor = themeColors["textColor"]
        nameStackView.backgroundColor = themeColors["backgroundColor"]
        cityStackView.backgroundColor = themeColors["backgroundColor"]
        viewCityBackground.backgroundColor = themeColors["backgroundColor"]
        viewNameBackground.backgroundColor = themeColors["backgroundColor"]
        nameTextField.backgroundColor = themeColors["backgroundColor"]
        cityTextField.backgroundColor = themeColors["backgroundColor"]
        nameEditLabel.textColor = themeColors["textColor"]
        cityLabel.textColor = themeColors["textColor"]
        nameTextField.textColor = themeColors["textColor"]
        cityTextField.textColor = themeColors["textColor"]
    }
    
    private func setupEditViews() {
        createEditField(backgroundView: viewNameBackground, textField: nameTextField, label: nameEditLabel)
        createEditField(backgroundView: viewCityBackground, textField: cityTextField, label: cityLabel)
        createEditField(backgroundView: viewAgeBackground, textField: ageTextField, label: ageLabel)
        createEditField(backgroundView: viewSexBackground, textField: sexTextField, label: sexLabel)
        createEditField(backgroundView: viewLicenseNumberBackground, textField: licenseNumberTextField, label: licenseNumberLabel, isLast: true)
        
        nameEditLabel.text = "Имя"
        cityLabel.text = "Город"
        ageLabel.text = "Возраст"
        sexLabel.text = "Пол"
        licenseNumberLabel.text = "№ вод. прав"
        
        
                
        NSLayoutConstraint.activate([
            viewNameBackground.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            viewAgeBackground.topAnchor.constraint(equalTo: viewNameBackground.bottomAnchor),
            viewSexBackground.topAnchor.constraint(equalTo: viewAgeBackground.bottomAnchor),
            viewCityBackground.topAnchor.constraint(equalTo: viewSexBackground.bottomAnchor),
            viewLicenseNumberBackground.topAnchor.constraint(equalTo: viewCityBackground.bottomAnchor)
        ])
        
        setupSeparators()
    }
    
    internal func changeTextFieldsEnable(to isEnable: Bool) {
        nameTextField.isEnabled = isEnable
        cityTextField.isEnabled = isEnable
        ageTextField.isEnabled = isEnable
        licenseNumberTextField.isEnabled = isEnable
        sexTextField.isEnabled = isEnable
    }
    
    private func createEditField(backgroundView: UIView, textField: UITextField, label: UILabel, isLast: Bool = false) {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 44),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.widthAnchor.constraint(equalToConstant: 110),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 22),
            textField.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.trailingAnchor, constant: -36),
            
            separator.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.5),
            separator.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])
        
        separator.isHidden = isLast
    }
    
    private func setupSeparators() {
        bottomSeparator.backgroundColor = .systemGray5
        topSeparator.backgroundColor = .systemGray5
        
        view.addSubview(bottomSeparator)
        view.addSubview(topSeparator)
        
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSeparator.bottomAnchor.constraint(equalTo: viewNameBackground.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            topSeparator.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor),
            
            bottomSeparator.topAnchor.constraint(equalTo: viewLicenseNumberBackground.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            bottomSeparator.leadingAnchor.constraint(equalTo: viewLicenseNumberBackground.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: viewLicenseNumberBackground.trailingAnchor),
        ])
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        saveButton.addTarget(
            self,
            action: #selector(saveProfileDataButtonTaped),
            for: .touchUpInside
        )
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.text = "Профиль"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc internal func cancelButtonTapped() {
        output.cancelButtonTapped()
    }
    
    private func setupEditProfileImageView() {
        editProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editProfileImageView)
        
        NSLayoutConstraint.activate([
            editProfileImageView.widthAnchor.constraint(equalToConstant: 150),
            editProfileImageView.heightAnchor.constraint(equalToConstant: 150),
            editProfileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 49),
            editProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        editProfileImageView.layer.cornerRadius = 75
        editProfileImageView.clipsToBounds = true
        editProfileImageView.contentMode = .scaleAspectFill
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        addPhotoButton.setTitle("Изменить фотографию", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            //addPhotoButton.widthAnchor.constraint(equalToConstant: 81),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22),
            addPhotoButton.topAnchor.constraint(equalTo: editProfileImageView.bottomAnchor, constant: 24),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
    }
    
    @objc private func addPhoto() {
        output.addPhotoButtonTapped()
    }
    
    @objc internal func saveProfileDataButtonTaped() {
        let userProfileModel = UserProfileViewModel(
            userName: nameTextField.text == "" ? "Нет имени" : nameTextField.text,
            userDescription: cityTextField.text == "" ? "-" : cityTextField.text,
            userAvatar: editProfileImageView.image?.pngData()
        )
        output.saveButtonTapped(profileModel: userProfileModel)
    }
}
