import Foundation

extension URLSession: URLSessionProtocol {}

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

typealias PerformRequest<ModelType: Codable> = (
    _ endpoint: Endpoint,
    _ modelType: ModelType.Type,
    _ responseData: @escaping (Result<ModelType, Error>) -> Void
) -> Void

func makePerformRequest<ModelType: Codable>() -> PerformRequest<ModelType> {
    {
        HttpService().request(endpoint: $0, modelType: $1, responseData: $2)
    }
}

class HttpService {
    // MARK: - Public
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<ModelType: Codable>(
        endpoint: Endpoint,
        modelType: ModelType.Type,
        responseData: @escaping (Result<ModelType, Error>) -> Void
    ) {
        let task = session.dataTask(with: endpoint.urlRequest()) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    responseData(.failure(error))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(ModelType.self, from: data)
                responseData(.success(result))
            } catch {
                responseData(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private
    private var session: URLSessionProtocol
}
