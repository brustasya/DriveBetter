//
//  SpeedCell.swift
//  TinkoffApp
//
//  Created by Станислава on 14.03.2024.
//

import Foundation

import UIKit

class SpeedCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = SpeedModel
        
    private lazy var dateLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var speedLabel = UILabel()
    private lazy var ratingView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(speedLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(ratingView)
        
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            speedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            speedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            speedLabel.widthAnchor.constraint(equalToConstant: 35),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 25),
            
            addressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 25),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            ratingView.heightAnchor.constraint(equalToConstant: 50),
            ratingView.widthAnchor.constraint(equalToConstant: 50),
            ratingView.centerXAnchor.constraint(equalTo: speedLabel.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        ratingView.layer.cornerRadius = 25
        ratingView.backgroundColor = .clear
        ratingView.layer.borderWidth = 4
        ratingView.layer.borderColor = Colors.red.uiColor.cgColor
        
        speedLabel.textColor = .black
        speedLabel.textAlignment = .center
        speedLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        speedLabel.sizeToFit()
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textColor = .black
        
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.textColor = .gray
}
    
    func configure(with model: ConfigurationModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: model.timestamp)
        addressLabel.text = model.address
        
        speedLabel.text = "\(model.speed)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = nil
        dateLabel.text = nil
        speedLabel.text = nil
    }
}
