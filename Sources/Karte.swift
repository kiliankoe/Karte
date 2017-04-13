//
//  Karte.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import UIKit
import struct CoreLocation.CLLocationCoordinate2D

public enum Karte {
    public enum MapsApp {
        case appleMaps, googleMaps, transit, citymapper, navigon

        var urlPrefix: String {
            switch self {
            case .appleMaps: return ""
            case .googleMaps: return "googlemaps://"
            case .transit: return "transit://"
            case .citymapper: return "citymapper://"
            case .navigon: return "transit://"
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

        static var all: [MapsApp] {
            return [.appleMaps, .googleMaps, .transit, .citymapper, .navigon]
        }
    }

    public static func isInstalled(_ app: MapsApp) -> Bool {
        guard app != .appleMaps else {
            return true
        }

        let url = URL(string: app.urlPrefix)!
        return UIApplication.shared.canOpenURL(url)
    }

    public static func launch(app: MapsApp, forDirectionsFrom from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {

    }

    public static func presentPicker(forDirectionsFrom from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, on viewcontroller: UIViewController, title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .actionSheet) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        MapsApp.all
            .filter(self.isInstalled)
            .map { app in
                return UIAlertAction(title: app.name, style: .default, handler: { _ in
                    self.launch(app: app, forDirectionsFrom: from, to: to)
                })
            }
            .forEach { action in
                alert.addAction(action)
            }
        OperationQueue.main.addOperation {
            viewcontroller.present(alert, animated: true, completion: nil)
        }
    }
}
