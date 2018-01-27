//
//  techchallenge_jingluoTests.swift
//  techchallenge_jingluoTests
//
//  Created by JINGLUO on 26/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import ObjectMapper
@testable import techchallenge_jingluo

class techchallenge_jingluoTests: XCTestCase {
    
    fileprivate let disposeBag = DisposeBag()
    var viewModel: WeatherViewModel?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiClientSuccess() {
        MockApiClient().fetchWeatherInfo(ApiConfig.forecase(33.8650, 151.2094))
            .subscribe(onNext: { status in
                switch status {
                case .success(let weather):
                    XCTAssertEqual(weather.currently?.summary, "Drizzle")
                    XCTAssertEqual(weather.hourly?.summary, "Light rain tomorrow morning and windy starting tomorrow morning.")
                    
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func testApiClientEmpty() {
        let mockApiClient = MockApiClient()
        mockApiClient.jsonFileName = .mockDataEmpty
        mockApiClient.fetchWeatherInfo(ApiConfig.forecase(33.8650, 151.2094))
            .subscribe(onNext: { status in
                switch status {
                case .success(let weather):
                    XCTAssertNil(weather.currently?.summary)
                    XCTAssertEqual(weather.hourly?.summary, "Light rain tomorrow morning and windy starting tomorrow morning.")
                    
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

    }
}

class MockApiClient: ApiClient {
    
    enum JsonFileName: String {
        case mockData = "MockData"
        case mockDataEmpty = "MockData_empty"
    }
    
    var jsonFileName = JsonFileName.mockData
    
    override func fetchWeatherInfo(_ config: ApiConfig) -> Observable<RequestStatus> {
        return super.fetchWeatherInfo(config)
    }
    
    override func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        guard let json = JsonFileLoader.loadJson(fileName: jsonFileName.rawValue) as? [String: Any] else {
            completionHandler(nil, RequestError("Parse Weather information failed."))
            return
        }
        
        completionHandler(json, nil)
    }
}

class JsonFileLoader {
    
    class func loadJson(fileName: String) -> Any? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    return try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        } else {
            print("invalid url")
        }
        
        return nil
    }
}

