//
//  HTTPTask.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

typealias HTTPHeaders = [String: String]


///  HTTPTask is responsible for configuring the parameters of a specific request
enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)

}
