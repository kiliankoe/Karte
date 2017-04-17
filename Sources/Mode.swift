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

    func appleMaps() throws -> [String: String] {
        switch self {
        case .walking: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        case .driving: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        case .transit: return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        default: throw Error.unsupportedMode
        }
    }

    func googleMaps() throws -> String {
        switch self {
        case .walking: return "walking"
        case .bicycling: return "bicycling"
        case .driving: return "driving"
        case .transit: return "transit"
        default: throw Error.unsupportedMode
        }
    }

    // MARK: -

    func anyOnlyTransit() throws {
        if self != .transit {
            throw Error.unsupportedMode
        }
    }

    func anyOnlyDriving() throws {
        if self != .driving {
            throw Error.unsupportedMode
        }
    }
}
