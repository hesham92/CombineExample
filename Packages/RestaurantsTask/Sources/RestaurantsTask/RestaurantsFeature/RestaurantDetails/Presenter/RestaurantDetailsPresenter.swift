import Foundation

struct RestaurantDetailsViewModel: Equatable, Hashable {
    let image: String
    let name: String
    let description: String
    let hours: String
    let distance: Double
    let rating: Double
}

protocol RestaurantsDetailsPresenter {
    func configure(with viewDelegate: RestaurantsDetailsView)
    func viewDidLoad()
}

protocol RestaurantsDetailsView: AnyObject {
    func updateUI(viewModel: RestaurantDetailsViewModel)
}

final class DefaultRestaurantDetailsPresenter: RestaurantsDetailsPresenter {
    // MARK: - Public
    init(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func configure(with viewDelegate: RestaurantsDetailsView) {
        self.viewDelegate = viewDelegate
    }
    
    func viewDidLoad() {
        viewDelegate?.updateUI(viewModel: createViewModel(restaurant: restaurant))
    }
    
    private func createViewModel(restaurant: Restaurant) -> RestaurantDetailsViewModel {
        RestaurantDetailsViewModel(
            image: restaurant.image,
            name: restaurant.name,
            description: restaurant.description,
            hours: restaurant.hours,
            distance: restaurant.distance,
            rating: restaurant.rating
        )
    }
    
    // MARK: - Private
    private var restaurant: Restaurant
    private weak var viewDelegate: RestaurantsDetailsView?
}
