//
//  WeatherCell.swift
//  TinkoffApp
//
//  Created by Станислава on 15.03.2024.
//

import Foundation

import UIKit

class WeatherCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = WeatherModel
        
    private lazy var dateLabel = UILabel()
    private lazy var visibilityLabel = UILabel()
    private lazy var weatherImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(visibilityLabel)
        contentView.addSubview(weatherImageView)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: visibilityLabel.trailingAnchor, constant: 25),
            
            visibilityLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 25),
            visibilityLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
            visibilityLabel.widthAnchor.constraint(equalToConstant: 180),
            
            weatherImageView.heightAnchor.constraint(equalToConstant: 35),
            weatherImageView.widthAnchor.constraint(equalToConstant: 35),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textColor = .black
        
        visibilityLabel.font = UIFont.systemFont(ofSize: 16)
        visibilityLabel.textColor = .black
    }
    
    func configure(with model: ConfigurationModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: model.date)
        visibilityLabel.text = "Видимость \(Int(model.visibility)) м"
        weatherImageView.image = makeWeatherImage(for: model.weaterType)
        weatherImageView.tintColor = makeWeatherColor(for: model.weaterType)
    }
    
    private func makeWeatherImage(for type: WeatherType) -> UIImage? {
        switch type {
        case .sun:
            return UIImage(systemName: "sun.max.fill")
        case .rain:
            return UIImage(systemName: "cloud.rain.fill")
        case .heavyRain:
            return UIImage(systemName: "cloud.heavyrain.fill")
        case .hail:
            return UIImage(systemName: "cloud.hail.fill")
        case .snow:
            return UIImage(systemName: "cloud.snow.fill")
        case .sleet:
            return UIImage(systemName: "cloud.sleet.fill")
        case .bolt:
            return UIImage(systemName: "cloud.bolt.rain.fill")
        case .snowstorm:
            return UIImage(systemName: "wind.snow")
        case .fog:
            return UIImage(systemName: "cloud.fog.fill")
        }
    }
    
    private func makeWeatherColor(for type: WeatherType) -> UIColor? {
        switch type {
        case .sun:
            return UIColor(rgb: "#fcdc2c")
        case .rain:
            return UIColor(rgb: "#65A6D1")
        case .heavyRain:
            return UIColor(rgb: "#65A6D1")
        case .hail:
            return UIColor(rgb: "#65A6D1")
        case .snow:
            return UIColor(rgb: "#3E97D1")
        case .sleet:
            return UIColor(rgb: "#3E97D1")
        case .bolt:
            return UIColor(rgb: "#03426A")
        case .snowstorm:
            return UIColor(rgb: "#3E97D1")
        case .fog:
            return .systemGray3
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        visibilityLabel.text = nil
        dateLabel.text = nil
        weatherImageView.image = nil
    }
}

public enum WeatherType {
    case sun
    case rain
    case heavyRain
    case hail
    case snow
    case sleet
    case bolt
    case snowstorm
    case fog
}
