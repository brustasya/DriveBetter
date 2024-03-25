//
//  ProfileEditingViewControllerExtensions.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import UIKit
import AVFoundation

extension ProfileEditingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        editProfileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    internal func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            if type == .camera {
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                
                switch cameraAuthorizationStatus {
                case .authorized:
                    self.present(self.pickerController, animated: true)
                    
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { _ in }
                    
                case .restricted, .denied:
                    let alertController = UIAlertController(
                        title: "Доступ к камере запрещен",
                        message: "Разрешите доступ к камере в настройках приложения",
                        preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                    
                    let openSettingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(openSettingsAction)
                    
                    present(alertController, animated: true, completion: nil)
                @unknown default:
                    break
                }
            } else {
                self.present(self.pickerController, animated: true)
            }
        }
    }
}

extension ProfileEditingViewController: ProfileEditingViewInput {
    func enableEditing() {
        nameTextField.placeholder = "Введите ваше имя"
        cityTextField.placeholder = "Введите город проживания"
        ageTextField.placeholder = "Введите свой возраст"
        sexTextField.placeholder = "Введите свой пол (Ж/М)"
        licenseNumberTextField.placeholder = "XX XX XXXXXX"
        
        changeTextFieldsEnable(to: true)
        
        saveButton.setTitle("Сохранить", for: .normal)
        cancelButton.setTitle("Отменить", for: .normal)
    }
    
    func disableEditing() {
        nameTextField.placeholder = "Не указано"
        cityTextField.placeholder = "Не указан"
        ageTextField.placeholder = "Не указан"
        sexTextField.placeholder = "Не указан"
        licenseNumberTextField.placeholder = "Не указан"
        
        changeTextFieldsEnable(to: false)
        
        saveButton.setTitle("Изменить", for: .normal)
        cancelButton.setTitle("Закрыть", for: .normal)
    }
    
    func updateProfileData(with profileModel: UserProfileViewModel) {
        nameTextField.text = profileModel.userName ?? ""
        cityTextField.text = profileModel.userDescription ?? ""
        ageTextField.text = profileModel.age ?? ""
        sexTextField.text = profileModel.sex ?? ""
        licenseNumberTextField.text = profileModel.licenceNumber ?? ""
        
        if nameTextField.text == "Нет имени" { nameTextField.text = "" }
        if cityTextField.text == "-" { cityTextField.text = "" }
        
        if let imageData = profileModel.userAvatar {
            editProfileImageView.image = UIImage(data: imageData)
        } else {
            editProfileImageView.image = UIImage(named: "avatar")
        }
    }
    
    func changeEnableForSaving(_ isSaving: Bool) {
        if isSaving {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        saveButton.isHidden = isSaving
        nameTextField.isEnabled = !isSaving
        cityTextField.isEnabled = !isSaving
        addPhotoButton.isEnabled = !isSaving
    }
    
    func showSucsessAlert() {
        let alertController = UIAlertController(title: "Успех!", message: "Профиль успешно сохранен", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.disableEditing()
            self?.output.stopEditing()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Не удалось сохранить", message: "Попробовать еще раз", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.disableEditing()
            self?.output.stopEditing()
        }
        
        let tryAgainAction = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] (_) in
            self?.saveProfileDataButtonTaped()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPhotoAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Сделать фото") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Выбрать из галереи") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(alertController, animated: true)
    }
}

