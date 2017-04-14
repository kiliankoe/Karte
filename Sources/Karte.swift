//
//  Karte.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import UIKit
import struct CoreLocation.CLLocationCoordinate2D
import class MapKit.MKMapItem

public enum Karte {
    public static func isInstalled(_ app: MapsApp) -> Bool {
        guard app != .appleMaps else {
            return true
        }

        let url = URL(string: app.urlPrefix)!
        return UIApplication.shared.canOpenURL(url)
    }

    public static func launch(app: MapsApp, forDirectionsFrom from: Location, to: Location, mode: Mode = .default) throws {
        guard self.isInstalled(app) else {
            throw Error.notInstalled
        }

        guard app != .appleMaps else {
            MKMapItem.openMaps(with: [from, to].map {$0.mapItem}, launchOptions: try mode.appleMaps())
            return
        }

        guard let url = URL(string: app.queryString(from: from, to: to)) else {
            throw Error.malformedURL // There's not really a lot the user can do about this, is there?
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    public static func presentPicker(forDirectionsFrom from: Location, to: Location, mode: Mode = .default, on viewcontroller: UIViewController, title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .actionSheet) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        MapsApp.all
            .filter(self.isInstalled)
            .map { app in
                return UIAlertAction(title: app.name, style: .default, handler: { _ in
                    try? self.launch(app: app, forDirectionsFrom: from, to: to, mode: mode)
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
