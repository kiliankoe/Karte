//
//  Extensions.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

import Foundation

internal extension String {
    var urlQuery: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
