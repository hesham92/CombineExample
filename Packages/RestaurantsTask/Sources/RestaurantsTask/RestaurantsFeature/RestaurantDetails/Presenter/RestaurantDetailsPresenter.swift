import Foundation

struct RestaurantDetailsViewModel: Equatable, Hashable {
    let imageURL: URL?
    let name: String
    let description: String
    let hours: String
    let rating: String
}

protocol RestaurantsDetailsPresenter {
    func configure(with view: RestaurantsDetailsView)
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
    
    func configure(with view: RestaurantsDetailsView) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateUI(viewModel: createViewModel(restaurant: restaurant))
    }
    
    private func createViewModel(restaurant: Restaurant) -> RestaurantDetailsViewModel {
        RestaurantDetailsViewModel(
            imageURL: URL(string: restaurant.image),
            name: restaurant.name,
            description: restaurant.description,
            hours: restaurant.hours,
            rating: String(restaurant.rating)
        )
    }
    
    // MARK: - Private
    private var restaurant: Restaurant
    private weak var view: RestaurantsDetailsView?
}
