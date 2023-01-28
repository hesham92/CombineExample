import XCTest
@testable import RestaurantsTask

class HttpServiceMock: HttpServiceProtocol {
    typealias MockedResult<MockModelType: Codable> = Result<MockModelType, Error>
    private var result: Any!
    func setResult<MockModelType: Codable>(_ result: MockedResult<MockModelType>) {
        self.result = result
    }
    func request<ModelType>(endpoint: RestaurantsTask.Endpoint, modelType: ModelType.Type) async throws -> ModelType where ModelType : Decodable, ModelType : Encodable {
        try (
            result as! Result<ModelType, Error>
        ).get()
    }
}
