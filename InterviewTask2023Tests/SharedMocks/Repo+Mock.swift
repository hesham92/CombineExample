@testable import InterviewTask2023

extension Restaurant {
    static func mock(
        name: String = "testName",
        image: String = "testImage"
    ) -> Restaurant {
        Restaurant(
            image: "",
            name: "",
            description: "",
            hours: "",
            rating: 8.0)
    }
}

class HttpServiceMock: HttpServiceProtocol {
    typealias MockedResult<MockModelType: Codable> = Result<MockModelType, Error>
    private var result: Any!
    func setResult<MockModelType: Codable>(_ result: MockedResult<MockModelType>) {
        self.result = result
    }
    func request<ModelType>(endpoint: InterviewTask2023.Endpoint, modelType: ModelType.Type) async throws -> ModelType where ModelType : Decodable, ModelType : Encodable {
        try (
            result as! Result<ModelType, Error>
        ).get()
    }
}
