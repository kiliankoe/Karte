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
    func queryString(from: Location?, to: Location) -> String {
        var parameters = [String: String]()

        switch self {
        case .appleMaps:
            return ""
        case .googleMaps:
            var fromStr = from?.coordString
            if let name = from?.name {
                fromStr?.append("+(\(name))")
            }
            parameters.maybeAdd(key: "saddr", value: fromStr)

            var toStr = to.coordString
            if let name = to.name {
                toStr += "+(\(name))"
            }
            parameters["daddr"] = toStr

            return "\(self.urlScheme)maps?\(parameters.urlParameters)"
        case .transit:
            parameters.maybeAdd(key: "from", value: from?.coordString)
            parameters["to"] = to.coordString
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .citymapper:
            parameters["endcoord"] = to.coordString
            parameters.maybeAdd(key: "startcoord", value: from?.coordString)
            parameters.maybeAdd(key: "startname", value: from?.name)
            parameters.maybeAdd(key: "startaddress", value: from?.address)
            parameters.maybeAdd(key: "endname", value: to.name)
            parameters.maybeAdd(key: "endaddress", value: to.address)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .navigon:
            let name = to.name ?? "Destination" // Docs are unclear about the name being omitted
            return "\(self.urlScheme)coordinate/\(name.urlQuery ?? "")/\(to.coordinate.longitude)/\(to.coordinate.latitude)"
        case .waze:
            return "\(self.urlScheme)?ll=\(to.coordinate.latitude),\(to.coordinate.longitude)&navigate=yes"
        case .yandex:
            parameters["lat_to"] = "\(to.coordinate.latitude)"
            parameters["lon_to"] = "\(to.coordinate.longitude)"
            parameters.maybeAdd(key: "lat_from", value: from?.coordinate.latitude)
            parameters.maybeAdd(key: "lon_from", value: from?.coordinate.longitude)
            return "\(self.urlScheme)build_route_on_map?\(parameters.urlParameters)"
        }
    }
}
