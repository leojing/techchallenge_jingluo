//
//  WeatherViewModel.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 26/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherViewModel {
    
    private let sydneyCoordinate = (-33.8650, 151.2094)
    
    let disposeBag = DisposeBag()

    var weather = Variable<Weather?>(nil)
    var hourlyData: Observable<[WeatherDetail]>? = nil
    var dailyData = Variable<[WeatherDetail]>([])
    var cityName = Variable<String>("Not found")
    var alertMessage = Variable<String>("Error")
    
    init(_ apiService: ApiService) {
        bindDailyData()
        bindHourlyData()

        fetchWeatherInfo(apiService)
        fetchCityName(LocationService(sydneyCoordinate))
    }
    
    fileprivate func fetchWeatherInfo(_ apiService: ApiService) {
        apiService.fetchWeatherInfo(ApiConfig.forecase(sydneyCoordinate))
            .subscribe(onNext: { status in
                switch status {
                case .success(let weather):
                    self.weather.value = weather

                case .fail(let error):
                    let errorMessage = error.errorDescription ?? "Faild to load weather data"
                    self.alertMessage.value = errorMessage
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    fileprivate func fetchCityName(_ locationService: LocationService) {
        locationService.fetchCity { city in
            self.cityName.value = city
        }
    }
    
    fileprivate func bindHourlyData() {
        hourlyData = weather.asObservable().map {
            if let weatherData = $0?.hourly?.data {
                    return  weatherData
                }
            return []
        }
    }
    
    fileprivate func bindDailyData() {
        weather.asObservable()
            .subscribe(onNext: { w in
                if let weatherData = w?.daily?.data {
                    self.dailyData.value = weatherData
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func dailyDataWithIndex(_ index: IndexPath) -> WeatherDetail? {
        return dailyData.value[index.row]
    }
}

