import Foundation

extension URLSession: URLSessionProtocol {}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol HttpServiceProtocol {
    func request<ModelType: Codable>(
        endpoint: Endpoint,
        modelType: ModelType.Type
    ) async throws -> ModelType
}

class HttpService: HttpServiceProtocol {
    // MARK: - Public
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<ModelType: Codable>(
        endpoint: Endpoint,
        modelType: ModelType.Type
    ) async throws -> ModelType {
        let (data, _) = try await session.data(for: endpoint.urlRequest())
        return try JSONDecoder().decode(ModelType.self, from: data)
    }
    
    // MARK: - Private
    private var session: URLSessionProtocol
}
