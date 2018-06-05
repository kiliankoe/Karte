//
//  LocationRepresentable.swift
//  Karte
//
//  Created by Kilian Költzsch on 17.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D
import class MapKit.MKMapItem
import class MapKit.MKPlacemark

public protocol KLocationRepresentable {
    var latitude: Double { get }
    var longitude: Double { get }
    /// - Note: This property is not supported by all navigation apps.
    var name: String? { get }
    var address: String? { get }
}

extension KLocationRepresentable {
    internal var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }

    internal var coordString: String {
        return "\(self.latitude),\(self.longitude)"
    }
}

extension CLLocationCoordinate2D: KLocationRepresentable {
    public var name: String? {
        return nil
    }

    public var address: String? {
        return nil
    }
}

extension KLocation: KLocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }

    public var longitude: Double {
        return self.coordinate.longitude
    }
}
