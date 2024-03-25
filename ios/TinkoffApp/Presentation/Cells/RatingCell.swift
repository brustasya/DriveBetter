//
//  RatingCell.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation
import UIKit

class RatingCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = RatingModel
        
    private lazy var dateLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var speedLabel = UILabel()
    private lazy var modelView = UIImageView()
    
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
        contentView.addSubview(modelView)
                
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        modelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            speedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            speedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            speedLabel.widthAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: speedLabel.trailingAnchor, constant: 25),
            
            addressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: speedLabel.trailingAnchor, constant: 25),
            
            modelView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            modelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            modelView.heightAnchor.constraint(equalToConstant: 30),
            modelView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        speedLabel.textColor = Colors.yellow.uiColor
        speedLabel.textAlignment = .center
        speedLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textColor = .black
        
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.textColor = .gray
                
        modelView.image = UIImage(systemName: "medal.fill")
}
    
    func configure(with model: ConfigurationModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = model.name
        addressLabel.text = model.city
        speedLabel.text = "\(model.place)"
        
        switch model.place {
        case 1:
            modelView.tintColor = Colors.gold.uiColor
            modelView.isHidden = false
        case 2:
            modelView.tintColor = Colors.silver.uiColor
            modelView.isHidden = false
        case 3:
            modelView.tintColor = Colors.brown.uiColor
            modelView.isHidden = false
        default:
            modelView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = nil
        dateLabel.text = nil
        speedLabel.text = nil
        modelView.isHidden = true
    }
}
