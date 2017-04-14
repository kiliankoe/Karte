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
    case waze
    case yandex

    static var all: Set<MapsApp> {
        return [.appleMaps, .googleMaps, .transit, .citymapper, .navigon, .waze, .yandex]
    }

    var urlScheme: String {
        switch self {
        case .appleMaps: return ""
        case .googleMaps: return "comgooglemaps://"
        case .transit: return "transit://"
        case .citymapper: return "citymapper://"
        case .navigon: return "navigon://"
        case .waze: return "waze://"
        case .yandex: return "yandexnavi://"
        }
    }

    var name: String {
        switch self {
        case .appleMaps: return "Apple Maps"
        case .googleMaps: return "Google Maps"
        case .transit: return "Transit App"
        case .citymapper: return "Citymapper"
        case .navigon: return "Navigon"
        case .waze: return "Waze"
        case .yandex: return "Yandex.Navi"
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func queryString(from: Location, to: Location) -> String {
        switch self {
        case .appleMaps:
            return ""
        case .googleMaps:
            return "\(self.urlScheme)maps?saddr=\(from.googleMapsString)&daddr=\(to.googleMapsString)"
        case .transit:
            return "\(self.urlScheme)directions?from=\(from.coordString)&to=\(to.coordString)"
        case .citymapper:
            var parameters = ["startcoord": from.coordString, "endcoord": to.coordString]
            if let startName = from.name {
                parameters["startname"] = startName
            }
            if let startAddress = from.address {
                parameters["startaddress"] = startAddress
            }
            if let endName = to.name {
                parameters["endname"] = endName
            }
            if let endAddress = to.address {
                parameters["endaddress"] = endAddress
            }
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .navigon:
            let name = to.name ?? "Destination" // Docs are unclear about the name being omitted
            return "\(self.urlScheme)coordinate/\(name.urlQuery ?? "")/\(to.coordinate.longitude)/\(to.coordinate.latitude)"
        case .waze:
            return "\(self.urlScheme)?ll=\(to.coordinate.latitude),\(to.coordinate.longitude)&navigate=yes"
        case .yandex:
            return "\(self.urlScheme)build_route_on_map?lat_to=\(to.coordinate.latitude)&lon_to=\(to.coordinate.longitude)&lat_from=\(from.coordinate.latitude)&lon_from=\(from.coordinate.longitude)"
        }
    }
}
