//
//  Location.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import CoreLocation

public struct Location {
    public let coordinate: CLLocationCoordinate2D
    public let name: String?
    public let address: String?

    public init(name: String? = nil, address: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }

    public init(name: String? = nil,
                address: String? = nil,
                latitude: CLLocationDegrees,
                longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(name: name, address: address, coordinate: coordinate)
    }
}
