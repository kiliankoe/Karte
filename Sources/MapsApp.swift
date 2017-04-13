//
//  MapsApp.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation

public enum MapsApp {
    case appleMaps
    case googleMaps
    case transit // http://thetransitapp.com/developers
    case citymapper
    case navigon // http://www.navigon.com/portal/common/faq/files/NAVIGON_AppInteract.pdf

    static var all: [MapsApp] {
        return [.appleMaps, .googleMaps, .transit, .citymapper, .navigon]
    }

    var urlPrefix: String {
        switch self {
        case .googleMaps: return "comgooglemaps://"
        case .transit: return "transit://"
        case .citymapper: return "citymapper://"
        case .navigon: return "transit://"
        default: return ""
        }
    }

    var name: String {
        switch self {
        case .appleMaps: return "Apple Maps"
        case .googleMaps: return "Google Maps"
        case .transit: return "Transit App"
        case .citymapper: return "Citymapper"
        case .navigon: return "Navigon"
        }
    }

    func queryString(from: Location, to: Location) -> String {
        switch self {
        case .googleMaps: return "\(self.urlPrefix)?saddr=\(from.googleMapsString)&daddr=\(to.googleMapsString)"
        case .transit: return "\(self.urlPrefix)"
        default: return ""
        }
    }
}
