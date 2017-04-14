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
    case `default`
    case walking
    case driving
    case transit

    func appleMaps() throws -> [String: String] {
        switch self {
        case .default:
            return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
        case .walking:
            return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        case .driving:
            return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        case .transit:
            return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        }
    }
}
