import Foundation

struct RestaurantViewModel: Equatable, Hashable {
    let imageURL: URL?
    let name: String
}

enum RestaurantsListState {
    case idle
    case loading
    case loaded([RestaurantViewModel])
    case error(GenericErrorViewModel)
}

protocol RestaurantsListPresenter {
    var state: RestaurantsListState { get }
    func configure(with view: RestaurantsListView)
    func didSelectRestaurantAtIndex(_ index: Int)
    func didSelectSegmentAtIndex(_ index: Int)
    func viewDidLoad() async
}

protocol RestaurantsListView: AnyObject {
    func stateDidChange()
    func navigateToRestaurantDetails(restaurant: Restaurant)
}

final class DefaultRestaurantsListPresenter: RestaurantsListPresenter {
    // MARK: - Public
    init(service: HttpServiceProtocol = HttpService()){
        self.service = service
    }
    
    private(set) var state: RestaurantsListState = .idle {
        didSet {
            view?.stateDidChange()
        }
    }
    
    func didSelectRestaurantAtIndex(_ index: Int) {
        view?.navigateToRestaurantDetails(restaurant: restaurants[index])
    }
    
    func didSelectSegmentAtIndex(_ index: Int) {
        var sortedRestaurants: [Restaurant] = []
        
        switch SortingCriteria(rawValue: index) {
        case .default, .none:
            sortedRestaurants = restaurants
        case .distance:
            sortedRestaurants = restaurants.sorted { $0.distance < $1.distance }
        case .rating:
            sortedRestaurants = restaurants.sorted { $0.rating > $1.rating }
        }
        
        state = .loaded(makeViewModel(restaurants: sortedRestaurants))
    }
    
    func configure(with view: RestaurantsListView) {
        self.view = view
    }
    
    func viewDidLoad() async {
        await fetchRestaurants()
    }
    
    // MARK: - Private
    @MainActor
    private func fetchRestaurants() async {
        state = .loading
        do {
            restaurants = try await service.request(endpoint: RestaurantsEndpoint.getRestaurants, modelType: [Restaurant].self)
            state = .loaded(makeViewModel(restaurants: restaurants))
        } catch {
            restaurants.removeAll()
            state = .error(makeErrorViewModel(error: error))
        }
    }
    
    private func makeViewModel(restaurants: [Restaurant]) -> [RestaurantViewModel] {
        var restaurantsViewModels: [RestaurantViewModel] = []
        for restaurant in restaurants {
            restaurantsViewModels.append(RestaurantViewModel(imageURL: URL(string: restaurant.image), name: restaurant.name))
        }
        return restaurantsViewModels
    }
    
    private func makeErrorViewModel(error: Error) -> GenericErrorViewModel {
        GenericErrorViewModel(description: error.localizedDescription, onRetryTapped: { [weak self] in
            guard let self else { return }
            Task {
                await self.fetchRestaurants()
            }
        })
    }
    
    private enum SortingCriteria: Int, CaseIterable {
        case `default` = 0
        case distance = 1
        case rating = 2
    }
    
    private let service: HttpServiceProtocol
    private weak var view: RestaurantsListView?
    private var restaurants: [Restaurant] = []
}
