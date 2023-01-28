@testable import RestaurantsTask

extension Restaurant {
    static func mock(
        image: String = "",
        name: String = "",
        description: String = "",
        hours: String = "",
        distance: Double = 0.0,
        rating: Double = 0.0
    ) -> Restaurant {
        Restaurant(
            image: image,
            name: name,
            description: description,
            hours: hours,
            distance: distance,
            rating: rating
        )
    }
}
