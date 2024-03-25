//
//  DangerousDrivingCell.swift
//  TinkoffApp
//
//  Created by Станислава on 15.03.2024.
//

import Foundation

import UIKit

class DangerousDrivingCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = DangerousDrivingModel
        
    private lazy var accelerationLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var accelerationView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(accelerationLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(accelerationView)
        
        
        accelerationView.translatesAutoresizingMaskIntoConstraints = false
        accelerationLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: accelerationView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 25),
            
            accelerationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            accelerationLabel.leadingAnchor.constraint(equalTo: accelerationView.trailingAnchor, constant: 25),
            
            addressLabel.topAnchor.constraint(equalTo: accelerationLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: accelerationView.trailingAnchor, constant: 25),
            addressLabel.widthAnchor.constraint(equalToConstant: 180),
            
            accelerationView.heightAnchor.constraint(equalToConstant: 30),
            accelerationView.widthAnchor.constraint(equalToConstant: 30),
            accelerationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accelerationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textColor = .black
        
        accelerationLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        accelerationLabel.textColor = .black
        
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.textColor = .gray
}
    
    func configure(with model: ConfigurationModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: model.date)
        addressLabel.text = model.address
        
        if model.acceleration > 0 {
            accelerationLabel.text = "Резкое ускорение"
            accelerationView.tintColor = Colors.red.uiColor
            accelerationView.image = UIImage(systemName: "chevron.forward.2")
        } else {
            accelerationLabel.text = "Резкое торможение"
            accelerationView.tintColor = Colors.lightBlue.uiColor
            accelerationView.image = UIImage(systemName: "chevron.backward.2")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = nil
        accelerationLabel.text = nil
        dateLabel.text = nil
    }
}
