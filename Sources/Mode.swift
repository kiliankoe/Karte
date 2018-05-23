//
//  Mode.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation
import MapKit

public enum Mode {
    case walking
    case bicycling
    case driving
    case transit
    case taxi

    /// Look up the transport mode identifier name for a given app.
    ///
    /// - Parameter app: navigation app
    /// - Returns: For Apple Maps a `[String:String]`, `String` for anything else. `nil` if irrelevant.
    func identifier(for app: App) -> Any? { // swiftlint:disable:this cyclomatic_complexity
        switch app {
        case .appleMaps:
            switch self {
            case .walking: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            case .driving: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            case .transit: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
            case .taxi: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] // it is supported, but there's no key for this...
            default: return nil
            }
        case .googleMaps:
            switch self {
            case .walking: return "walking"
            case .bicycling: return "bicycling"
            case .driving: return "driving"
            case .transit: return "transit"
            case .taxi: return "driving" // just like Apple Maps this actually is supported, but the key isn't specified in the docs... meh.
            }
        case .citymapper, .transit:
            return nil
        case .lyft, .uber:
            return nil
        case .navigon:
            return nil
        case .waze:
            return nil
        case .yandex:
            return nil
        case .moovit:
            return nil
        }
    }
}
