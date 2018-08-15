//
//  LocationRepresentable.swift
//  Karte
//
//  Created by Kilian Költzsch on 17.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import CoreLocation
import MapKit

public protocol LocationRepresentable {
    var latitude: Double { get }
    var longitude: Double { get }
    /// - Note: This property is not supported by all navigation apps.
    var name: String? { get }
    var address: String? { get }
}

extension LocationRepresentable {
    internal var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude,
                                                                       longitude: self.longitude),
                                    addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }

    internal var coordString: String {
        return "\(self.latitude),\(self.longitude)"
    }
}

extension Location: LocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }

    public var longitude: Double {
        return self.coordinate.longitude
    }
}

// MARK: CoreLocation helpers

extension CLLocation: LocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }

    public var longitude: Double {
        return self.coordinate.longitude
    }

    public var name: String? {
        return nil
    }

    public var address: String? {
        return nil
    }
}

extension CLLocationCoordinate2D: LocationRepresentable {
    public var name: String? {
        return nil
    }

    public var address: String? {
        return nil
    }
}
