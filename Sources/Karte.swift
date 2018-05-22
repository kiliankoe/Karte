//
//  Karte.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import UIKit
import struct CoreLocation.CLLocationCoordinate2D
import MapKit

public enum Karte {
    /// Check if a navigation app is installed on the device.
    ///
    /// - Parameter app: a navigation app supported by Karte
    /// - Returns: `true` if the app is installed
    /// - Warning: For this to return `true` in any case, the necessary url schemes have to be included in your app's Info.plist.
    /// Please see Karte's README for additional details.
    public static func isInstalled(_ app: MapsApp) -> Bool {
        guard app != .appleMaps else { return true }
        guard let url = URL(string: app.urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Try to launch a navigation app with the given parameters
    ///
    /// - Parameters:
    ///   - app: the app to be launched
    ///   - origin: an optional origin location, defaults to the user's location if left empty in most apps
    ///   - destination: the location to route to
    ///   - mode: an optional mode of transport to use
    /// - Throws: `Karte.Error.unsupportedMode` if the chosen mode is not supported by the target app
    public static func launch(app: MapsApp,
                              origin: LocationRepresentable? = nil,
                              destination: LocationRepresentable,
                              mode: Mode? = nil) throws {
        guard self.isInstalled(app) else { throw Error.notInstalled }

        guard app != .appleMaps else {
            let modeVal: [String: String]
            if let mode = mode {
                modeVal = try mode.appleMaps()
            } else {
                // If mode (as in the launchOptions below) stays nil, Apple Maps won't go directly to the route, but show search boxes with prefilled content instead.
                modeVal = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
            }
            MKMapItem.openMaps(with: [origin, destination].compactMap { $0?.mapItem }, launchOptions: modeVal)
            return
        }

        guard let url = URL(string: try app.queryString(origin: origin, destination: destination, mode: mode)) else {
            // There's not really a lot the user could do about this, is there?
            // Maybe fail hard here and validate through tests?
            throw Error.malformedURL
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    /// Return a `UIAlertController` with all supported apps the device has installed to offer an option for which app to start.
    /// Use this instead of `Karte.presentPicker()` if you want to control the presentation of the alert view controller manually.
    ///
    /// - Parameters:
    ///   - origin: an optional origin location, defaults to the user's location if left empty in most apps
    ///   - destination: the location to route to
    ///   - mode: an optional mode of transport to use, results in only those apps being shown that support this mode
    ///   - title: an optional title for the `UIAlertController`
    ///   - message: an optional message for the `UIAlertController`
    ///   - cancel: label for the cancel button, defaults to "Cancel"
    ///   - style: the `UIAlertController`'s style, defaults to `.actionSheet`
    /// - Returns: the alert view controller
    public static func createPicker(origin: LocationRepresentable? = nil,
                                    destination: LocationRepresentable,
                                    mode: Mode? = nil,
                                    title: String? = nil,
                                    message: String? = nil,
                                    cancel: String = "Cancel",
                                    style: UIAlertControllerStyle = .actionSheet) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        MapsApp.all
            .filter(self.isInstalled)
            .filter { app in
                // Filtering all apps that throw on the chosen mode of transport. The implementation here should work, but isn't quite ideal, since the call is
                // invoked again below in the action handler of the UIAlertAction, where it could theoretically silently throw again and result in nothing happening.
                // But since the action handler isn't invoked here it's kinda not possible to check if it works at this point :/
                do {
                    _ = try app.queryString(origin: origin, destination: destination, mode: mode)
                } catch {
                    return false
                }
                return true
            }
            .map { app in
                return UIAlertAction(title: app.name, style: .default, handler: { _ in
                    try? self.launch(app: app, origin: origin, destination: destination, mode: mode)
                })
            }
            .forEach { action in
                alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))

        return alert
    }

    /// Present a `UIAlertController` with all supported apps the device has installed to offer an option for which app to start.
    ///
    /// - Parameters:
    ///   - origin: an optional origin location, defaults to the user's location if left empty in most apps
    ///   - destination: the location to route to
    ///   - mode: an optional mode of transport to use, results in only those apps being shown that support this mode
    ///   - viewcontroller: a `UIViewController` to present the `UIAlertController` on
    ///   - title: an optional title for the `UIAlertController`
    ///   - message: an optional message for the `UIAlertController`
    ///   - cancel: label for the cancel button, defaults to "Cancel"
    ///   - style: the `UIAlertController`'s style, defaults to `.actionSheet`
    public static func presentPicker(origin: LocationRepresentable? = nil,
                                     destination: LocationRepresentable,
                                     mode: Mode? = nil,
                                     presentOn viewcontroller: UIViewController,
                                     title: String? = nil,
                                     message: String? = nil,
                                     cancel: String = "Cancel",
                                     style: UIAlertControllerStyle = .actionSheet) {

        let alert = createPicker(origin: origin, destination: destination, mode: mode, title: title, message: message, cancel: cancel, style: style)

        OperationQueue.main.addOperation {
            viewcontroller.present(alert, animated: true, completion: nil)
        }
    }
}
