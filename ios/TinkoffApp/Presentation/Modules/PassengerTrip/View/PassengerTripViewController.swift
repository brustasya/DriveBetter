//
//  PassengerTripViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 16.03.2024.
//

import UIKit

final class PassengerTripViewController: UIViewController {
    private var output: PassengerTripViewOutput
    
    private lazy var closeButton = UIButton(type: .system)
    private lazy var passengerView = UIView()
    private lazy var passengerImage = UIImageView()
    private lazy var dateLabel = UILabel()
    private lazy var timeLabel = UILabel()
    private lazy var changeRoleButton = UIButton()
    private lazy var backgroundView = UIView()
    private lazy var minY: CGFloat = 0

    init(output: PassengerTripViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 100
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        let swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        view.addGestureRecognizer(swipeDownGesture)
        
        output.viewIsReady()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        minY = view.frame.minY
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.layer.shadowColor = UIColor.clear.cgColor

    }
    
    private func setupView() {
        view.addSubview(backgroundView)
        setupCloseButton()
        setupPassengerView()
        setupDateTime()
        setupChangeRoleButton()
        setupBackgroundView()
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25)
        ])
        
        closeButton.addTarget(
            self,
            action: #selector(dismissController),
            for: .touchUpInside
        )
    }
    
    @objc private func dismissController() {
        output.closeButtonTapped()
    }
    
    private func setupPassengerView() {
        view.addSubview(passengerView)
        passengerView.addSubview(passengerImage)
        passengerView.translatesAutoresizingMaskIntoConstraints = false
        passengerImage.translatesAutoresizingMaskIntoConstraints = false
        
        passengerView.backgroundColor = .white
        passengerView.layer.borderWidth = 5
        passengerView.layer.borderColor = Colors.yellow.uiColor.cgColor
        passengerView.layer.cornerRadius = 50
        
        passengerImage.image = UIImage(systemName: "person")
        passengerImage.tintColor = .black
        
        NSLayoutConstraint.activate([
            passengerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            passengerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passengerView.heightAnchor.constraint(equalToConstant: 100),
            passengerView.widthAnchor.constraint(equalToConstant: 100),
            
            passengerImage.centerXAnchor.constraint(equalTo: passengerView.centerXAnchor),
            passengerImage.centerYAnchor.constraint(equalTo: passengerView.centerYAnchor),
            passengerImage.heightAnchor.constraint(equalToConstant: 50),
            passengerImage.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupDateTime() {
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.textColor = .black
        timeLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        timeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: passengerView.bottomAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private func setupChangeRoleButton() {
        changeRoleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changeRoleButton)
        changeRoleButton.setTitle("Сменить роль", for: .normal)
        changeRoleButton.setTitleColor(.black, for: .normal)
        changeRoleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        changeRoleButton.backgroundColor = Colors.yellow.uiColor
        changeRoleButton.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            changeRoleButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            changeRoleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeRoleButton.heightAnchor.constraint(equalToConstant: 45),
            changeRoleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            changeRoleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
        
        changeRoleButton.addTarget(
            self,
            action: #selector(changeRoleButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func changeRoleButtonTapped() {
        showAlert()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Смена роли", message: "Хотите сменить роль на Водитель?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Сменить", style: .default) { [weak self] (_) in
            self?.output.changeRoleButtonTapped()
            self?.output.closeButtonTapped()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in }
            
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 15),
            backgroundView.bottomAnchor.constraint(equalTo: changeRoleButton.bottomAnchor, constant: 30)
        ])
    }
    
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
       
        switch gesture.state {
        case .changed:
            view.frame.origin.y = max(translation.y + minY, minY)
        case .ended:
            if translation.y > 0 && translation.y > view.bounds.height / 3 {
                output.closeButtonTapped()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = self.minY
                }
            }
        default:
            break
        }
    }

}

extension PassengerTripViewController: PassengerTripViewInput {
    func setupTrip(tripModel: TripModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateLabel.text = "г. Москва, " + dateFormatter.string(from: tripModel.date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd MMMM HH:mm"
        timeLabel.text = timeFormatter.string(from: tripModel.date) + " - " + timeFormatter.string(from: tripModel.endTimestamp)
    }
}

extension PassengerTripViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
}
