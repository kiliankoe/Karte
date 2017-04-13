//
//  Error.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case notInstalled
    case unsupportedMode
    case malformedURL
}
