//
//  Extensions.swift
//  Karte
//
//  Created by Kilian Költzsch on 13.04.17.
//  Copyright © 2017 Karte. All rights reserved.
//

internal extension String {
    var urlQuery: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

internal extension Dictionary where Key == String, Value == String {
    var urlParameters: String {
        return self
            .map {"\($0)=\($1.urlQuery ?? "")"}
            .sorted() // basically only needed so that the tests can be deterministic
            .joined(separator: "&")
    }

    mutating func set<T>(_ key: String, _ value: T?) {
        if let value = value {
            self[key] = "\(value)"
        }
    }
}
