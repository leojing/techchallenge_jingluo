//
//  LocationService.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 27/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService {
    
    var location = CLLocation()
    
    init(_ lat: Double, _ long: Double) {
        location = CLLocation(latitude: lat, longitude: long)
    }
    
    func fetchCity(_ completion: @escaping (String) -> ()) {
        self.fetchCity(location, completion: completion)
    }
    
    func fetchCity(_ location: CLLocation, completion: @escaping (String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
            } else if let city = placemarks?.first?.locality {
                completion(city)
            }
        }
    }
}
