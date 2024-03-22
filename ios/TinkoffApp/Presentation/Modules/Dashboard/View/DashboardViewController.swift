//
//  DashboardViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import UIKit
import CoreMotion

class DashboardViewController: UIViewController {
    
    private var output: DashboardViewOutput
    
    private lazy var currentSpeedLabel = UILabel()
    private lazy var currentSpeedLabelKmH = UILabel()
    private lazy var maxSpeedLabel = UILabel()
    private lazy var maxSpeedLabelKmH = UILabel()
    private lazy var averageSpeedLabel = UILabel()
    private lazy var averageSpeedLabelKmH = UILabel()
  //  private lazy var adressLabel = UILabel()
    private lazy var averageLabel = UILabel()
    private lazy var maxLabel = UILabel()
    private lazy var currentLabel = UILabel()
    private lazy var startStopRideButton = UIButton()
    private lazy var currentSpeedBackgroundView = UIView()
    private lazy var maxSpeedBackgroundView = UIView()
    private lazy var averageSpeedBackgroundView = UIView()
    
    init(output: DashboardViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let motionManager = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6 //UIColor(rgb: "#fae253")
        setupView()
        output.viewIsReady()
        
//        setupSpeedTitleLabel(adressLabel)
//        NSLayoutConstraint.activate([
//            adressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            adressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
//        
//        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
//            if let activity {
//                if activity.automotive {
//                    self?.adressLabel.text = "automotive"
//                } else if activity.cycling {
//                    self?.adressLabel.text = "cycling"
//                } else if activity.running {
//                    self?.adressLabel.text = "running"
//                } else if activity.stationary {
//                    self?.adressLabel.text = "stationary"
//                } else if activity.walking {
//                    self?.adressLabel.text = "walking"
//                } else if activity.unknown {
//                    self?.adressLabel.text = "unknown"
//                }
//            }
//        })
    }
    
    private func setupView() {
        setupCurrentSpeedBackgroundView()
        setupAverageSpeedBackgroundView()
        setupMaxSpeedBackgroundView()
        setupCurrentSpeed()
        setupAverageSpeed()
        setupMaxSpeed()
        //setupStartStopRideButton()
    }
    
    private func setupTitle() {
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCurrentSpeed() {
        setupSpeedLabels(speedLabel: currentSpeedLabel, kmHLabel: currentSpeedLabelKmH)
        setupSpeedTitleLabel(currentLabel)
        currentLabel.text = "Текущая"
        currentSpeedLabel.font = .boldSystemFont(ofSize: 110)
        currentSpeedLabelKmH.font = .systemFont(ofSize: 38)
        currentLabel.font = .systemFont(ofSize: 32)
        
        NSLayoutConstraint.activate([
            currentSpeedLabel.centerXAnchor.constraint(equalTo: currentSpeedBackgroundView.centerXAnchor),
            currentSpeedLabel.centerYAnchor.constraint(equalTo: currentSpeedBackgroundView.centerYAnchor),
            currentLabel.centerXAnchor.constraint(equalTo: currentSpeedBackgroundView.centerXAnchor),
            currentSpeedLabelKmH.centerXAnchor.constraint(equalTo: currentSpeedBackgroundView.centerXAnchor),
            currentSpeedLabelKmH.topAnchor.constraint(equalTo: currentSpeedLabel.bottomAnchor, constant: 3),
            currentLabel.bottomAnchor.constraint(equalTo: currentSpeedLabel.topAnchor, constant: -3)
        ])
    }
    
    private func setupAverageSpeed() {
        setupSpeedLabels(speedLabel: averageSpeedLabel, kmHLabel: averageSpeedLabelKmH)
        setupSpeedTitleLabel(averageLabel)
        averageLabel.text = "Средняя"
        
        NSLayoutConstraint.activate([
            averageSpeedLabel.centerXAnchor.constraint(equalTo: averageSpeedBackgroundView.centerXAnchor),
            averageSpeedLabel.centerYAnchor.constraint(equalTo: averageSpeedBackgroundView.centerYAnchor),
            averageLabel.centerXAnchor.constraint(equalTo: averageSpeedBackgroundView.centerXAnchor),
            averageSpeedLabelKmH.centerXAnchor.constraint(equalTo: averageSpeedBackgroundView.centerXAnchor),
            averageSpeedLabelKmH.topAnchor.constraint(equalTo: averageSpeedLabel.bottomAnchor, constant: 3),
            averageLabel.bottomAnchor.constraint(equalTo: averageSpeedLabel.topAnchor, constant: -3)
        ])
    }
    
    private func setupMaxSpeed() {
        setupSpeedLabels(speedLabel: maxSpeedLabel, kmHLabel: maxSpeedLabelKmH)
        setupSpeedTitleLabel(maxLabel)
        maxLabel.text = "Макс."
        
        NSLayoutConstraint.activate([
            maxSpeedLabel.centerXAnchor.constraint(equalTo: maxSpeedBackgroundView.centerXAnchor),
            maxSpeedLabel.centerYAnchor.constraint(equalTo: maxSpeedBackgroundView.centerYAnchor),
            maxLabel.centerXAnchor.constraint(equalTo: maxSpeedBackgroundView.centerXAnchor),
            maxSpeedLabelKmH.centerXAnchor.constraint(equalTo: maxSpeedBackgroundView.centerXAnchor),
            maxSpeedLabelKmH.topAnchor.constraint(equalTo: maxSpeedLabel.bottomAnchor, constant: 3),
            maxLabel.bottomAnchor.constraint(equalTo: maxSpeedLabel.topAnchor, constant: -3)
        ])
    }
    
    private func setupSpeedLabels(speedLabel: UILabel, kmHLabel: UILabel) {
        view.addSubview(speedLabel)
        view.addSubview(kmHLabel)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        kmHLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.textColor = .black
        kmHLabel.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        speedLabel.font = .boldSystemFont(ofSize: 48)
        kmHLabel.font = .systemFont(ofSize: 28)
        speedLabel.text = "0"
        kmHLabel.text = "км/ч"
    }
    
    private func setupSpeedTitleLabel(_ label: UILabel) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        label.font = .systemFont(ofSize: 24)
    }
    
