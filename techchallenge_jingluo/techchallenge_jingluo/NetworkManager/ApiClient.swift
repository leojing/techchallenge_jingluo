//
//  ApiClient.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 26/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

class ApiClient: ApiService {
    
    func fetchWeatherInfo(_ config: ApiConfig) -> Observable<RequestStatus> {
        let url = config.getFullURL()
        
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequest(url, completionHandler: { (json, error) in
                guard let json = json else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(error))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("Parse Weather information failed.")))
                    }
                    observable.onCompleted()
                    return
                }
                if let weather = Mapper<Weather>().map(JSON: json) {
                    observable.onNext(RequestStatus.success(weather))
                    observable.onCompleted()
                } else {
                    observable.onNext(RequestStatus.fail(RequestError("Parse Weather information failed.")))
                    observable.onCompleted()
                }
            })
            return Disposables.create()
            }.share()
    }
    
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        Alamofire.request(url)
            .responseJSON(queue: DispatchQueue.global(), options: .allowFragments) { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("Error: \(String(describing: response.result.error))")
                    completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                    return
                }
                
                completionHandler(json, nil)
        }
    }
}

