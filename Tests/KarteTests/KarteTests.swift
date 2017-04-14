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
let dummyCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)

class KarteTests: XCTestCase {
    func testExistenceOfMapsApps() {
        XCTAssertEqual(MapsApp.all.count, 5)
    }

    func testQueryStrings() {
        let anonLoc = Location(coordinate: dummyCoordinate)
        let namedLoc = Location(name: "Named Location", coordinate: dummyCoordinate)
        let fullLoc = Location(name: "Full Location", address: "Location Address", coordinate: dummyCoordinate)

        XCTAssertEqual(MapsApp.googleMaps.queryString(from: anonLoc, to: namedLoc), "comgooglemaps://maps?saddr=10.0,10.0&daddr=10.0,10.0+(Named%20Location)")
        XCTAssertEqual(MapsApp.transit.queryString(from: anonLoc, to: namedLoc), "transit://directions?from=10.0,10.0&to=10.0,10.0")
        XCTAssertEqual(MapsApp.citymapper.queryString(from: namedLoc, to: fullLoc), "citymapper://directions?endaddress=Location%20Address&endcoord=10.0,10.0&endname=Full%20Location&startcoord=10.0,10.0&startname=Named%20Location")
        XCTAssertEqual(MapsApp.navigon.queryString(from: anonLoc, to: namedLoc), "navigon://coordinate/Named%20Location/10.0/10.0")
        XCTAssertEqual(MapsApp.waze.queryString(from: anonLoc, to: namedLoc), "waze://?ll=10.0,10.0&navigate=yes")
        XCTAssertEqual(MapsApp.yandex.queryString(from: anonLoc, to: namedLoc), "yandexnavi://build_route_on_map?lat_to=10.0&lon_to=10.0&lat_from=10.0&lon_from=10.0")
    }

    func testIsInstalled() {
        XCTAssertTrue(Karte.isInstalled(.appleMaps))
        XCTAssertFalse(Karte.isInstalled(.googleMaps))
    }
}
