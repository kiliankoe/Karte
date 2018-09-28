//
//  Karte.swift
//  Karte
//
//  Created by Kilian Koeltzsch on 12.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import UIKit
import MapKit

public enum Karte {
    /// Check if a navigation app is installed on the device.
    ///
    /// - Parameter app: a navigation app supported by Karte
    /// - Returns: `true` if the app is installed
    /// - Warning: For this to return `true` in any case, the necessary url schemes have to be
    ///            included in your app's Info.plist.
    /// Please see Karte's README for additional details.
    public static func isInstalled(_ app: App) -> Bool {
        guard app != .appleMaps else { return true } // FIXME: See issue #3
        guard let url = URL(string: app.urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Try to launch a navigation app with the given parameters.
    ///
    /// - Parameters:
    ///   - app: the app to be launched
    ///   - origin: an optional origin location, defaults to the user's locatino if left empty in
    ///             most apps
    ///   - destination: the location to route to
    public static func launch(app: App,
                              origin: LocationRepresentable? = nil,
                              destination: LocationRepresentable) {
        try? _launch(app: app, origin: origin, destination: destination, mode: nil)
    }

    /// Try to launch a navigation app with the given parameters
    ///
    /// - Parameters:
    ///   - app: the app to be launched
    ///   - origin: an optional origin location, defaults to the user's location if left empty in
    ///             most apps
    ///   - destination: the location to route to
    ///   - mode: mode of transport to use
    /// - Throws: `KarteError.unsupportedMode` if the chosen mode is not supported by the target
    ///           app
    public static func launch(app: App,
                              origin: LocationRepresentable? = nil,
                              destination: LocationRepresentable,
                              mode: Mode) throws {
        try _launch(app: app, origin: origin, destination: destination, mode: mode)
    }

    private static func _launch(app: App,
                                origin: LocationRepresentable?,
                                destination: LocationRepresentable,
                                mode: Mode?) throws {
        guard app != .appleMaps else {
            guard app.supports(mode: mode) else { throw KarteError.unsupportedMode }
            let mapItems = [origin, destination].compactMap { $0?.mapItem }
            // Fallback for the default driving mode on versions before iOS 10
            let defaultDirectionMode: String
            if #available(iOS 10.0, *) {
                defaultDirectionMode = MKLaunchOptionsDirectionsModeDefault
            } else {
                defaultDirectionMode = MKLaunchOptionsDirectionsModeDriving
            }
            // If mode (as in the launchOptions below) stays nil, Apple Maps won't go directly to
            // the route, but show search boxes with prefilled content instead.
            let modeKey = (mode?.identifier(for: .appleMaps) as? [String: String])
                ?? [MKLaunchOptionsDirectionsModeKey: defaultDirectionMode]
            MKMapItem.openMaps(with: mapItems, launchOptions: modeKey)
            return
        }

        guard let queryString = app.queryString(origin: origin,
                                                destination: destination,
                                                mode: mode)
        else {
            throw KarteError.unsupportedMode
        }

        guard let url = URL(string: queryString) else {
            assertionFailure("Failed to create URL for \(app)")
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    /// Return a `UIAlertController` with all supported apps the device has installed to offer an
    /// option for which app to start.
    /// Use this instead of `Karte.presentPicker()` if you want to control the presentation of the
    /// alert view controller manually.
    ///
    /// - Parameters:
    ///   - origin: an optional origin location, defaults to the user's location if left empty in
    ///             most apps
    ///   - destination: the location to route to
    ///   - mode: an optional mode of transport to use, results in only those apps being shown that
    ///           support this mode
    ///   - title: an optional title for the `UIAlertController`
    ///   - message: an optional message for the `UIAlertController`
    ///   - cancel: label for the cancel button, defaults to "Cancel"
    ///   - style: the `UIAlertController`'s style, defaults to `.actionSheet`
    ///   - completion: handler called with the selected after launching it.
    /// - Returns: the alert view controller
    public static func createPicker(origin: LocationRepresentable? = nil,
                                    destination: LocationRepresentable,
                                    mode: Mode? = nil,
                                    title: String? = nil,
                                    message: String? = nil,
                                    cancel: String = "Cancel",
                                    style: UIAlertController.Style = .actionSheet,
                                    completion: ((App) -> Void)? = nil)
        -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        App.all
            .filter(self.isInstalled)
            .filter { $0.supports(mode: mode) } // defaults to true if mode is nil
            .map { app in
                return UIAlertAction(title: app.name, style: .default, handler: { _ in
                    try? self._launch(app: app,
                                      origin: origin,
                                      destination: destination,
                                      mode: mode)
                    completion?(app)
                })
            }
            .forEach { alert.addAction($0) }

        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))

        return alert
    }

    /// Present a `UIAlertController` with all supported apps the device has installed to offer an
    /// option for which app to start.
    ///
    /// - Parameters:
    ///   - origin: an optional origin location, defaults to the user's location if left empty in
    ///             most apps
    ///   - destination: the location to route to
    ///   - mode: an optional mode of transport to use, results in only those apps being shown that
    ///           support this mode
    ///   - viewcontroller: a `UIViewController` to present the `UIAlertController` on
    ///   - title: an optional title for the `UIAlertController`
    ///   - message: an optional message for the `UIAlertController`
    ///   - cancel: label for the cancel button, defaults to "Cancel"
    ///   - style: the `UIAlertController`'s style, defaults to `.actionSheet`
    ///   - completion: handler called with the selected app after launching it.
    public static func presentPicker(origin: LocationRepresentable? = nil,
                                     destination: LocationRepresentable,
                                     mode: Mode? = nil,
                                     presentOn viewcontroller: UIViewController,
                                     title: String? = nil,
                                     message: String? = nil,
                                     cancel: String = "Cancel",
                                     style: UIAlertController.Style = .actionSheet,
                                     completion: ((App) -> Void)? = nil) {

        let alert = createPicker(origin: origin,
                                 destination: destination,
                                 mode: mode,
                                 title: title,
                                 message: message,
                                 cancel: cancel,
                                 style: style,
                                 completion: completion)

        OperationQueue.main.addOperation {
            viewcontroller.present(alert, animated: true, completion: nil)
        }
    }
}
