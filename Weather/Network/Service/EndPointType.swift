//
//  EndPointType.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

/// This protocol will contain all the necessary information to configure the request.
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
