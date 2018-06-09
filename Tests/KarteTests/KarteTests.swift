//
//  KarteTests.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import XCTest
import MapKit
@testable import Karte

import struct CoreLocation.CLLocationCoordinate2D

class KarteTests: XCTestCase {

    var berlin: Location!
    var dresden: Location!

    var anonymousLocation: Location!
    var namedLocation: Location!
    var fullLocation: Location!

    override func setUp() {
        let berlinCoordinate = CLLocationCoordinate2D(latitude: 52.5205356, longitude: 13.4124354)
        self.berlin = Location(name: "Berlin", coordinate: berlinCoordinate)

        let dresdenCoordinate = CLLocationCoordinate2D(latitude: 51.0527491, longitude: 13.7383025)
        self.dresden = Location(name: "Dresden", coordinate: dresdenCoordinate)

        let dummyCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        self.anonymousLocation = Location(coordinate: dummyCoordinate)
        self.namedLocation = Location(name: "Named Location", coordinate: dummyCoordinate)
        self.fullLocation = Location(name: "Full Location",
                                     address: "Location Address",
                                     coordinate: dummyCoordinate)
    }

    // swiftlint:disable line_length
    func testQueryStrings() {
        XCTAssertEqual(App.googleMaps.queryString(origin: anonymousLocation,
                                                  destination: namedLocation,
                                                  mode: nil),
                       "comgooglemaps://maps?daddr=10.0,10.0&saddr=10.0,10.0")
        XCTAssertEqual(App.citymapper.queryString(origin: namedLocation,
                                                  destination: fullLocation,
                                                  mode: nil),
                       "citymapper://directions?endaddress=Location%20Address&endcoord=10.0,10.0&endname=Full%20Location&startcoord=10.0,10.0&startname=Named%20Location")
        XCTAssertEqual(App.transit.queryString(origin: anonymousLocation,
                                               destination: namedLocation,
                                               mode: nil),
                       "transit://directions?from=10.0,10.0&to=10.0,10.0")
        XCTAssertEqual(App.lyft.queryString(origin: anonymousLocation,
                                            destination: namedLocation,
                                            mode: nil),
                       "lyft://ridetype?id=lyft&destination[latitude]=10.0&destination[longitude]=10.0&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(App.uber.queryString(origin: anonymousLocation,
                                            destination: namedLocation,
                                            mode: nil),
                       "uber://?action=setPickup&dropoff[latitude]=10.0&dropoff[longitude]=10.0&dropoff[nickname]=Named%20Location&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(App.navigon.queryString(origin: anonymousLocation,
                                               destination: namedLocation,
                                               mode: nil),
                       "navigon://coordinate/Named%20Location/10.0/10.0")
        XCTAssertEqual(App.waze.queryString(origin: anonymousLocation,
                                            destination: namedLocation,
                                            mode: nil),
                       "waze://?ll=10.0,10.0&navigate=yes")
        XCTAssertEqual(App.yandex.queryString(origin: anonymousLocation,
                                              destination: namedLocation,
                                              mode: nil),
                       "yandexnavi://build_route_on_map?lat_from=10.0&lat_to=10.0&lon_from=10.0&lon_to=10.0")
        XCTAssertEqual(App.moovit.queryString(origin: anonymousLocation,
                                              destination: namedLocation,
                                              mode: nil),
                       "moovit://directions?dest_lat=10.0&dest_lon=10.0&dest_name=Named%20Location&origin_lat=10.0&origin_lon=10.0")
    }
    // swiftlint:enable line_length

    func testModeIdentifier() {
        XCTAssertEqual(Mode.walking.identifier(for: .appleMaps) as? [String: String],
                       [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        XCTAssertNil(Mode.bicycling.identifier(for: .appleMaps))

        XCTAssertEqual(Mode.driving.identifier(for: .googleMaps) as? String, "driving")

        XCTAssertNil(Mode.transit.identifier(for: .transit))
    }

    func testCreatePicker() {
        let alert = Karte.createPicker(destination: dresden)
        XCTAssertEqual(alert.actions.count, 2) // Apple Maps and Cancel
    }

    func testIsInstalled() {
        XCTAssertTrue(Karte.isInstalled(.appleMaps))
        XCTAssertFalse(Karte.isInstalled(.googleMaps))
    }

    // This basically only exists to verify the "throwyness" of the launch function.
    func testLaunch() {
        Karte.launch(app: .googleMaps, destination: dresden)
        Karte.launch(app: .googleMaps, origin: berlin, destination: dresden)

        do {
            try Karte.launch(app: .appleMaps, destination: dresden, mode: .bicycling)
            try Karte.launch(app: .appleMaps,
                             origin: berlin,
                             destination: dresden,
                             mode: .bicycling)
            XCTFail("Launch should throw on unsupported modes")
        } catch { }
    }
}
