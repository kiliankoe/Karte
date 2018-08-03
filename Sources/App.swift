//
//  MapsApp.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

public enum App: String {
    case appleMaps
    case googleMaps // https://developers.google.com/maps/documentation/ios/urlscheme
    case citymapper
    case transit // http://thetransitapp.com/developers
    case lyft
    case uber
    case navigon // http://www.navigon.com/portal/common/faq/files/NAVIGON_AppInteract.pdf
    case waze
    case dbnavigator
    case yandex
    case moovit

    static var all: [App] {
        return [
            .appleMaps,
            .googleMaps,
            .citymapper,
            .transit,
            .lyft,
            .uber,
            .navigon,
            .waze,
            .dbnavigator,
            .yandex,
            .moovit
        ]
    }

    var urlScheme: String {
        switch self {
        case .appleMaps: return "" // Uses System APIs, so this is just a placeholder
        case .googleMaps: return "comgooglemaps://"
        case .citymapper: return "citymapper://"
        case .transit: return "transit://"
        case .lyft: return "lyft://"
        case .uber: return "uber://"
        case .navigon: return "navigon://"
        case .waze: return "waze://"
        case .dbnavigator: return "dbnavigator://"
        case .yandex: return "yandexnavi://"
        case .moovit: return "moovit://"
        }
    }

    public var name: String {
        switch self {
        case .appleMaps: return "Apple Maps"
        case .googleMaps: return "Google Maps"
        case .citymapper: return "Citymapper"
        case .transit: return "Transit App"
        case .lyft: return "Lyft"
        case .uber: return "Uber"
        case .navigon: return "Navigon"
        case .waze: return "Waze"
        case .dbnavigator: return "DB Navigator"
        case .yandex: return "Yandex.Navi"
        case .moovit: return "Moovit"
        }
    }

    /// Validates if an app supports a mode. The given mode is optional and this defaults to `true`
    /// if the mode is `nil`.
    func supports(mode: Mode?) -> Bool {
        guard let mode = mode else {
            return true
        }

        switch self {
        case .appleMaps:
            return mode != .bicycling
        case .googleMaps:
            return true
        case .citymapper, .transit:
            return mode == .transit
        case .lyft, .uber:
            return mode == .taxi
        case .navigon:
            return mode == .driving || mode == .walking
        case .waze:
            return mode == .driving
        case .dbnavigator:
            return mode == .transit
        case .yandex:
            return true
        case .moovit:
            return true
        }
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    /// Build a query string for this app using the parameters. Returns nil if a mode is specified,
    /// but not supported by this app.
    func queryString(origin: LocationRepresentable?,
                     destination: LocationRepresentable,
                     mode: Mode?) -> String? {
        guard self.supports(mode: mode) else {
            // if a mode is present, validate if the app supports it, otherwise we don't care
            return nil
        }

        var parameters = [String: String]()

        switch self {
        case .appleMaps:
            // Apple Maps gets special handling, since it uses System APIs
            return nil
        case .googleMaps:
            parameters.set("saddr", origin?.coordString)
            parameters.set("daddr", destination.coordString)

            let modeIdentifier = mode?.identifier(for: self) as? String
            parameters.set("directionsmode", modeIdentifier)
            return "\(self.urlScheme)maps?\(parameters.urlParameters)"
        case .citymapper:
            parameters.set("endcoord", destination.coordString)
            parameters.set("startcoord", origin?.coordString)
            parameters.set("startname", origin?.name)
            parameters.set("startaddress", origin?.address)
            parameters.set("endname", destination.name)
            parameters.set("endaddress", destination.address)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .transit:
            parameters.set("from", origin?.coordString)
            parameters.set("to", destination.coordString)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        case .lyft:
            parameters.set("pickup[latitude]", origin?.latitude)
            parameters.set("pickup[longitude]", origin?.longitude)
            parameters.set("destination[latitude]", destination.latitude)
            parameters.set("destination[longitude]", destination.longitude)
            return "\(self.urlScheme)ridetype?id=lyft&\(parameters.urlParameters)"
        case .uber:
            parameters.set("action", "setPickup")
            if let origin = origin {
                parameters.set("pickup[latitude]", origin.latitude)
                parameters.set("pickup[longitude]", origin.longitude)
            } else {
                parameters.set("pickup", "my_location")
            }
            parameters.set("dropoff[latitude]", destination.latitude)
            parameters.set("dropoff[longitude]", destination.longitude)
            parameters.set("dropoff[nickname]", destination.name)
            return "\(self.urlScheme)?\(parameters.urlParameters)"
        case .navigon:
            // Docs are unclear about the name being omitted
            let name = destination.name ?? "Destination"
            // swiftlint:disable:next line_length
            return "\(self.urlScheme)coordinate/\(name.urlQuery ?? "")/\(destination.longitude)/\(destination.latitude)"
        case .waze:
            // swiftlint:disable:next line_length
            return "\(self.urlScheme)?ll=\(destination.latitude),\(destination.longitude)&navigate=yes"
        case .dbnavigator:
            if let origin = origin {
                parameters.set("SKOORD", 1)
                parameters.set("SNAME", origin.name)
                parameters.set("SY", Int(origin.latitude * 1_000_000))
                parameters.set("SX", Int(origin.longitude * 1_000_000))
            }
            parameters.set("ZKOORD", 1)
            parameters.set("ZNAME", destination.name)
            parameters.set("ZY", Int(destination.latitude * 1_000_000))
            parameters.set("ZX", Int(destination.longitude * 1_000_000))
            return "\(self.urlScheme)query?\(parameters.urlParameters)&start"
        case .yandex:
            parameters.set("lat_from", origin?.latitude)
            parameters.set("lon_from", origin?.longitude)
            parameters.set("lat_to", destination.latitude)
            parameters.set("lon_to", destination.longitude)
            return "\(self.urlScheme)build_route_on_map?\(parameters.urlParameters)"
        case .moovit:
            parameters.set("origin_lat", origin?.latitude)
            parameters.set("origin_lon", origin?.longitude)
            parameters.set("orig_name", origin?.name)
            parameters.set("dest_lat", destination.latitude)
            parameters.set("dest_lon", destination.longitude)
            parameters.set("dest_name", destination.name)
            return "\(self.urlScheme)directions?\(parameters.urlParameters)"
        }
    }
    // swiftlint:enable function_body_length
    // swiftlint:enable cyclomatic_complexity
}
