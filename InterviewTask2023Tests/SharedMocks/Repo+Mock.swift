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
