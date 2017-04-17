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
    case googleMaps // https://developers.google.com/maps/documentation/ios/urlscheme
    case citymapper
    case transit // http://thetransitapp.com/developers
    case navigon // http://www.navigon.com/portal/common/faq/files/NAVIGON_AppInteract.pdf
    case waze
    case yandex
    case moovit

    static var all: [MapsApp] {
        return [.appleMaps, .googleMaps, .citymapper, .transit, .navigon, .waze, .yandex, .moovit]
    }

    var urlScheme: String {
        switch self {
        case .appleMaps: return ""
        case .googleMaps: return "comgooglemaps://"
        case .citymapper: return "citymapper://"
        case .transit: return "transit://"
        case .navigon: return "navigon://"
        case .waze: return "waze://"
        case .yandex: return "yandexnavi://"
        case .moovit: return "moovit://"
        }
    }

    var name: String {
        switch self {
        case .appleMaps: return "Apple Maps"
        case .googleMaps: return "Google Maps"
        case .citymapper: return "Citymapper"
        case .transit: return "Transit App"
        case .navigon: return "Navigon"
        case .waze: return "Waze"
        case .yandex: return "Yandex.Navi"
        case .moovit: return "Moovit"
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func queryString(from: Location?, to: Location, mode: Mode?) throws -> String {
        var parameters = [String: String]()

        switch self {
        case .appleMaps:
            // This just needs to validate that the mode is supported by Apple Maps.
            _ = try mode?.appleMaps()
            return ""
        case .googleMaps:
            var fromStr = from?.coordString
            if let name = from?.name {
                fromStr?.append("+(\(name))")
            }
            parameters.maybeSet(key: "saddr", value: fromStr)

            var toStr = to.coordString
            if let name = to.name {
                toStr += "+(\(name))"
            }
            parameters["daddr"] = toStr

            parameters.maybeSet(key: "directionsmode", value: try mode?.googleMaps())

            return "\(self.urlScheme)maps?\(parameters.urlParameters)"
        case .citymapper:
            _ = try mode?.anyOnlyTransit()
            parameters["endcoord"] = to.coordString
            parameters.maybeSet(key: "startcoord", value: from?.coordString)
            parameters.maybeSet(key: "startname", value: from?.name)
            parameters.maybeSet(key: "startaddress", value: from?.address)
            parameters.maybeSet(key: "endname", value: to.name)
            parameters.maybeSet(key: "endaddress", value: to.address)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .transit:
            _ = try mode?.anyOnlyTransit()
            parameters.maybeSet(key: "from", value: from?.coordString)
            parameters["to"] = to.coordString
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .navigon:
            let name = to.name ?? "Destination" // Docs are unclear about the name being omitted
            return "\(self.urlScheme)coordinate/\(name.urlQuery ?? "")/\(to.coordinate.longitude)/\(to.coordinate.latitude)"
        case .waze:
            _ = try mode?.anyOnlyDriving()
            return "\(self.urlScheme)?ll=\(to.coordinate.latitude),\(to.coordinate.longitude)&navigate=yes"
        case .yandex:
            parameters["lat_to"] = "\(to.coordinate.latitude)"
            parameters["lon_to"] = "\(to.coordinate.longitude)"
            parameters.maybeSet(key: "lat_from", value: from?.coordinate.latitude)
            parameters.maybeSet(key: "lon_from", value: from?.coordinate.longitude)
            return "\(self.urlScheme)build_route_on_map?\(parameters.urlParameters)"
        case .moovit:
            parameters["dest_lat"] = "\(to.coordinate.latitude)"
            parameters["dest_lon"] = "\(to.coordinate.longitude)"
            parameters.maybeSet(key: "dest_name", value: to.name)
            parameters.maybeSet(key: "origin_lat", value: from?.coordinate.latitude)
            parameters.maybeSet(key: "origin_lon", value: from?.coordinate.longitude)
            parameters.maybeSet(key: "orig_name", value: from?.name)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        }
    }
}
