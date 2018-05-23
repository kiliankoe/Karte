//
//  KarteTests.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation
import XCTest
@testable import Karte

import struct CoreLocation.CLLocationCoordinate2D

class KarteTests: XCTestCase {
    func testExistenceOfMapsApps() {
        var count = 0
        for _ in iterateEnum(App.self) {
            count += 1
        }
        XCTAssertEqual(Set(App.all).count, count, "Please ensure that `MapsApp.all` contains all cases")
    }

    func testQueryStrings() {
        let dummyCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let anonLoc = Location(coordinate: dummyCoordinate)
        let namedLoc = Location(name: "Named Location", coordinate: dummyCoordinate)
        let fullLoc = Location(name: "Full Location", address: "Location Address", coordinate: dummyCoordinate)

        XCTAssertEqual(App.googleMaps.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "comgooglemaps://maps?daddr=10.0,10.0&saddr=10.0,10.0")
        XCTAssertEqual(App.citymapper.queryString(origin: namedLoc, destination: fullLoc, mode: nil), "citymapper://directions?endaddress=Location%20Address&endcoord=10.0,10.0&endname=Full%20Location&startcoord=10.0,10.0&startname=Named%20Location")
        XCTAssertEqual(App.transit.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "transit://directions?from=10.0,10.0&to=10.0,10.0")
        XCTAssertEqual(App.lyft.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "lyft://ridetype?id=lyft&destination[latitude]=10.0&destination[longitude]=10.0&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(App.uber.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "uber://?action=setPickup&dropoff[latitude]=10.0&dropoff[longitude]=10.0&dropoff[nickname]=Named%20Location&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(App.navigon.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "navigon://coordinate/Named%20Location/10.0/10.0")
        XCTAssertEqual(App.waze.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "waze://?ll=10.0,10.0&navigate=yes")
        XCTAssertEqual(App.yandex.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "yandexnavi://build_route_on_map?lat_from=10.0&lat_to=10.0&lon_from=10.0&lon_to=10.0")
        XCTAssertEqual(App.moovit.queryString(origin: anonLoc, destination: namedLoc, mode: nil), "moovit://directions?dest_lat=10.0&dest_lon=10.0&dest_name=Named%20Location&origin_lat=10.0&origin_lon=10.0")
    }

    func testIsInstalled() {
        XCTAssertTrue(Karte.isInstalled(.appleMaps))
        XCTAssertFalse(Karte.isInstalled(.googleMaps))
    }
}

// hacky af, but thanks to http://stackoverflow.com/a/28341290/1843020
private func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var idx = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &idx) { $0.load(as: T.self) }
        if next.hashValue != idx { return nil }
        idx += 1
        return next
    }
}
