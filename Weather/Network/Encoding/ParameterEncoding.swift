//
//  ParameterEncoding.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

typealias Parameters = [String: Any]

/// Parameter encode
protocol ParameterEncoder {

    /// Responsible for implementing encoding the request
    /// - Parameters:
    ///   - urlRequest: URL Request
    ///   - parameters: Parameter of dictionary type
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    /// Encoding the value
    /// - Parameters:
    ///   - urlRequest: URL Request
    ///   - bodyParameters: Body Parameters
    ///   - urlParameters: URL Parameters
    /// - Throws: Throw Error
    func encode(urlRequest: inout URLRequest,
                bodyParameters: Parameters?,
                urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        }catch {
            throw error
        }
    }
}

/// Managing network error
enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
