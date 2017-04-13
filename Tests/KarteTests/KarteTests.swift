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

class KarteTests: XCTestCase {
    func testExistenceOfMapsApps() {
        XCTAssertEqual(Karte.MapsApp.all, [.appleMaps, .googleMaps, .transit, .citymapper, .navigon])
    }
    
    static var allTests = [
        ("testExistenceOfMapsApps", testExistenceOfMapsApps),
    ]
}
