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

    func appleMaps() throws -> [String: String] {
        switch self {
        case .walking: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        case .driving: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        case .transit: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        case .taxi: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] // it is supported, but there's no key for this...
        default: throw Error.unsupportedMode
        }
    }

    /// Look up transport mode parameter names for a given app.
    ///
    /// - Parameter app: navigation app
    /// - Returns: empty string if parameter is irrelevant, but supported
    /// - Throws: `unsupportedMode` if app doesn't support this mode
    func supported(by app: MapsApp) throws -> String {
        switch app {
        case .appleMaps:
            return "" // yay for special ❄️'s
        case .googleMaps:
            switch self {
            case .walking: return "walking"
            case .bicycling: return "bicycling"
            case .driving: return "driving"
            case .transit: return "transit"
            case .taxi: return "driving" // just like Apple Maps this actually is supported, but the key isn't specified in the docs... meh.
            }
        case .citymapper, .transit:
            if self != .transit {
                throw Error.unsupportedMode
            }
        case .lyft, .uber:
            if self != .taxi {
                throw Error.unsupportedMode
            }
        case .navigon:
            switch self {
            case .driving, .walking:
                return ""
            default:
                throw Error.unsupportedMode
            }
        case .waze:
            if self != .driving {
                throw Error.unsupportedMode
            }
        case .yandex:
            return ""
        case .moovit:
            return ""
        }

        return "" // wat? how is this necessary?
    }
}
