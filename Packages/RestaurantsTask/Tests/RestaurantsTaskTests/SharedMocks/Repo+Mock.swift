@testable import RestaurantsTask

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
            distance: 0.0,
            rating: 0.0)
    }
}
