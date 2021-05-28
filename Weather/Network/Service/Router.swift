//
//  Router.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

/*
 In NetworkRouter have EndPoint , which he uses to request and as soon as a request is completed, the result of this request is transmitted to the circuit NetworkRouterCompletion . The protocol also has a cancel function , which can be used to interrupt long-term load and unload requests. We also used associatedtype here because we want our Router to support any type of EndPointType . Without the use of associatedtype, the router would have to have some specific type implementing EndPointType
 */
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

/// Manages routing
class Router<EndPoint: EndPointType>: NetworkRouter {
    
    /// URLSessionTask, this is private because we don’t want anyone outside to be able to change it
    private var task: URLSessionTask?
    
    /// Simple request
    /// - Parameters:
    ///   - route: Route
    ///   - completion: NetworkRouterCompletion
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    /// Cancel the task
    func cancel() {
        self.task?.cancel()
    }
    
    /// This function is responsible for all the vital work in our network layer. Essentially converts EndPointType to URLRequest . And as soon as EndPoint turns into a request, we can pass it to session
    /// - Parameter route: Router
    /// - Throws: Error throws
    /// - Returns: URL Request
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        /// initialize the URLRequest request variable .  Set  base URL in it and add the path of the specific request that will be used to it.
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        ///  Assign request.httpMethod the http method from our EndPoint
        request.httpMethod = route.httpMethod.rawValue
    
        /// create a do-try-catch block, because our encoders may throw an error. By creating one large do-try-catch block, we eliminate the need to create a separate block for each try.
        /// In switch, check route.task
        /// Depending on the type of task, we call the corresponding encoder.
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    /*
     This function is responsible for converting our query parameters. Since our API assumes the use of bodyParameters in the form of JSON and URLParameters converted to the URL format, we simply pass the appropriate parameters to the corresponding conversion functions, which we described at the beginning of the article. If you use an API that includes various types of encodings, then in this case I would recommend adding HTTPTask optional enumeration with encoding type. This listing should contain all possible types of encodings. After that, in configureParameters add one more argument with this enumeration. Depending on its value, switch using switch and make the encoding you need
     */
    /// - Parameters:
    ///   - bodyParameters: Body Parameters
    ///   - bodyEncoding: Body Encoding
    ///   - urlParameters: URL Parameters
    ///   - request: Request
    /// - Throws: Error throws
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    /// For adding additional headers
    /// - Parameters:
    ///   - additionalHeaders: Additional headers
    ///   - request: URL Request
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
