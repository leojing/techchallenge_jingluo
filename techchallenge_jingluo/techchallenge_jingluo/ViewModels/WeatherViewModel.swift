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
    
    let disposeBag = DisposeBag()

    var weather = Variable<Weather?>(nil)

    init(_ apiService: ApiService) {
        fetchWeatherInfo(apiService)
    }
    
    fileprivate func fetchWeatherInfo(_ apiService: ApiService) {
        apiService.fetchWeatherInfo(ApiConfig.forecase(33.8650, 151.2094))
            .subscribe(onNext: { status in
                switch status {
                case .success(let weather):
                    self.weather.value = weather

                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

