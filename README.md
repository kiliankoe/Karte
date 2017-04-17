# 🗺 Karte

Small library for opening a location or route in other popular iOS map apps.

Currently supported are Apple Maps, Google Maps, Citymapper, Transit, Lyft, Uber, Navigon, Waze, Yandex.Navi and Moovit.

## Quick Start

Check if an app is installed.

```swift
if Karte.isInstalled(.citymapper) {
    print("Citymapper is installed 🎉")
}
```

Launch a specific app with directions.

```swift
let coordinate = CLLocationCoordinate2D(latitude: 52.5162746, longitude: 13.3755153)
let berlin = Location(name: "Brandenburger Tor Berlin", coordinate: coordinate)
try? Karte.launch(app: .googleMaps, destination: berlin)
```

Or directly present the user with an action sheet listing all installed navigation apps to pick from.

```swift
Karte.presentPicker(destination: location, on: viewController)
```



`.launch()` and `.presentPicker()` have a few extra parameters with default values set that you can change to your liking. Most important to note would be an origin location, which can of course also be specified. Leaving it blank defaults to the user's current location in most apps.



## Caveat

Please be aware that for `.isInstalled()` or `.presentPicker()` to work you will have to have added the necessary URL schemes to your app's `Info.plist` beforehand. See [Apple's Docs](https://developer.apple.com/reference/uikit/uiapplication/1622952-canopenurl#discussion) for more info on this. The necessary URL schemes can be found [here](https://github.com/kiliankoe/Karte/blob/master/Sources/MapsApp.swift#L24). You're still free to try and launch apps via `Karte.launch(app:to:)` regardless of registered URL schemes, although that obviously might result in nothing happening if the app isn't there. Don't forget that even Apple Maps can be "uninstalled" now 😉

The section to add to your `Info.plist` should look like this:

```xml
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>comgooglemaps</string>
        <string>transit</string>
        <string>citymapper</string>
        <string>navigon</string>
        <string>waze</string>
        <string>yandexnavi</string>
        <string>moovit</string>
        <string>uber</string>
        <string>lyft</string>
    </array>
```



## Installation

Karte is available through Carthage/Punic and Cocoapods, take your pick.

```swift
// Carthage
github "kiliankoe/dvb"

// Cocoapods
pod 'Karte'
```



## Authors

Kilian Koeltzsch, [@kiliankoe](https://github.com/kiliankoe)



## Credits

This library is based on [CMMapLauncher](https://github.com/citymapper/CMMapLauncher). Unfortunately development on that library seems to have been stopped, so this is a reimplementation in Swift including a few changes and other apps to make usage even more pleasant 😊



## "Karte"?

It's German for "Map" and that seemed fitting 🤷‍♀️
