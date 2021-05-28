//
//  HTTPMethod.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

/// This listing will be used to set the HTTP method of our request.
enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
