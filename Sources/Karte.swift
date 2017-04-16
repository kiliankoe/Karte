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
        guard app != .appleMaps else { return true }
        guard let url = URL(string: app.urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    public static func launch(app: MapsApp, forDirectionsFrom from: Location? = nil, to: Location, mode: Mode? = nil) throws {
        guard self.isInstalled(app) else { throw Error.notInstalled }

        guard app != .appleMaps else {
            MKMapItem.openMaps(with: [from, to].flatMap {$0}.map {$0.mapItem}, launchOptions: try mode?.appleMaps())
            return
        }

        guard let url = URL(string: try app.queryString(from: from, to: to, mode: mode)) else {
            throw Error.malformedURL // There's not really a lot the user could do about this, is there?
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    public static func presentPicker(forDirectionsFrom from: Location? = nil, to: Location, mode: Mode? = nil, on viewcontroller: UIViewController, title: String? = nil, message: String? = nil, cancel: String = "Cancel", style: UIAlertControllerStyle = .actionSheet) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        MapsApp.all
            .filter(self.isInstalled)
            .filter { app in
                // Filtering all apps that throw on the chosen mode of transport. The implementation here should work, but isn't quite ideal, since the call is
                // invoked again below in the action handler of the UIAlertAction, where it could theoretically silently throw again and result in nothing happening.
                // But since the action handler isn't invoked here it's kinda not possible to check if it works at this point :/
                do {
                    _ = try app.queryString(from: from, to: to, mode: mode)
                } catch {
                    return false
                }
                return true
            }
            .map { app in
                return UIAlertAction(title: app.name, style: .default, handler: { _ in
                    try? self.launch(app: app, forDirectionsFrom: from, to: to, mode: mode)
                })
            }
            .forEach { action in
                alert.addAction(action)
            }
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        OperationQueue.main.addOperation {
            viewcontroller.present(alert, animated: true, completion: nil)
        }
    }
}
