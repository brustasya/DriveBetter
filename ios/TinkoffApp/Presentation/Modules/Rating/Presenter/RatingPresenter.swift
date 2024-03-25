//
//  RatingPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

final class RatingPresenter {
    weak var viewInput: RatingViewInput?
    weak var moduleOutput: RatingModuleOutput?
    
    private let telemetryService: TelemetryServiceProtocol
    
    private let rating = [
        RatingModel(place: 1, name: "Станислава Бобрускина", city: "Москва"),
        RatingModel(place: 2, name: "Наталья", city: "Москва"),
        RatingModel(place: 3, name: "Всеволод Сергеев", city: "Москва"),
        RatingModel(place: 4, name: "Максим Крюков", city: "Хабаровск"),
        RatingModel(place: 5, name: "Дмитрий", city: "Сочи"),
        RatingModel(place: 6, name: "Константин Зубов", city: "Москва"),
        RatingModel(place: 7, name: "Наталья", city: "Москва"),
        RatingModel(place: 8, name: "Евгений", city: "Мурманск"),
        RatingModel(place: 9, name: "Григорий Сухов", city: "Рязань"),
        RatingModel(place: 10, name: "Татьяна Ларина", city: "Москва"),
        RatingModel(place: 11, name: "Станислава", city: "Москва"),
        RatingModel(place: 12, name: "Сергей", city: "Иркутск"),
        RatingModel(place: 13, name: "Ольга", city: "Москва"),
        RatingModel(place: 14, name: "Мария Кузнецова", city: "Москва"),
        RatingModel(place: 15, name: "Дмитрий Чумиков", city: "Воронеж")
    ]

    init(
        moduleOutput: RatingModuleOutput,
        telemetryService: TelemetryServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
        self.telemetryService = telemetryService
    }
}

extension RatingPresenter: RatingViewOutput {
    func viewIsReady() {
        viewInput?.applySnapshot(with: rating)
    }
    
    func closeRating() {
        moduleOutput?.moduleWantsToCloseRating()
    }
    
    
}

