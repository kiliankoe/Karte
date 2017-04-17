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
    case lyft
    case uber
    case navigon // http://www.navigon.com/portal/common/faq/files/NAVIGON_AppInteract.pdf
    case waze
    case yandex
    case moovit

    static var all: [MapsApp] {
        return [.appleMaps, .googleMaps, .citymapper, .transit, .lyft, .uber, .navigon, .waze, .yandex, .moovit]
    }

    var urlScheme: String {
        switch self {
        case .appleMaps: return ""
        case .googleMaps: return "comgooglemaps://"
        case .citymapper: return "citymapper://"
        case .transit: return "transit://"
        case .lyft: return "lyft://"
        case .uber: return "uber://"
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
        case .lyft: return "Lyft"
        case .uber: return "Uber"
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
            parameters.set("saddr", fromStr)

            var toStr = to.coordString
            if let name = to.name {
                toStr += "+(\(name))"
            }
            parameters.set("daddr", toStr)

            parameters.set("directionsmode", try mode?.googleMaps())

            return "\(self.urlScheme)maps?\(parameters.urlParameters)"
        case .citymapper:
            _ = try mode?.anyOnlyTransit()
            parameters.set("endcoord", to.coordString)
            parameters.set("startcoord", from?.coordString)
            parameters.set("startname", from?.name)
            parameters.set("startaddress", from?.address)
            parameters.set("endname", to.name)
            parameters.set("endaddress", to.address)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .transit:
            _ = try mode?.anyOnlyTransit()
            parameters.set("from", from?.coordString)
            parameters.set("to", to.coordString)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .lyft:
            parameters.set("pickup[latitude]", from?.coordinate.latitude)
            parameters.set("pickup[longitude]", from?.coordinate.longitude)
            parameters.set("destination[latitude]", to.coordinate.latitude)
            parameters.set("destination[longitude]", to.coordinate.longitude)
            return "\(self.urlScheme)ridetype?id=lyft&\(parameters.urlParameters)"
        case .uber:
            parameters.set("action", "setPickup")
            if let from = from {
                parameters.set("pickup[latitude]", from.coordinate.latitude)
                parameters.set("pickup[longitude]", from.coordinate.longitude)
            } else {
                parameters.set("pickup", "my_location")
            }
            parameters.set("dropoff[latitude]", to.coordinate.latitude)
            parameters.set("dropoff[longitude]", to.coordinate.longitude)
            parameters.set("dropoff[nickname]", to.name)
            return "\(self.urlScheme)?\(parameters.urlParameters)"
        case .navigon:
            let name = to.name ?? "Destination" // Docs are unclear about the name being omitted
            return "\(self.urlScheme)coordinate/\(name.urlQuery ?? "")/\(to.coordinate.longitude)/\(to.coordinate.latitude)"
        case .waze:
            _ = try mode?.anyOnlyDriving()
            return "\(self.urlScheme)?ll=\(to.coordinate.latitude),\(to.coordinate.longitude)&navigate=yes"
        case .yandex:
            parameters.set("lat_from", from?.coordinate.latitude)
            parameters.set("lon_from", from?.coordinate.longitude)
            parameters.set("lat_to", to.coordinate.latitude)
            parameters.set("lon_to", to.coordinate.longitude)
            return "\(self.urlScheme)build_route_on_map?\(parameters.urlParameters)"
        case .moovit:
            parameters.set("origin_lat", from?.coordinate.latitude)
            parameters.set("origin_lon", from?.coordinate.longitude)
            parameters.set("orig_name", from?.name)
            parameters.set("dest_lat", to.coordinate.latitude)
            parameters.set("dest_lon", to.coordinate.longitude)
            parameters.set("dest_name", to.name)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        }
    }
}
