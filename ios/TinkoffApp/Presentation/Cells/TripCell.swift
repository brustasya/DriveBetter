//
//  TripCell.swift
//  TinkoffApp
//
//  Created by Станислава on 13.03.2024.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class TripCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = TripModel
        
    private lazy var dateLabel = UILabel()
    private lazy var cityLabel = UILabel()
    private lazy var ratingLabel = UILabel()
    private lazy var passengerView = UIImageView()
    private lazy var ratingView = UIImageView()
    private lazy var leftStarView = UIImageView()
    private lazy var rightStarView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(ratingLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(passengerView)
        contentView.addSubview(ratingView)
        
        createStarView(starView: leftStarView)
        createStarView(starView: rightStarView)
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        leftStarView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          //  leftStarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftStarView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
         //   ratingLabel.leadingAnchor.constraint(equalTo: leftStarView.trailingAnchor, constant: 5),
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 35),
            
            rightStarView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 5),
            rightStarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
           // dateLabel.leadingAnchor.constraint(equalTo: rightStarView.trailingAnchor, constant: 25),
            
            cityLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
         //   cityLabel.leadingAnchor.constraint(equalTo: rightStarView.trailingAnchor, constant: 25),
            
            passengerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            passengerView.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            passengerView.heightAnchor.constraint(equalToConstant: 25),
            passengerView.widthAnchor.constraint(equalToConstant: 25),
            
            ratingView.heightAnchor.constraint(equalToConstant: 50),
            ratingView.widthAnchor.constraint(equalToConstant: 50),
           // ratingView.centerXAnchor.constraint(equalTo: ratingLabel.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            leftStarView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -5),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        ratingView.layer.cornerRadius = 25
        ratingView.backgroundColor = .clear
        ratingView.layer.borderWidth = 4
        ratingView.layer.borderColor = UIColor(rgb: "#fcdc2c")?.cgColor
        
        ratingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .center
        
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        dateLabel.textColor = .black
        
        cityLabel.font = UIFont.systemFont(ofSize: 15)
        cityLabel.textColor = .gray
        
        passengerView.image = UIImage(systemName: "person")
        passengerView.tintColor = .black
        passengerView.sizeToFit()
    }
    
    private func createStarView(starView: UIImageView) {
        contentView.addSubview(starView)
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.image = UIImage(systemName: "star.fill")
        starView.tintColor = UIColor(rgb: "#fcdc2c")
        
        NSLayoutConstraint.activate([
            starView.heightAnchor.constraint(equalToConstant: 25),
            starView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configure(with model: TripModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: model.date)
        cityLabel.text = model.city
        
        let rating = model.rating * 10 == Double(Int(model.rating)) * 10
        ? "\(Int(model.rating))"
        : "\(model.rating)"
        ratingLabel.text = rating
        
        leftStarView.isHidden = !model.isDriver
        rightStarView.isHidden = true//!model.isDriver
        ratingLabel.isHidden = !model.isDriver
        ratingView.isHidden = model.isDriver
        passengerView.isHidden = model.isDriver
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        dateLabel.text = nil
        ratingLabel.text = nil
    }
}
