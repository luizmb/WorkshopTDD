import Foundation

public protocol URLSessionProtocol {
    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
extension URLSession: URLSessionProtocol {
    public func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}

// Alternative, using Combine
import Combine

public protocol URLSessionProtocolUsingCombine {
    func request(url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocolUsingCombine {
    public func request(url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}

// Or:
//public typealias URLRequester = (URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
//let requester: URLRequester = { url in
//    URLSession.shared.dataTaskPublisher(for: url).eraseToAnyPublisher()
//}
//let mockRequester: URLRequester = { _ in
//    Just((data: Data(), response: .init())).setFailureType(to: URLError.self).eraseToAnyPublisher()
//}
