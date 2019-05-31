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

    var berlin: Karte.Location!
    var dresden: Karte.Location!

    var anonymousLocation: Karte.Location!
    var namedLocation: Karte.Location!
    var fullLocation: Karte.Location!

    override func setUp() {
        let berlinCoordinate = CLLocationCoordinate2D(latitude: 52.5205356, longitude: 13.4124354)
        self.berlin = Karte.Location(name: "Berlin", coordinate: berlinCoordinate)

        let dresdenCoordinate = CLLocationCoordinate2D(latitude: 51.0527491, longitude: 13.7383025)
        self.dresden = Karte.Location(name: "Dresden", coordinate: dresdenCoordinate)

        let dummyCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        self.anonymousLocation = Karte.Location(coordinate: dummyCoordinate)
        self.namedLocation = Karte.Location(name: "Named Location", coordinate: dummyCoordinate)
        self.fullLocation = Karte.Location(name: "Full Location",
                                           address: "Location Address",
                                           coordinate: dummyCoordinate)
    }

    // swiftlint:disable line_length
    func testQueryStrings() {
        XCTAssertEqual(Karte.App.googleMaps.queryString(origin: anonymousLocation,
                                                        destination: namedLocation,
                                                        mode: nil),
                       "comgooglemaps://maps?daddr=10.0,10.0&saddr=10.0,10.0")
        XCTAssertEqual(Karte.App.citymapper.queryString(origin: namedLocation,
                                                        destination: fullLocation,
                                                        mode: nil),
                       "citymapper://directions?endaddress=Location%20Address&endcoord=10.0,10.0&endname=Full%20Location&startcoord=10.0,10.0&startname=Named%20Location")
        XCTAssertEqual(Karte.App.transit.queryString(origin: anonymousLocation,
                                                     destination: namedLocation,
                                                     mode: nil),
                       "transit://directions?from=10.0,10.0&to=10.0,10.0")
        XCTAssertEqual(Karte.App.lyft.queryString(origin: anonymousLocation,
                                                  destination: namedLocation,
                                                  mode: nil),
                       "lyft://ridetype?id=lyft&destination[latitude]=10.0&destination[longitude]=10.0&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(Karte.App.uber.queryString(origin: anonymousLocation,
                                                  destination: namedLocation,
                                                  mode: nil),
                       "uber://?action=setPickup&dropoff[latitude]=10.0&dropoff[longitude]=10.0&dropoff[nickname]=Named%20Location&pickup[latitude]=10.0&pickup[longitude]=10.0")
        XCTAssertEqual(Karte.App.navigon.queryString(origin: anonymousLocation,
                                                     destination: namedLocation,
                                                     mode: nil),
                       "navigon://coordinate/Named%20Location/10.0/10.0")
        XCTAssertEqual(Karte.App.waze.queryString(origin: anonymousLocation,
                                                  destination: namedLocation,
                                                  mode: nil),
                       "waze://?ll=10.0,10.0&navigate=yes")
        XCTAssertEqual(Karte.App.dbnavigator.queryString(origin: anonymousLocation,
                                                         destination: namedLocation,
                                                         mode: nil),
                       "dbnavigator://query?SKOORD=1&SX=10000000&SY=10000000&ZKOORD=1&ZNAME=Named%20Location&ZX=10000000&ZY=10000000&start")
        XCTAssertEqual(Karte.App.yandex.queryString(origin: anonymousLocation,
                                                    destination: namedLocation,
                                                    mode: nil),
                       "yandexnavi://build_route_on_map?lat_from=10.0&lat_to=10.0&lon_from=10.0&lon_to=10.0")
        XCTAssertEqual(Karte.App.moovit.queryString(origin: anonymousLocation,
                                                    destination: namedLocation,
                                                    mode: nil),
                       "moovit://directions?dest_lat=10.0&dest_lon=10.0&dest_name=Named%20Location&origin_lat=10.0&origin_lon=10.0")
    }
    // swiftlint:enable line_length

    func testModeIdentifier() {
        XCTAssertEqual(Karte.Mode.walking.identifier(for: .appleMaps) as? [String: String],
                       [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        XCTAssertNil(Karte.Mode.bicycling.identifier(for: .appleMaps))

        XCTAssertEqual(Karte.Mode.driving.identifier(for: .googleMaps) as? String, "driving")

        XCTAssertNil(Karte.Mode.transit.identifier(for: .transit))
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
