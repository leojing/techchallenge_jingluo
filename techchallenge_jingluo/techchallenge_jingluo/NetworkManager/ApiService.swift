//
//  ApiService.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 26/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RequestStatus {
    case success(Weather)
    case fail(RequestError)
}

struct RequestError : LocalizedError {
    
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var mMsg : String
    
    init(_ description: String) {
        mMsg = description
    }
}

enum ApiConfig  {
    
    fileprivate static let baseURLString = "https://api.darksky.net"
    fileprivate static let API_KEY = "2e3062644e2634fe02f4922be6e1ce68"
    
    case forecase((Double, Double))
    
    var path: String {
        switch self {
        case .forecase(let location):
            return "/forecast/\(ApiConfig.API_KEY)/\(location.0),\(location.1)"
        }
    }

    func getFullURL() -> URL {
        switch self {
        case .forecase( _, _):
            if let url = URL(string: ApiConfig.baseURLString + self.path) {
                return url
            }
            return URL(string: ApiConfig.baseURLString)!
        }
    }
}

protocol ApiService {
    func fetchWeatherInfo(_ config: ApiConfig) -> Observable<RequestStatus>
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void))
}

