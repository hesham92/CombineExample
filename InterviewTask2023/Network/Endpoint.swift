import Foundation

protocol Endpoint {
    var baseURL: URL { get } 
    var path: String { get }
    var method: HttpMethod { get }
    var bodyParameters: [String: Any]? { get }
    var headers: [String: String] { get }
    func urlRequest() -> URLRequest
}

extension Endpoint {
    func urlRequest() -> URLRequest {
        let urlPath = [self.baseURL.absoluteString, self.path].joined()
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        self.headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let bodyParameters = bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        }
        
        return request
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