    private func setupCurrentSpeedBackgroundView() {
        view.addSubview(currentSpeedBackgroundView)
        currentSpeedBackgroundView.backgroundColor = .white
        currentSpeedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        currentSpeedBackgroundView.layer.cornerRadius = 155
        currentSpeedBackgroundView.layer.borderColor =  UIColor(rgb: "#fcdc2c")?.cgColor
        currentSpeedBackgroundView.layer.borderWidth = 10
        
        NSLayoutConstraint.activate([
            currentSpeedBackgroundView.heightAnchor.constraint(equalToConstant: 310),
            currentSpeedBackgroundView.widthAnchor.constraint(equalToConstant: 310),
            currentSpeedBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentSpeedBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                               constant: -130)
        ])
    }
    
    private func setupAverageSpeedBackgroundView() {
        view.addSubview(averageSpeedBackgroundView)
        averageSpeedBackgroundView.backgroundColor = .white //UIColor(rgb: "#fcdc2c") //UIColor(rgb: "#fae253")
        averageSpeedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        averageSpeedBackgroundView.layer.cornerRadius = 85
        //averageSpeedBackgroundView.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)// UIColor(rgb: "#fcdc2c")?.cgColor
        //averageSpeedBackgroundView.layer.borderWidth = 3
        
        NSLayoutConstraint.activate([
            averageSpeedBackgroundView.heightAnchor.constraint(equalToConstant: 170),
            averageSpeedBackgroundView.widthAnchor.constraint(equalToConstant: 170),
            averageSpeedBackgroundView.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 96),
            averageSpeedBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                                constant: 110)
        ])
        averageSpeedBackgroundView.isHidden = true
    }
    
    private func setupMaxSpeedBackgroundView() {
        view.addSubview(maxSpeedBackgroundView)
        maxSpeedBackgroundView.backgroundColor = .white//UIColor(rgb: "#fcdc2c")
        maxSpeedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        maxSpeedBackgroundView.layer.cornerRadius = 85
        //maxSpeedBackgroundView.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        //maxSpeedBackgroundView.layer.borderWidth = 3
        
        NSLayoutConstraint.activate([
            maxSpeedBackgroundView.heightAnchor.constraint(equalToConstant: 170),
            maxSpeedBackgroundView.widthAnchor.constraint(equalToConstant: 170),
            maxSpeedBackgroundView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -96),
            maxSpeedBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                                constant: 110)
        ])
        maxSpeedBackgroundView.isHidden = true
    }
    
    private func setupStartStopRideButton() {
        view.addSubview(startStopRideButton)
        startStopRideButton.translatesAutoresizingMaskIntoConstraints = false
        startStopRideButton.setTitle("Начать поездку", for: .normal)
        startStopRideButton.setTitleColor(.black, for: .normal)
        startStopRideButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        startStopRideButton.backgroundColor = UIColor(rgb: "#fcdc2c")
        startStopRideButton.layer.cornerRadius = 14
        
        NSLayoutConstraint.activate([
            startStopRideButton.heightAnchor.constraint(equalToConstant: 50),
            startStopRideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            startStopRideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            startStopRideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        
        startStopRideButton.addTarget(
            self,
            action: #selector(startStopRideButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func startStopRideButtonTapped() {
        
    }
}

extension DashboardViewController: DashboardViewInput {
    func updateCurrentSpeed(speed: Int) {
        currentSpeedLabel.text = "\(speed)"
    }
    
    func updateAverageSpeed(speed: Int) {
        averageSpeedLabel.text = "\(speed)"
    }
    
    func updateMaxSpeed(speed: Int) {
        maxSpeedLabel.text = "\(speed)"
    }
    
}
