//
//  Location.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D
import class MapKit.MKMapItem
import class MapKit.MKPlacemark

public struct Location {
    public let coordinate: CLLocationCoordinate2D
    public let name: String?
    public let address: String?

    public init(name: String? = nil, address: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }

    public var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        return MKMapItem(placemark: placemark)
    }

    internal var coordString: String {
        return "\(self.coordinate.latitude),\(self.coordinate.longitude)"
    }
}
